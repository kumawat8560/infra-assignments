variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "labels" {
  description = "Common labels"
  type        = map(string)
}

variable "postgres_image" {
  description = "PostgreSQL Docker image"
  type        = string
  default     = "postgres:16"
}

variable "postgres_db" {
  description = "Database name"
  type        = string
}

variable "postgres_user" {
  description = "Database username"
  type        = string
}

variable "postgres_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "storage_size" {
  description = "Persistent volume size"
  type        = string
  default     = "5Gi"
}

variable "service_name" {
  description = "PostgreSQL service name"
  type        = string
  default     = "postgres"
}
variable "secret_name" {
  description = "Name of the Kubernetes secret"
  type        = string
}

variable "app_label" {
  description = "Application label used by PostgreSQL resources"
  type        = string
  default     = "postgres"
}
variable "replicas" {
  description = "Number of PostgreSQL replicas"
  type        = number
  default     = 1
}

variable "storage_class_name" {
  description = "StorageClass name"
  type        = string
}

