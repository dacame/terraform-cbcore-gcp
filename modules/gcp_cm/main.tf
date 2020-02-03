# Let's create the CLient Masters machines. For that we are creating a instance template to create as many masters as we want

data "google_compute_image" "cm_image" {
  # Adding an If-Else statement to gather data depending on packer image creation first
  count = "${var.packer-image}" ? 1 : 0
  family = "${var.image-family}"
  project = "${var.gcp-project}"
}

resource "google_compute_instance_template" "instance_template" {
  # Adding an If-Else statement to create depending on packer image creation first
  count = "${var.packer-image}" ? 1 : 0
  name = "${var.template_name}"
  project = "${var.gcp-project}"
  region = "${var.gcp-region}"
  
  machine_type = "${var.machine_type}"

  disk {
    source_image = "${data.google_compute_image.cm_image[count.index].self_link}"
    # When implementing count in modules
    # source_image = "${data.google_compute_image.cm_image[count.index].self_link}"
  }
  network_interface {
    network = "default"
  }
  
}

resource "google_compute_instance_from_template" "cbcore_cm" {
  # Adding an If-Else statement to create depending on packer image creation first
  count = "${var.packer-image}" ? 1 : 0
  name = "cbcore-cm-from-template"
  zone = "${var.gcp-zone}"

  source_instance_template = "${google_compute_instance_template.instance_template[0].self_link}"
  # When implementing count in modules
  # source_instance_template = "${google_compute_instance_template.instance_template.self_link}"

  # override instance template
  network_interface {
    network = "default"
    access_config {
      
    }
  }
  labels = {
    cloudbees-core = "client-master"
  }
}
