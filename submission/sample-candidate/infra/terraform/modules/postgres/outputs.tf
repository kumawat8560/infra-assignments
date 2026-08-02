output "service_name" {
  description = "PostgreSQL Service name"

  value = kubernetes_service_v1.postgres.metadata[0].name
}