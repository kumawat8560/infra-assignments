variable "namespace" {
  description = "Kubernetes namespace for the config service"
  type        = string
  default     = "config-service"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "config-service"
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type = string
}

variable "node_image" {
  description = "Kind node image"
  type = string
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type = number
}

variable "worker_count" {
  description = "Number of worker nodes"
  type = number
}
variable "wait_for_ready" {
  description = "Wait until the cluster is ready"
  type    = bool
  default = true
}