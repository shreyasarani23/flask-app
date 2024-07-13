resource "google_container_cluster" "demo-private-cluster" {
  name                     = "${var.environment}-private-cluster"
  location                 = var.region
  project                  = var.project_id
  network                  = google_compute_network.test-vpc.self_link
  subnetwork               = google_compute_subnetwork.test-subnet.self_link
  remove_default_node_pool = true
  initial_node_count       = 1
  enable_l4_ilb_subsetting = true
  enable_shielded_nodes    = false
  min_master_version       = "1.27.13-gke.1070002"
  description              = "Private Production ME Cluster"
  

  resource_labels = {
    environment = "test"
    team        = "infra"
    cluster     = "test-private-cluster"
  }

  vertical_pod_autoscaling {
    enabled = true
  }

  
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
  addons_config {
    gke_backup_agent_config {
      enabled = true
    }
  }
  
  lifecycle {
    ignore_changes = [master_auth]
  }


  # A set of options for creating a private cluster.
  private_cluster_config {
    # Whether the master's internal IP address is used as the cluster endpoint.
    enable_private_endpoint = true

    # Whether nodes have internal IP addresses only. If enabled, all nodes are
    # given only RFC 1918 private addresses and communicate with the master via
    # private networking.
    enable_private_nodes   = true
    master_ipv4_cidr_block = "10.171.0.0/28"

  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "21:30"
    }
  }

  network_policy {
    enabled  = "false"
    provider = "PROVIDER_UNSPECIFIED"
  }


  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "10.178.0.0/20"
    }
  }

  
  ip_allocation_policy {
    cluster_secondary_range_name  = "${var.environment}-pod-subnet"
    services_secondary_range_name = "${var.environment}-services-subnet"
  }
}

resource "google_container_node_pool" "demo-node-pool" {
  name     = "${var.environment}-demo-node-pool"
  location = var.region
  node_locations = [
    var.zonea
  ]
  cluster = google_container_cluster.demo-private-cluster.name
  version = "1.27.13-gke.1070002"
  project = var.project_id
  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  autoscaling {
    min_node_count  = "3"
    max_node_count  = "10"
    location_policy = "BALANCED"
  }
  initial_node_count = "5"



  node_config {
    machine_type    = "n2d-custom-4-12288"
    service_account = "gkecomputeinstance@test-project.iam.gserviceaccount.com"


    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      environment = "test"
    team        = "infra"
    cluster     = "test-private-cluster"
    }
    resource_labels = {
      environment = "test"
    team        = "infra"
    cluster     = "test-private-cluster"
    }
    tags = ["gke-worker"]

    shielded_instance_config {
      enable_secure_boot = true
    }

  }
}