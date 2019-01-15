// Configure the Google Cloud provider
provider "google" {
  # These are read as ENV vars (source.env before terraform plan)
  # GOOGLE_APPLICATION_CREDENTIALS
  # GCLOUD_PROJECT
  # credentials = "${file("gcp_terraform_project_creds.json")}"
  # project     = "terraform-learning"
  region = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "flask-vm" {
  name         = "flask-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  tags = ["terraform"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  metadata {
    sshKeys = "nitishk:${file(var.google_cloud_ssh_pub_key_path)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an Ephemeral external ip address
    }
  }
}

# Add firewall to allow HTTP access
resource "google_compute_firewall" "default" {
  name    = "flask-app-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }
}

# Access Flask app at: http://<External IP>:5000

