variable "credentials" {
    description = "Specifying GCP credentials JSON key"
}
variable "numnodes" {
    description = "Number of nodes of GKE node pool"
}
variable "project" {
  description = "GCP project definition. A variable to be set when executing Terraform CLI"
}
variable "gcp-region" {
    description = "Let's specify a region to use in GCP"
}
variable "gcp-zone" {
    description = "And use a zone within a GCP region"
}
variable "image" {
  description = "True if using Instance Template image to create client masters or False if not"
  default = true
}
variable "cjoc_host" {
  description = "The hostname DNS to use for the CloudBees Operations Center"
  default = ""
}
variable "node_type" {
  description = "The GCP machine type for the nodes of the GKE cluster"
  default = "n1-standard-2"
}



# variable "username" {
#   description = "The Kubernetes username"
#   default = "admin"
# }
# variable "password" {
#   description = "A password to be generated during provisioning"
# }



