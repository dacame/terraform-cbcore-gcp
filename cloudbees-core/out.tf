# Let's define output variables from the module outputs. 
output "cluster_name" {
  value = "${module.gke_cluster.cluster_name}"
}
output "endpoint" {
  value = "${module.gke_cluster.cluster_endpoint}"
}
# output "user" {
#   value = "${module.gke_cluster.username}"
# }
output "cjoc" {
  value = "${module.helm.cjoc}"
}



