package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"config-service/internal/handler"
	"config-service/internal/repository"
	"config-service/internal/service"
)

func main() {
	portStr := os.Getenv("APP_PORT")
	if portStr == "" {
		portStr = "8080"
	}

	port, err := strconv.Atoi(portStr)
	if err != nil || port < 1 || port > 65535 {
		log.Fatal("APP_PORT must be an integer between 1 and 65535")
	}

	databaseURL := os.Getenv("DATABASE_URL")
	var repo repository.Repository
	if databaseURL == "" {
		log.Println("DATABASE_URL not configured. Using in-memory repository.")
		repo = repository.NewInMemory()
	} else {
		postgresRepo, err := repository.NewPostgresRepository(databaseURL)
		if err != nil {
			log.Fatalf("failed to connect to PostgreSQL: %v", err)
		}
		defer postgresRepo.Close()
		log.Println("Connected to PostgreSQL.")
		repo = postgresRepo
	}
	svc := service.New(repo)
	h := handler.New(svc)

	mux := http.NewServeMux()
	h.RegisterRoutes(mux)

	srv := &http.Server{
		Addr:         fmt.Sprintf(":%d", port),
		Handler:      mux,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	log.Printf("starting config-service on :%d", port)

	if err := srv.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}
