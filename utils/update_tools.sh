#!/bin/bash

# Update tool lists from GitHub

echo "Updating Ethical Hacking Tools Installer..."

# Check if git is available
if command -v git &> /dev/null; then
    echo "Pulling latest changes from GitHub..."
    git pull origin main
else
    echo "Git not found. Please install git first."
fi

echo "Update complete!"
