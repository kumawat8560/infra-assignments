variable "app_name" {
  description = "Application name"
  type        = string
  default     = "config-service"
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "config-service"
}

variable "postgres_image" {
  type = string
}

variable "postgres_db" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "storage_size" {
  type = string
}

variable "service_name" {
  type = string
}
variable "secret_name" {
  type = string
}
variable "postgres_app_label" {
  type = string
}

variable "replicas" {
  type = number
}
variable "storage_class_name" {
  description = "StorageClass name"
  type        = string
}
