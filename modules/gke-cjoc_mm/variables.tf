variable cluster_name {
    description = "The name of the GKE cluster to create"
    default = "cbcore-terraform"
}
variable "gcp-project" {
    description = "The Google Cloud Platform project to deploy resources"
}
variable "num-nodes" {
    description = "Number of nodes for the pool to use in the GKE cluster"
    default = 3
}
variable "gcp-region" {
    description = "Let's specify a region to use in GCP"
}
variable "gcp-zone" {
    description = "And use a zone within a GCP region"
}
variable "machine_type" {
    description = "The machine type for the nodes"
  
}



