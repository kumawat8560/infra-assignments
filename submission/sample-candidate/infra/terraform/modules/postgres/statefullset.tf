resource "kubernetes_stateful_set_v1" "postgres" {

  metadata {
    name      = var.service_name
    namespace = var.namespace

    labels = {
      app        = var.app_label
      managed-by = "terraform"
    }
  }

  spec {

    replicas     = var.replicas
    service_name = kubernetes_service_v1.postgres.metadata[0].name

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {

      metadata {
        labels = {
          app        = var.app_label
          managed-by = "terraform"
        }
      }

      spec {

        container {

          name  = var.service_name
          image = var.postgres_image

          port {
            container_port = 5432
          }

          env {
            name = "POSTGRES_DB"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres.metadata[0].name
                key  = "POSTGRES_DB"
              }
            }
          }

          env {
            name = "POSTGRES_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres.metadata[0].name
                key  = "POSTGRES_USER"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres.metadata[0].name
                key  = "POSTGRES_PASSWORD"
              }
            }
          }

          volume_mount {

            name = "postgres-data"

            mount_path = "/var/lib/postgresql/data"
          }

          volume_mount {

            name = "postgres-init"

            mount_path = "/docker-entrypoint-initdb.d"
          }
        }

        volume {

          name = "postgres-init"

          config_map {
            name = kubernetes_config_map_v1.postgres_init.metadata[0].name
          }
        }
      }
    }

    volume_claim_template {

      metadata {
        name = "postgres-data"
      }

      spec {

        access_modes = [
          "ReadWriteOnce"
        ]

        storage_class_name = var.storage_class_name

        resources {

          requests = {
            storage = var.storage_size
          }
        }
      }
    }
  }
}