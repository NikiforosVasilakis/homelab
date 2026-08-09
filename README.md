# 🖥️ Homelab Infrastructure

## Overview

This project represents a self-hosted homelab environment built to explore systems, networking, virtualization, and Infrastructure as Code in a practical way.

The environment is designed to simulate real-world infrastructure, focusing on service deployment, network segmentation, secure access, monitoring, and reproducible configuration.

---

## Key Features

* Virtualized infrastructure using Proxmox
* Terraform-managed LXC infrastructure
* Ansible-managed host bootstrap and service deployment
* 8+ self-hosted services (Docker & LXC)
* VLAN-based network segmentation
* Reverse proxy with local DNS routing
* Secure remote access using Tailscale
* Monitoring and dashboard integration
* Automation workflows (n8n)

---

## Architecture

```text
Git repository
├── terraform/  -> Proxmox infrastructure
├── ansible/    -> OS/bootstrap + Compose deployment
└── services/   -> application definitions

Terraform
   ↓
Proxmox
   ↓
LXC containers
   ↓
Ansible
   ↓
Docker Compose services
```

* **Hypervisor:** Proxmox VE
* **Infrastructure:** Terraform using `bpg/proxmox`
* **Configuration:** Ansible
* **Containers:** Docker & LXC
* **Networking:** VLANs, firewall rules
* **DNS:** Pi-hole
* **Reverse Proxy:** Nginx Proxy Manager
* **Monitoring:** Uptime Kuma + Zabbix
* **Remote Access:** Tailscale

---

## Infrastructure as Code

The Terraform configuration is intentionally safe by default: `containers = {}` until the live Proxmox inventory is captured. Existing production containers should be imported into state before Terraform is allowed to manage them.

### 1. Capture the current Proxmox state

Run on the Proxmox node:

```bash
pveversion -v
qm list
pct list
pvesm status
ip addr
ip route
cat /etc/network/interfaces

for id in $(pct list | awk 'NR>1 {print $1}'); do
  echo "===== LXC $id ====="
  pct config "$id"
done

for id in $(qm list | awk 'NR>1 {print $1}'); do
  echo "===== VM $id ====="
  qm config "$id"
done
```

Do not commit secrets, API tokens, private keys, or passwords.

### 2. Configure Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Set the API token outside Git:

```bash
export TF_VAR_proxmox_api_token='terraform@pve!provider=TOKEN_SECRET'
```

Then:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Do **not** run `terraform apply` against the live lab until the `containers` map reflects reality and existing containers have been imported where appropriate.

### 3. Configure Ansible

```bash
cd ../ansible
ansible-galaxy collection install -r requirements.yml
cp inventory.example.yml inventory.yml
```

Edit the hosts and the `homelab_services` lists, then run:

```bash
ansible-playbook -i inventory.yml site.yml
```

The playbook installs Docker, clones this repository on each Docker host, and starts the Compose stacks assigned to that host.

---

## Network Design

The network is segmented using VLANs to isolate traffic:

* Main user devices
* IoT devices
* Server infrastructure
* VPN-isolated services

This improves security, traffic control, and overall system reliability.

---

## Services

* **Pi-hole** → DNS filtering & local DNS
* **Nginx Proxy Manager** → reverse proxy & routing
* **Media Server (ARR Stack)** → automated media management
* **Gitea** → self-hosted Git service
* **Memos** → note-taking service
* **n8n** → automation workflows
* **Glance Dashboard** → service overview
* **Uptime Kuma / Zabbix** → monitoring
* **Tailscale** → secure remote access

---

## Repository Structure

```text
homelab/
├── terraform/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── terraform.tfvars.example
├── ansible/
│   ├── site.yml
│   ├── requirements.yml
│   └── inventory.example.yml
└── services/
    ├── pihole/
    ├── nginx/
    ├── MediaServer/
    ├── memos/
    ├── n8n/
    ├── Glance_Dashboard/
    ├── Tailscale/
    ├── Gitea/
    ├── Kuma/
    └── zabbix/
```

---

## Goals

* Build and manage a self-hosted infrastructure
* Make the environment reproducible from Git
* Gain hands-on experience with Terraform and Ansible
* Improve networking, systems, automation, and troubleshooting skills
* Keep application configuration separate from infrastructure configuration

---

## Notes

This homelab is actively maintained and used daily.
It serves as both a learning platform and a real-world system for experimenting with infrastructure concepts.

The current IaC layer is the first migration step. Live Proxmox values still need to be captured before existing containers should be imported or recreated.

---

## Disclaimer

Sensitive information such as IP addresses, credentials, API tokens, and private data must not be committed to this repository.
