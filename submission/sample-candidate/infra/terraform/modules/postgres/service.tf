resource "kubernetes_service_v1" "postgres" {

  metadata {
    name      = var.service_name
    namespace = var.namespace

    labels =local.common_labels
  }

  spec {
    cluster_ip = "None"
    selector = {
      app = var.app_label
    }
    port {
      name        = "postgres"
      port        = 5432
      target_port = 5432
      protocol    = "TCP"
    }
  }
}