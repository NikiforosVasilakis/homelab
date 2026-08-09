variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, e.g. https://pve.example.lan:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token. Prefer TF_VAR_proxmox_api_token instead of committing it."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Allow self-signed Proxmox TLS certificates."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH user used by the provider when SSH access is required."
  type        = string
  default     = "root"
}

variable "proxmox_node" {
  description = "Proxmox node name."
  type        = string
  default     = "pve"
}

variable "lxc_template_file_id" {
  description = "Existing Proxmox LXC template file ID, e.g. local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  type        = string
}

variable "default_datastore" {
  description = "Default Proxmox datastore for LXC root disks."
  type        = string
  default     = "local-lvm"
}

variable "default_bridge" {
  description = "Default Proxmox Linux bridge."
  type        = string
  default     = "vmbr0"
}

variable "containers" {
  description = "Desired LXC containers. Keep empty until the live Proxmox inventory has been captured/imported."
  type = map(object({
    vm_id         = number
    hostname      = string
    description   = optional(string, "Managed by Terraform")
    cores         = optional(number, 2)
    memory_mb     = optional(number, 2048)
    swap_mb       = optional(number, 512)
    disk_gb       = optional(number, 8)
    datastore_id  = optional(string)
    bridge        = optional(string)
    vlan_id       = optional(number)
    ipv4_address  = string
    ipv4_gateway  = string
    unprivileged  = optional(bool, true)
    nesting       = optional(bool, false)
    start_on_boot = optional(bool, true)
    tags          = optional(list(string), ["terraform", "homelab"])
    ssh_keys      = optional(list(string), [])
  }))
  default = {}
}
