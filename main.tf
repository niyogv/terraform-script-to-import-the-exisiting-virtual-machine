// Required variables from each project
variable project_name { default = "battleground01" }
variable virtual_machine_name { default = "demo" }

// Configure the Google Cloud provider
provider "google" {
    project     = "${var.project_name}"
    region      = "${var.region}"
    zone        = "${var.zone}"
}

// Compute instance config of which you wish to import into terraform should be defined
resource "google_compute_instance" "demo" {
  boot_disk {
    auto_delete = "true"
    device_name = "demo"

    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20220719"
      size  = "10"
      type  = "pd-balanced"
    }

    mode   = "READ_WRITE"
  }

  can_ip_forward      = "false"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "${var.machine_type}"
  name                = "demo"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    network            = "https://www.googleapis.com/compute/v1/projects/battleground01/global/networks/default"
  }

  project = "battleground01"

  scheduling {
    automatic_restart   = "true"
    on_host_maintenance = "MIGRATE"
    preemptible         = "false"
  }

  service_account {
    email  = "754080791595-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/monitoring.write",
              "https://www.googleapis.com/auth/trace.append", 
              "https://www.googleapis.com/auth/service.management.readonly", 
              "https://www.googleapis.com/auth/servicecontrol", 
              "https://www.googleapis.com/auth/logging.write", 
              "https://www.googleapis.com/auth/devstorage.read_only"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = "true"
    enable_secure_boot          = "false"
    enable_vtpm                 = "true"
  }

  zone = "${var.zone}"
}

// after your file is ready run terraform init after running terraform intit import the existing vm config on gcp by running 
//'terraform import google_compute_instance.<instance name> <your instance id>' and once the vm config import is successfull run
// terraform plan observe the output of the tf plan. It may be show some changes if there is
// difference between your typed config and the imported config vm, make changes as per the requirements and again run terraform plan
// if the oupput shows as "No changes. Your infrastructure matches the configuration" ur successful in importing the vm config of which u wish