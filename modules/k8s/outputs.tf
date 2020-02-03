output "cbcore_namespace" {
  value = "${kubernetes_namespace.cloudbees_core.metadata[0].name}"
}
output "nginx_namespace" {
  value = "${kubernetes_namespace.nginx.metadata[0].name}"
}
output "tiller_sa" {
  value = "${kubernetes_service_account.tiller.metadata[0].name}"
}
output "tiller_namespace" {
  value = "${kubernetes_cluster_role_binding.tiller.subject.0.namespace}"
}

# output "k8s_version" {
#   value = "${var.gke_version}"
# }

