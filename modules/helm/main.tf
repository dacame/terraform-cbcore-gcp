provider "helm" {
  install_tiller = true
  service_account = "${var.helm_sa}"
  namespace = "${var.tiller_namespace}"

  kubernetes {
    load_config_file = false
    host = "${var.host}"
    # username = "${var.username}"
    # password = "${var.password}"
    token = "${var.token}"

    client_certificate = "${base64decode(var.client_certificate)}"
    client_key = "${base64decode(var.client_key)}"
    cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  }
}
provider "kubernetes" {
    load_config_file = false
    host = "${var.host}"
    # username = "${var.username}"
    # password = "${var.password}"
    token = "${var.token}"

    client_certificate = "${base64decode(var.client_certificate)}"
    client_key = "${base64decode(var.client_key)}"
    cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
}

data "helm_repository" "cloudbees" {
  name = "cloudbees"
  url  = "https://charts.cloudbees.com/public/cloudbees"
}
data "helm_repository" "ingress" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}
# data "helm_repository" "ingress" {
#   name = "stable-nginx"
#   url  = "https://helm.nginx.com/stable"
# }

# Let's create some locals to use it in the Helm ingress installation to maintain service naming convention
locals {
  ingress_service = "cloudbees-ingress"
  controller_name = "cb-controller"
}
resource "helm_release" "ingress" {
  name       = "nginx-ingress"
  repository = "${data.helm_repository.ingress.metadata[0].name}"
  chart      = "nginx-ingress"
  namespace = "${var.ingress_namespace}"
  version = "1.4.0"
  

#   values = [
#     "${file("ingress.yaml")}"
#   ]
  # Let's define the different parameters of the Helm installation in a raw yaml
  # We are considering that the ingress service is named by "fullnameOverride-controllername"
  values = [<<EOF
fullnameOverride: "${local.ingress_service}"
rbac:
  create: true
defaultBackend:
  enabled: false
controller:
  name: "${local.controller_name}"
  ingressClass: "nginx"
#    scope:
#      enabled: true
#      namespace: "${var.cbcore_namespace}"
service:
  externalTrafficPolicy: "Local"
tcp:
  50000: "${var.cbcore_namespace}/cjoc:50000"
EOF
  ]
#   values = [<<EOF
# rbac:
#   create: true
# defaultBackend:
#   enabled: false
# controller:
#   ingressClass: "nginx"
#   watchNamespace: ${var.cbcore_namespace}
#   config: 
#     entries:
#       stream-snippets: |
#         upstream cjoc-tcp {
#           server cjoc.${var.cbcore_namespace}.svc.cluster.local:50000;
#         }
#         server {
#           listen 50000;
#           proxy_pass cjoc-tcp;
#         }
#   customPorts:
#     - name: 50000-tcp
#       containerPort: 50000
#       protocol: TCP
#   service:
#     externalTrafficPolicy: "Local"
#     name: "${local.ingress_service}"
#     customPorts:
#       - protocol: TCP
#         port: 50000
#         name: 50000-tcp
# EOF
#   ]

}

# We get the service name of the ingress deployed by Helm, because we want to use it to get later
# the LoadBalancer IP with the Kubernetes provider
data "kubernetes_service" "ingress" {
#   depends_on = [
#     helm_release.ingress
#   ]
  metadata {
    name = "${local.ingress_service}-${local.controller_name}"
    # name = "${local.ingress_service}"
    namespace = "${helm_release.ingress.metadata.0.namespace}"
  }
}
locals {
  cjoc_hostname = "${var.cjoc_host}" != "" ? "${var.cjoc_host}" : "${data.kubernetes_service.ingress.load_balancer_ingress.0.ip}.nip.io"
}

resource "helm_release" "cbcore" {
  depends_on = [
      helm_release.ingress,
  ]
  name       = "cloudbees-core"
  repository = "${data.helm_repository.cloudbees.metadata[0].name}"
  chart      = "cloudbees-core"
  namespace = "${var.cbcore_namespace}"
  # version    = "3.8.0+a0d07461ae1c"
  wait = false

#   values = [
#     "${file("${var.values_yaml}")}"
#   ]

  values = [<<EOF
nginx-ingress:
  Enabled: false
  tcp:
    50000: "${var.cbcore_namespace}/cjoc:50000"
EOF
  ]

  set {
    name  = "OperationsCenter.HostName"
    value = "${local.cjoc_hostname}"  
  }  
}

output "cjoc" {
  value = "${local.cjoc_hostname}"
}


