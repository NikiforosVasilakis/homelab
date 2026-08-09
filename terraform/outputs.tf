output "containers" {
  description = "Managed LXC container IDs and hostnames."
  value = {
    for name, container in proxmox_virtual_environment_container.homelab : name => {
      vm_id    = container.vm_id
      hostname = var.containers[name].hostname
    }
  }
}
