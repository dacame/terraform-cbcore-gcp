provider "google" {
    project = "${var.project}"
    region = "${var.gcp-region}"
    zone = "${var.gcp-zone}"
    credentials = "${file("${var.credentials}")}"
}