terraform {
  backend gcs {
    # bucket = "terraform-emea-sa-state"
    # prefix = "terraform/cbcore-gcp"
    # prefix = "terraform/cbcore-anthos-lab"
  }
}

data "google_client_config" "default" {
}

module "gke_cluster" {
  source = "../modules/gke-cjoc_mm"

  cluster_name = "lab-cbcore"
  gcp-project = "${var.project}"
  gcp-region = "europe-west1"
  gcp-zone = "europe-west1-c"
  num-nodes = "${var.numnodes}"
  machine_type = "${var.node_type}"
}

module "client_masters" {
  # When implementing count in modules (expected in Terraform 0.13)
  # count = "${var.packer-image}" ? 1 : 0
  source = "../modules/gcp_cm"

  gcp-project = "${var.project}"
  gcp-region = "europe-west1"
  gcp-zone = "europe-west1-c"
  template_name = "cbcore-client-master"
  machine_type = "n1-standard-2"

  packer-image = "${var.image}"
}

module "k8s" {
  source = "../modules/k8s"

  host = "${module.gke_cluster.cluster_endpoint}"
  token = "${data.google_client_config.default.access_token}"
  # username = "${module.gke_cluster.username}"
  # password = "${module.gke_cluster.password}"
  
  client_certificate = "${module.gke_cluster.client_certificate}"
  client_key = "${module.gke_cluster.client_key}"
  cluster_ca_certificate = "${module.gke_cluster.cluster_ca_certificate}"

  # gke_version = "${module.gke_cluster.nodes_version}"
}

module "helm" {
  source = "../modules/helm"

  host = "${module.gke_cluster.cluster_endpoint}"
  # username = "${module.gke_cluster.username}"
  # password = "${module.gke_cluster.password}"
  token = "${data.google_client_config.default.access_token}"
  
  client_certificate = "${module.gke_cluster.client_certificate}"
  client_key = "${module.gke_cluster.client_key}"
  cluster_ca_certificate = "${module.gke_cluster.cluster_ca_certificate}" 
  
  helm_sa = "${module.k8s.tiller_sa}"
  tiller_namespace ="${module.k8s.tiller_namespace}"
  ingress_namespace = "${module.k8s.nginx_namespace}"
  cbcore_namespace = "${module.k8s.cbcore_namespace}"
  cjoc_host = "${var.cjoc_host}"
}

