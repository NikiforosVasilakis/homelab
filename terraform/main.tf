resource "proxmox_virtual_environment_container" "homelab" {
  for_each = var.containers

  node_name    = var.proxmox_node
  vm_id        = each.value.vm_id
  description  = each.value.description
  unprivileged = each.value.unprivileged
  start_on_boot = each.value.start_on_boot
  started       = true
  tags          = each.value.tags

  initialization {
    hostname = each.value.hostname

    ip_config {
      ipv4 {
        address = each.value.ipv4_address
        gateway = each.value.ipv4_gateway
      }
    }

    dynamic "user_account" {
      for_each = length(each.value.ssh_keys) > 0 ? [1] : []
      content {
        keys = each.value.ssh_keys
      }
    }
  }

  operating_system {
    template_file_id = var.lxc_template_file_id
    type             = "debian"
  }

  cpu {
    cores = each.value.cores
  }

  memory {
    dedicated = each.value.memory_mb
    swap      = each.value.swap_mb
  }

  disk {
    datastore_id = coalesce(each.value.datastore_id, var.default_datastore)
    size         = each.value.disk_gb
  }

  network_interface {
    name     = "eth0"
    bridge   = coalesce(each.value.bridge, var.default_bridge)
    vlan_id  = each.value.vlan_id
    firewall = true
  }

  features {
    nesting = each.value.nesting
  }

  lifecycle {
    prevent_destroy = true
  }
}
