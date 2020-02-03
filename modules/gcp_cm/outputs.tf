data "google_compute_instance" "cbcore_cm" {
  count = "${var.packer-image}" ? 1 : 0
  name = "${google_compute_instance_from_template.cbcore_cm[0].self_link}"
  zone = "${var.gcp-zone}"
}
output "clien_master_endpoint" {
  value = "${var.packer-image}" ? "${data.google_compute_instance.cbcore_cm[0].network_interface.0.access_config.0.nat_ip}" : ""
}
