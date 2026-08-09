# Homelab Infrastructure as Code

This repository now has three layers:

1. **Terraform** creates and manages Proxmox infrastructure.
2. **Ansible** bootstraps Docker hosts and deploys services.
3. **`services/`** remains the application layer containing the existing Compose stacks.

## Safety model

The Terraform example starts with `containers = {}` and every managed LXC has `prevent_destroy = true`.

Do **not** populate Terraform from guesses. First capture the live Proxmox configuration, represent it in `terraform.tfvars`, then import the existing containers into Terraform state.

## 1. Collect the live Proxmox inventory

Run on the Proxmox host:

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

Remove secrets before storing or sharing the output.

## 2. Terraform setup

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

Keep the Proxmox token outside Git:

```bash
export TF_VAR_proxmox_api_token='terraform@pve!provider=TOKEN'
```

The provider uses the existing LXC template specified by `lxc_template_file_id`.

## 3. Import existing LXCs

After a container has an exact matching entry in `containers`, import it instead of recreating it.

Example:

```bash
terraform import 'proxmox_virtual_environment_container.homelab["monitoring"]' pve/193
terraform plan
```

Review the plan carefully. The goal during migration is **zero destructive changes**.

## 4. Ansible setup

```bash
cd ../ansible
ansible-galaxy collection install -r requirements.yml
cp inventory/hosts.yml.example inventory/hosts.yml
ansible-playbook -i inventory/hosts.yml site.yml
```

Each Docker host gets a `homelab_services` list. Those names map directly to directories under `services/`.

Example:

```yaml
monitoring:
  ansible_host: 192.168.1.93
  homelab_services:
    - zabbix
```

## Desired end state

```text
Git
├── terraform/   -> Proxmox VMs/LXCs/network-facing resource definitions
├── ansible/     -> OS/bootstrap/deployment automation
└── services/    -> application Compose files and service configuration
```

A future clean rebuild becomes approximately:

```bash
terraform apply
ansible-playbook -i ansible/inventory/hosts.yml ansible/site.yml
```

Persistent application data, databases, media, secrets, and backups remain separate concerns and should be restored from backup rather than embedded in Terraform state.
