#!/bin/bash

# ================================================
# ETHICAL HACKING TOOLS INSTALLER - SETUP SCRIPT
# Version: 2.0.0
# Author: mahi-cyberaware
# ================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║                  SETUP SCRIPT v2.0.0                      ║"
    echo "║            Ethical Hacking Tools Installer                ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[*] $1${NC}"
}

print_success() {
    echo -e "${GREEN}[+] $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[-] $1${NC}"
}

# Start setup
print_header
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_warning "Running as root is not recommended!"
    print_warning "Some tools may not install properly."
    read -p "Continue anyway? [y/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Step 1: Make scripts executable
print_step "Step 1: Making scripts executable..."
chmod +x ethical_hacking_installer.sh 2>/dev/null
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x scripts/platforms/*.sh 2>/dev/null || true
chmod +x utils/*.sh 2>/dev/null || true
print_success "Scripts made executable"

# Step 2: Create necessary directories
print_step "Step 2: Creating required directories..."
mkdir -p logs
mkdir -p config/profiles
mkdir -p assets/images
mkdir -p tools_lists/{kali,termux,ish,common} 2>/dev/null
print_success "Directories created"

# Step 3: Create sample tool lists if empty
print_step "Step 3: Setting up tool lists..."

# Check if Kali tool lists exist, if not create them
if [ ! -f "tools_lists/kali/information_gathering.txt" ]; then
    cat > tools_lists/kali/information_gathering.txt << 'KALI_EOF'
# Kali Linux - Information Gathering Tools
nmap
masscan
whois
dnsutils
curl
wget
netdiscover
arp-scan
theharvester
recon-ng
sublist3r
amass
gobuster
dirb
whatweb
wafw00f
KALI_EOF
    print_success "Created Kali information gathering list"
fi

if [ ! -f "tools_lists/kali/vulnerability_analysis.txt" ]; then
    cat > tools_lists/kali/vulnerability_analysis.txt << 'KALI_VA_EOF'
# Kali Linux - Vulnerability Analysis
nikto
lynis
skipfish
wpscan
joomscan
droopescan
KALI_VA_EOF
    print_success "Created Kali vulnerability analysis list"
fi

# Check if Termux tool lists exist
if [ ! -f "tools_lists/termux/information_gathering.txt" ]; then
    cat > tools_lists/termux/information_gathering.txt << 'TERMUX_EOF'
# Termux - Information Gathering Tools
nmap
whois
curl
wget
python
python2
git
openssh
TERMUX_EOF
    print_success "Created Termux information gathering list"
fi

# Check if iSH tool lists exist
if [ ! -f "tools_lists/ish/information_gathering.txt" ]; then
    cat > tools_lists/ish/information_gathering.txt << 'ISH_EOF'
# iSH - Information Gathering Tools
nmap
curl
wget
python3
git
openssh-client
ISH_EOF
    print_success "Created iSH information gathering list"
fi

# Step 4: Create configuration files
print_step "Step 4: Setting up configuration files..."

if [ ! -f "config/settings.conf" ]; then
    cat > config/settings.conf << 'CONFIG_EOF'
# Ethical Hacking Tools Installer Configuration
# Version: 2.0.0
# Author: mahi-cyberaware

[Settings]
version = 2.0.0
author = mahi-cyberaware
email = myprogrammwork1@gmail.com
github = https://github.com/mahi-cyberaware
auto_update = true
log_level = info

[Paths]
tools_dir = tools_lists
config_dir = config
log_dir = logs
script_dir = scripts

[Colors]
# Color settings for output
success = green
error = red
warning = yellow
info = blue

[Network]
use_proxy = false
proxy_url = 
timeout = 30
CONFIG_EOF
    print_success "Created settings configuration"
fi

if [ ! -f "config/colors.conf" ]; then
    cat > config/colors.conf << 'COLORS_EOF'
# Color configuration for output

# Text Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'

# Background Colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Text Styles
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'

# Reset
RESET='\033[0m'
NC='\033[0m'
COLORS_EOF
    print_success "Created colors configuration"
fi

# Step 5: Create banner
print_step "Step 5: Creating banner file..."
cat > assets/images/banner.txt << 'BANNER_EOF'
    ███████╗████████╗██╗  ██╗██╗ ██████╗ █████╗ ██╗     
    ██╔════╝╚══██╔══╝██║  ██║██║██╔════╝██╔══██╗██║     
    █████╗     ██║   ███████║██║██║     ███████║██║     
    ██╔══╝     ██║   ██╔══██║██║██║     ██╔══██║██║     
    ███████╗   ██║   ██║  ██║██║╚██████╗██║  ██║███████╗
    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝
    
    Ethical Hacking Tools Installer v2.0.0
    By: mahi-cyberaware (myprogrammwork1@gmail.com)
    GitHub: https://github.com/mahi-cyberaware
BANNER_EOF
print_success "Banner file created"

# Step 6: Setup Git configuration
print_step "Step 6: Configuring Git..."
git config --global user.name "mahi-cyberaware" 2>/dev/null || print_warning "Could not set git username"
git config --global user.email "myprogrammwork1@gmail.com" 2>/dev/null || print_warning "Could not set git email"
print_success "Git configuration set"

# Step 7: Create shortcut command (optional)
print_step "Step 7: Creating shortcut command..."
if command -v sudo &> /dev/null && [ -w /usr/local/bin ]; then
    sudo ln -sf "$(pwd)/ethical_hacking_installer.sh" /usr/local/bin/eth-tools 2>/dev/null
    if [ $? -eq 0 ]; then
        print_success "Shortcut created: 'eth-tools'"
    else
        print_warning "Could not create shortcut (permission denied)"
    fi
else
    print_warning "Skipping shortcut creation (requires sudo)"
fi

# Step 8: Complete setup
print_step "Step 8: Finalizing setup..."

# Create initial log
mkdir -p logs
echo "$(date '+%Y-%m-%d %H:%M:%S') - Setup completed successfully" > logs/setup.log

# Final message
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  SETUP COMPLETED SUCCESSFULLY!            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📋 WHAT WAS SET UP:${NC}"
echo "  ✅ Script permissions set"
echo "  ✅ Directory structure created"
echo "  ✅ Tool lists initialized"
echo "  ✅ Configuration files created"
echo "  ✅ Banner file created"
echo "  ✅ Git configured"
echo "  ✅ Logging system ready"
echo ""
echo -e "${BLUE}🚀 HOW TO USE:${NC}"
echo "  Run the installer: ${GREEN}./ethical_hacking_installer.sh${NC}"
echo "  Or use shortcut:   ${GREEN}eth-tools${NC} (if created)"
echo ""
echo -e "${BLUE}👤 YOUR INFORMATION:${NC}"
echo "  GitHub Username: mahi-cyberaware"
echo "  Email: myprogrammwork1@gmail.com"
echo ""
echo -e "${BLUE}📁 PROJECT STRUCTURE:${NC}"
echo "  📄 ethical_hacking_installer.sh - Main installer"
echo "  📄 setup.sh                     - Setup script"
echo "  📁 tools_lists/                 - Tool lists by OS"
echo "  📁 config/                      - Configuration files"
echo "  📁 scripts/                     - Script modules"
echo "  📁 logs/                        - Installation logs"
echo "  📁 docs/                        - Documentation"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT DISCLAIMER:${NC}"
echo "  This tool is for EDUCATIONAL and AUTHORIZED testing ONLY!"
echo "  Always obtain proper permission before testing any system."
echo "  The author is not responsible for any misuse."
echo ""
echo -e "${GREEN}⭐ Star the repository if you find this useful!${NC}"
echo -e "${GREEN}📧 Contact: myprogrammwork1@gmail.com${NC}"
echo ""

# Run a quick test
print_step "Running quick test..."
if [ -x "ethical_hacking_installer.sh" ]; then
    print_success "Main installer is executable"
else
    print_error "Main installer is not executable!"
fi

if [ -d "tools_lists/kali" ]; then
    count=$(ls tools_lists/kali/*.txt 2>/dev/null | wc -l)
    print_success "Found $count Kali tool list(s)"
fi

echo ""
print_success "Setup completed at: $(date)"
print_success "You can now run: ./ethical_hacking_installer.sh"
