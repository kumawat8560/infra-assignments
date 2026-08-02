module "kind" {
  source              = "../modules/kind"
  cluster_name        = var.cluster_name
  node_image          = var.node_image
  control_plane_count = var.control_plane_count
  worker_count        = var.worker_count
}

