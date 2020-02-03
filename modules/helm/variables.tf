# variable "username" {
#   description = "The Kubernetes username"
#   default = "admin"
# }
# variable "password" {
#   description = "A password to be generated during provisioning"
# }
variable "token" {
  description = "The Kubernetes client token"
}
variable "host" {
  description = "The Kubernetes host master endpoint"
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
variable "helm_sa" {
  description = "Tiller serviceaccount"
}
variable "tiller_namespace" {
  description = "Tiller namespace"
}
# variable "values_yaml" {
#   description "values.yaml where the Helm settings are configured fot the NGINX ingress controller"
#   # default = "ingress.yaml"
# }
# variable "values_yaml" {
#   description "values.yaml where the Helm settings are configured"
#   default = "cloudbees-core.yaml"
# }
variable "cbcore_namespace" {
  description = "The namespace where CloudBees Core will be installed"
}
variable "ingress_namespace" {
  description = "The namespace where NGINX Ingress controller will be installed"
}
variable "cjoc_host" {
  description = "Hostname for the Operations Center CJOC"
}