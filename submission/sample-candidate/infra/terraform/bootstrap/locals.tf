locals {
  app_name = var.app_name

  common_labels = {
    app        = var.app_name
    managed-by = "terraform"
  }
}
