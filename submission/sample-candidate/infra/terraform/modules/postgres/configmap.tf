resource "kubernetes_config_map_v1" "postgres_init" {

  metadata {
    name      = "postgres-init-sql"
    namespace = var.namespace

    labels = local.common_labels
  }

  data = {
    "init.sql" = file("${path.module}/init.sql")
  }
}