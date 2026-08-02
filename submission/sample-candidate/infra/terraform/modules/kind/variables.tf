variable "cluster_name" {
  description = "Kind cluster name"
  type        = string
}

variable "node_image" {
  description = "Kind node image"
  type        = string
  default     = "kindest/node:v1.33.1"
}

variable "control_plane_count" {
  description = "Number of control plane nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.control_plane_count >= 1
    error_message = "At least one control plane node is required."
  }
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.worker_count >= 0
    error_message = "Worker node count cannot be negative."
  }
}

variable "wait_for_ready" {
  description = "Wait until the cluster is ready"
  type        = bool
  default     = true
}