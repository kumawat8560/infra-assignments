variable "namespace" {
  description = "Kubernetes namespace for the config service"
  type        = string
  default     = "config-service"
}


variable "labels" {
  description = "Labels to apply to the namespace"
  type        = map(string)
  default     = {}
}
