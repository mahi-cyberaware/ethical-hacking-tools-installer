#!/bin/bash

# Backup tool lists and configurations

BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup in: $BACKUP_DIR"

mkdir -p "$BACKUP_DIR"
cp -r tools_lists "$BACKUP_DIR/"
cp -r config "$BACKUP_DIR/"
cp ethical_hacking_installer.sh "$BACKUP_DIR/"
cp setup.sh "$BACKUP_DIR/"

echo "Backup completed successfully!"
echo "Files backed up: $(find "$BACKUP_DIR" -type f | wc -l)"
