resource "google_container_cluster" "cb-core" {
  name     = "${var.cluster_name}"
  location = "${var.gcp-zone}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # master_auth {
  #   username = ""
  #   password = ""

  #   client_certificate_config {
  #     issue_client_certificate = false
  #   }
  # }
}

resource "google_container_node_pool" "primary_nodepool" {
  name       = "master-pool"
  location   = "${var.gcp-zone}"
  cluster    = "${google_container_cluster.cb-core.name}"
  initial_node_count = "${var.num-nodes}"

  node_config {
    # preemptible  = true
    machine_type = "${var.machine_type}"
    disk_type = "pd-ssd"

    metadata = {
      disable-legacy-endpoints = "true"
    }
    # Check the Oauth scopes aliases at https://cloud.google.com/sdk/gcloud/reference/compute/instances/create 
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  autoscaling {
      min_node_count = 3
      max_node_count = 6
  }
}
