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


resource "kubernetes_namespace" "cloudbees_core" {
  metadata {
    name = "cloudbees-core"
  }
}
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

# Now we are creating the ServiceAccount and Role for installing Tiller

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  # api_group has to be empty because of a bug:
  # https://github.com/terraform-providers/terraform-provider-kubernetes/issues/204
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }
}
