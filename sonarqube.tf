provider "google" {
 credentials = "${file("credentials.json")}"
 project     = "cloudglobaldelivery-1000135575"
 region      = "us-central1"
}
resource "google_compute_instance" "default1" {
  name         = "sonarqube-ashok"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["name", "sonarqube"]

  boot_disk {
    initialize_params {
      image = "centos-7-v20180129"
    }
  }

  // Local SSD disk
  #scratch_disk {
  #}

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
      nat_ip = "35.238.100.99"
    }
  }
   metadata = {
    name = "sonarqube"
  }
  
  metadata_startup_script = "sudo yum update -y;sudo yum install git -y; sudo git clone https://github.com/ashoksanem/Terraform_cicd.git; sudo chmod 777 /Terraform_cicd/*; sudo sh /Terraform_cicd/sonarqube;"
  }

resource "google_compute_firewall" "http" {
  name    = "firewall-sonarqube"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22","80","3300-3310", "9000-9010"]
  }

  direction  = "INGRESS"
  #target_tags   = [""]
  source_tags = ["name", "sonarqube"]
  source_ranges = ["0.0.0.0/0"]
}
