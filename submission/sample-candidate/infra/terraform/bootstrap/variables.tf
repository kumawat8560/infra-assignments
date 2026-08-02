variable "app_name" {
  description = "Application name"
  type        = string
  default     = "config-service"
}

variable "cluster_name" {
  type = string
}

variable "node_image" {
  type = string
}

variable "control_plane_count" {
  type = number
}

variable "worker_count" {
  type = number
}
variable "wait_for_ready" {
  type    = bool
  default = true
}