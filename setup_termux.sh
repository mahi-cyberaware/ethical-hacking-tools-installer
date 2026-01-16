#!/bin/bash

# Termux Setup Script
echo "Setting up Termux..."

# Update Termux
pkg update && pkg upgrade -y

# Install basic requirements
pkg install -y git python python2 curl wget

# Clone the repository
cd ~
git clone https://github.com/mahi-cyberaware/ethical-hacking-tools-installer.git
cd ethical-hacking-installer

# Make scripts executable
chmod +x ethical_hacking_installer.sh setup.sh

# Run setup
./setup.sh

echo ""
echo "✅ Termux setup complete!"
echo "Run: ./ethical_hacking_installer.sh"
