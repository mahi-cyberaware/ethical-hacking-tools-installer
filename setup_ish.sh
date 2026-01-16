#!/bin/bash

# iSH Setup Script
echo "Setting up iSH..."

# Update iSH
apk update && apk upgrade

# Install basic requirements
apk add git python3 curl wget bash

# Clone the repository
cd /root
git clone https://github.com/mahi-cyberaware/ethical-hacking-tools-installer.git
cd ethical-hacking-installer

# Make scripts executable
chmod +x ethical_hacking_installer.sh setup.sh

# Run setup
./setup.sh

echo ""
echo "⚠️  iSH Limitations:"
echo "- Fewer packages available"
echo "- Some tools won't work"
echo "- Use Termux or Kali for full features"
echo ""
echo "Run: ./ethical_hacking_installer.sh"
