# data "google_container_cluster" "gke_cluster" {
#     name = "${google_container_cluster.cb-core.name}"
#     location = "${google_container_cluster.cb-core.location}"
# }
output "cluster_name" {
  value = "${google_container_cluster.cb-core.name}"
}
output "cluster_endpoint" {
  depends_on = [
    google_container_node_pool.primary_nodepool,
  ]
  value = "${google_container_cluster.cb-core.endpoint}"
}
output "client_certificate" {
  value = "${google_container_cluster.cb-core.master_auth.0.client_certificate}"
  sensitive = true
}
output "client_key" {
  value = "${google_container_cluster.cb-core.master_auth.0.client_key}"
  sensitive = true
}
output "cluster_ca_certificate" {
  value = "${google_container_cluster.cb-core.master_auth.0.cluster_ca_certificate}"
  sensitive = true
}
output "username" {
  value = "${google_container_cluster.cb-core.master_auth.0.username}"
}
output "password" {
  value = "${google_container_cluster.cb-core.master_auth.0.password}"
  sensitive = true
}
# output "nodes_version" {
#   value = "${google_container_node_pool.primary_nodepool.version}"
# }

