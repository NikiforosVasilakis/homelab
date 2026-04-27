#!/bin/bash

# Update system
apt update && apt upgrade -y

# Install dependencies
apt install -y curl wget git

# Install Pi-hole
curl -sSL https://install.pi-hole.net | bash

# Post-install message
echo "Pi-hole installation complete."
echo "Access the admin panel via http://<IP_ADDRESS>/admin"