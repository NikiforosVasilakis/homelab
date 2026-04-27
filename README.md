# 🖥️ Homelab Infrastructure

## Overview

This project represents a self-hosted homelab environment built to explore systems, networking, and virtualization in a practical way.

The environment is designed to simulate real-world infrastructure, focusing on service deployment, network segmentation, secure access, and system monitoring.

---

## Key Features

* Virtualized infrastructure using Proxmox
* 8+ self-hosted services (Docker & LXC)
* VLAN-based network segmentation
* Reverse proxy with local DNS routing
* Secure remote access using Tailscale
* Monitoring and dashboard integration
* Automation workflows (n8n)

---

## Architecture

* **Hypervisor:** Proxmox VE
* **Containers:** Docker & LXC
* **Networking:** VLANs, firewall rules
* **DNS:** Pi-hole (network-wide filtering + local DNS)
* **Reverse Proxy:** Nginx Proxy Manager
* **Monitoring:** Uptime Kuma + Dashboard
* **Remote Access:** Tailscale

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
* **Tailscale** → secure remote access

---

## Repository Structure

```text
homelab/
├── README.md
└── services/
    ├── pihole/
    ├── nginx/
    ├── MediaServer/
    ├── memos/
    ├── n8n/
    ├── Glance_Dashboard/
    ├── Tailscale/
    └── Gitea/
```

---

## Goals

* Build and manage a self-hosted infrastructure
* Gain hands-on experience with networking and systems
* Improve troubleshooting and performance optimization skills
* Learn service orchestration and automation

---

## Notes

This homelab is actively maintained and used daily.
It serves as both a learning platform and a real-world system for experimenting with infrastructure concepts.

---

## Disclaimer

Sensitive information such as IP addresses, credentials, and private data has been removed or sanitized from this repository.
