#!/bin/bash
echo "Installing missing tools..."

# Update package list
sudo apt update

# Install tools with correct package names
echo "1. Installing exploitdb (for searchsploit)..."
sudo apt install -y exploitdb

echo "2. Installing zaproxy (OWASP ZAP)..."
sudo apt install -y zaproxy

echo "3. Installing shodan via pip..."
pip3 install shodan

echo "4. Installing droopescan via pip..."
pip3 install droopescan

echo "5. Checking reverse engineering tools..."
sudo apt install -y ghidra radare2 binwalk

echo ""
echo "✅ Missing tools installation complete!"
echo ""
echo "Note: Some tools need manual installation:"
echo "  - XSStrike: git clone https://github.com/s0md3v/XSStrike.git"
echo "  - w3af: git clone https://github.com/andresriancho/w3af.git"
echo "  - Arachni & Vega: Download from their websites"
