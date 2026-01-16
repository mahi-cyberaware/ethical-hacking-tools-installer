#!/bin/bash

echo "Platform Detection..."
echo ""

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ $ID == "kali" ]]; then
        echo "Detected: Kali Linux"
        echo "Installing Kali tools..."
        # Kali installation commands
    fi
elif [ -d /data/data/com.termux ]; then
    echo "Detected: Termux (Android)"
    echo ""
    echo "To install on Termux:"
    echo "1. pkg update && pkg upgrade"
    echo "2. pkg install git"
    echo "3. git clone https://github.com/mahi-cyberaware/ethical-hacking-tools-installer.git"
    echo "4. cd ethical-hacking-installer"
    echo "5. chmod +x setup.sh ethical_hacking_installer.sh"
    echo "6. ./setup.sh"
    echo "7. ./ethical_hacking_installer.sh"
elif [[ $(uname -o) == "iSH" ]]; then
    echo "Detected: iSH (iOS)"
    echo ""
    echo "To install on iSH:"
    echo "1. apk update && apk upgrade"
    echo "2. apk add git bash"
    echo "3. git clone https://github.com/mahi-cyberaware/ethical-hacking-tools-installer.git"
    echo "4. cd ethical-hacking-installer"
    echo "5. chmod +x setup.sh ethical_hacking_installer.sh"
    echo "6. ./setup.sh"
    echo "7. ./ethical_hacking_installer.sh"
    echo ""
    echo "⚠️  Note: iSH has limited tool availability"
else
    echo "Unknown OS. Manual installation required."
fi
