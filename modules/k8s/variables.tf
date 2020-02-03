# variable "username" {
#   description = "The Kubernetes username"
#   default = "admin"
# }
# variable "password" {
#   description = "A password to be generated during provisioning"
# }
variable "host" {
  description = "The Kubernetes host master endpoint"
}

variable "token" {
  description = "The Kubernetes client token"
}

variable "client_certificate" {
  description = "The K8s client cert"
}
variable "client_key" {
  description = "The Kubernetes client key"
}
variable "cluster_ca_certificate" {
  description = "The cluster cert for Kubernetes"
}
# variable "gke_version" {
#   description = "Variable to set dependencie on gke module with the version"
# }
