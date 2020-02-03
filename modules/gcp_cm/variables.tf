variable "gcp-project" {
    description = "The Google Cloud Platform project to deploy resources"
}
variable "template_name" {
    description = "The image template to be used for creating the vm"
}
variable "gcp-region" {
    description = "Let's specify a region to use in GCP"
}
variable "gcp-zone" {
    description = "And use a zone within a GCP region"
}
variable "machine_type" {
    description = "The machine type for the vm"
  
}
variable "image-family" {
    description = "Family name for the image to be created"
    default = "cloudbees-core"
}
variable "packer-image" {
    description = "This is a boolean variable to decide if creating an instance template depending on a Packer image creation"
    # default = true
}

