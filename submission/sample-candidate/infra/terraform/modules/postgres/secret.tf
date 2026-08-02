resource "kubernetes_secret_v1" "postgres" {

  metadata {
    name      = var.secret_name
    namespace = var.namespace
    labels    = var.labels
  }

  type = "Opaque"

  data = {

    # Used by the Go application
    DATABASE_URL = format(
      "postgres://%s:%s@%s:5432/%s?sslmode=disable",
      var.postgres_user,
      var.postgres_password,
      var.service_name,
      var.postgres_db
    )

    # Used by the PostgreSQL container
    POSTGRES_DB       = var.postgres_db
    POSTGRES_USER     = var.postgres_user
    POSTGRES_PASSWORD = var.postgres_password
  }
}