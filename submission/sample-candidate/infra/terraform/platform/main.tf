

module "namespace" {
  source    = "../modules/namespace"
  namespace = var.namespace
}


module "postgres" {

  source = "../modules/postgres"
  namespace = module.namespace.name
  service_name = var.service_name
  postgres_image = var.postgres_image
  postgres_db = var.postgres_db
  postgres_user = var.postgres_user
  postgres_password = var.postgres_password
  storage_size = var.storage_size
  storage_class_name = var.storage_class_name
  secret_name = var.secret_name
  replicas = var.replicas

  depends_on = [
    module.namespace
  ]
}