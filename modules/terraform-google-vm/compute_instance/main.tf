data "google_compute_subnetwork" "nic_subnetwork" {
  for_each = { for key, x in var.network_interface : key => x }
  name     = each.value.nic_subnetwork
  project  = each.value.nic_subnetwork_project
  region   = each.value.nic_subnetwork_region
}
data "google_service_account" "vm-instance-account" {
  account_id = var.svc_account_id
  project    = var.project_id
}

locals {
  nics = flatten([
    for key, nic in var.network_interface : [{
      "nic_network"            = data.google_compute_subnetwork.nic_subnetwork[key].network
      "nic_subnetwork"         = data.google_compute_subnetwork.nic_subnetwork[key].self_link
      "nic_subnetwork_project" = nic.nic_subnetwork_project
      "nic_access_config"      = nic.nic_access_config
      }
    ]
  ])
}

locals {
  all_disk = flatten([

    for key, additional_disk in var.additional_disks : [{
      disk_name      = additional_disk.disk_name
      device_name    = additional_disk.device_name
      auto_delete    = additional_disk.auto_delete
      boot           = additional_disk.boot
      disk_size_gb   = additional_disk.disk_size_gb
      disk_type      = additional_disk.disk_type
      disk_labels    = additional_disk.disk_labels
      zone           = var.zone
      svc_project_id = var.project_id
      }
    ]
  ])
}
resource "google_compute_disk" "attach_disk" {
  for_each = { for x in local.all_disk : x.disk_name => x }
  project  = each.value.svc_project_id
  zone     = each.value.zone
  name     = each.value.disk_name
  type     = each.value.disk_type
  size     = each.value.disk_size_gb
  # disk_encryption_key {
  #   kms_key_self_link = var.kms_key_zself_link
  #   }
  # dynamic "disk_encryption_key" {
  #   for_each = [var.kms_key_self_link]
  #   content {
  #     kms_key_self_link = var.kms_key_self_link
  #   }
  # }
}

resource "google_compute_instance" "vm_instance" {
  depends_on = [
    google_compute_disk.attach_disk
  ]
  project                   = var.project_id
  name                      = var.instance_name
  zone                      = var.zone
  machine_type              = var.machine_type
  allow_stopping_for_update = var.allow_stopping_for_update
  hostname                  = var.hostname
  labels                    = var.labels
  can_ip_forward            = var.can_ip_forward
  deletion_protection       = var.deletion_protection
  boot_disk {
    initialize_params {
      image = var.source_image
      size  = var.boot_size
      type  = var.boot_disk_type

    }
    kms_key_self_link = var.kms_key_self_link
    auto_delete       = var.boot_auto_delete
  }
  dynamic "attached_disk" {
    for_each = var.additional_disks
    content {
      device_name = attached_disk.value["device_name"]
      mode        = attached_disk.value["mode"]
      source      = attached_disk.value["disk_name"]

      #kms_key_self_link = attached_disk.value["kms_key_self_link"]
    }
  }

  dynamic "shielded_instance_config" {
    for_each = var.enable_secure_boot ? [1] : []
    content {
      enable_secure_boot = var.enable_secure_boot
    }
  }
  tags = var.tags
  dynamic "network_interface" {
    for_each = local.nics
    content {
      network            = network_interface.value.nic_network
      subnetwork         = network_interface.value.nic_subnetwork
      subnetwork_project = network_interface.value.nic_subnetwork_project
      network_ip         = length(var.nic0_network_ip) > 0 ? var.nic0_network_ip : null
      dynamic "access_config" {
        for_each = network_interface.value.nic_access_config
        content {
          nat_ip       = access_config.value.nic_nat_ip
          network_tier = access_config.value.nic_network_tier
        }
      }
    }
  }
  service_account {
    email  = data.google_service_account.vm-instance-account.email
    scopes = ["cloud-platform"]
  }
  metadata = var.metadata_config

  lifecycle {
    ignore_changes = [
      metadata["ssh-keys"],
      metadata["windows-keys"]
    ]
  }

  dynamic "advanced_machine_features" {
    for_each = var.threads_per_core ? [1] : []
    content {
      enable_nested_virtualization = false
      threads_per_core             = 1
      visible_core_count           = 0
    }
  }
}
