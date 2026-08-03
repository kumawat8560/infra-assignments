package repository

import (
	"context"
	"errors"

	"config-service/internal/domain"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// PostgresRepository implements the Repository interface using PostgreSQL.
type PostgresRepository struct {
	pool *pgxpool.Pool
}

// NewPostgresRepository creates a PostgreSQL-backed repository.
func NewPostgresRepository(databaseURL string) (*PostgresRepository, error) {

	pool, err := pgxpool.New(context.Background(), databaseURL)
	if err != nil {
		return nil, err
	}

	// Verify database connectivity.
	if err := pool.Ping(context.Background()); err != nil {
		pool.Close()
		return nil, err
	}

	return &PostgresRepository{
		pool: pool,
	}, nil
}

// Close releases all database connections.
func (r *PostgresRepository) Close() {
	r.pool.Close()
}

// Get retrieves a configuration by its ID.
func (r *PostgresRepository) Get(ctx context.Context, id string) (*domain.Config, error) {

	cfg := &domain.Config{}

	err := r.pool.QueryRow(
		ctx,
		`
		SELECT
			id,
			host,
			port,
			app_name,
			log_level
		FROM public.configs
		WHERE id = $1
		`,
		id,
	).Scan(
		&cfg.ID,
		&cfg.Host,
		&cfg.Port,
		&cfg.AppName,
		&cfg.LogLevel,
	)

	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, err
	}
	
	return cfg, nil
}

// Upsert creates a new configuration or updates an existing one.
func (r *PostgresRepository) Upsert(ctx context.Context, cfg *domain.Config) error {

	_, err := r.pool.Exec(
		ctx,
		`
		INSERT INTO public.configs (
			id,
			host,
			port,
			app_name,
			log_level
		)
		VALUES ($1, $2, $3, $4, $5)
		ON CONFLICT (id)
		DO UPDATE SET
			host = EXCLUDED.host,
			port = EXCLUDED.port,
			app_name = EXCLUDED.app_name,
			log_level = EXCLUDED.log_level
		`,
		cfg.ID,
		cfg.Host,
		cfg.Port,
		cfg.AppName,
		cfg.LogLevel,
	)

	return err
}