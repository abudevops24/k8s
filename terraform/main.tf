terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.15.0"
    }
  }
}

provider "google" {
  project     =  "hungama-terraform-413807"
  region      =  "asia-south1"
  zone        =    "asia-south1-a"
  credentials =  "keys.json"   # Change to your desired region
}

# Create a new VPC
resource "google_compute_network" "vpc_network" {
  name                    = "vpc11-5"
  auto_create_subnetworks = false   
}

# Create a subnet within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "subne2t-5"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.self_link
  region        = "asia-south1"
}

# Create GKE Cluster
resource "google_container_cluster" "primary" {
  name     = "my-cluster-4"
  location = "asia-south1"
  project  = "hungama-terraform-413807"

  node_locations = ["asia-south1-a"]

  # Configure the number and type of nodes
  node_config {
    machine_type = "n1-standard-1"
    disk_size_gb = 10
    disk_type    = "pd-standard"
    preemptible  = false
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  # Configure the number of nodes
  initial_node_count = 1

  # Enable the Kubernetes API
  enable_kubernetes_alpha = false
  enable_legacy_abac      = false

  # Add network and subnetwork
  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name
}

