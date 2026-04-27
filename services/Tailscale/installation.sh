#!/bin/bash

# Update system
apt update && apt upgrade -y

# Install dependencies
apt install -y curl wget git

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale
tailscale up

# Post-install message
echo "Tailscale installed."
echo "Follow the authentication URL to connect your device."