#!/bin/bash

# ================================================
# ETHICAL HACKING TOOLS INSTALLER
# Version: 2.0.0
# Author: mahi-cyberaware
# Email: myprogrammwork1@gmail.com
# GitHub: https://github.com/mahi-cyberaware
# ================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Global variables
VERSION="2.0.0"
AUTHOR="mahi-cyberaware"
EMAIL="myprogrammwork1@gmail.com"
GITHUB="https://github.com/mahi-cyberaware"
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
CONFIG_FILE="config/settings.conf"

# Create log directory if not exists
mkdir -p "$LOG_DIR"

# Function: Print banner
print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║  ███████╗████████╗██╗  ██╗██╗ ██████╗ █████╗ ██╗         ║"
    echo "║  ██╔════╝╚══██╔══╝██║  ██║██║██╔════╝██╔══██╗██║         ║"
    echo "║  █████╗     ██║   ███████║██║██║     ███████║██║         ║"
    echo "║  ██╔══╝     ██║   ██╔══██║██║██║     ██╔══██║██║         ║"
    echo "║  ███████╗   ██║   ██║  ██║██║╚██████╗██║  ██║███████╗    ║"
    echo "║  ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝    ║"
    echo "║                                                           ║"
    echo "║               ETHICAL HACKING TOOLS INSTALLER             ║"
    echo "║                     Version: $VERSION                      ║"
    echo "║                                                           ║"
    echo "║           Author: $AUTHOR                                 ║"
    echo "║           Email:  $EMAIL                                  ║"
    echo "║           GitHub: $GITHUB                                 ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function: Log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
    echo "$message"
}

# Function: Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${YELLOW}[!] Warning: Running as root${NC}"
        echo -e "${YELLOW}[!] Some tools may not work properly in root mode${NC}"
        read -p "Continue anyway? [y/N]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Function: Detect OS
detect_os() {
    echo -e "${BLUE}[*] Detecting operating system...${NC}"
    
    local os_type="unknown"
    
    # Check for Kali Linux
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ $ID == "kali" ]]; then
            os_type="kali"
            echo -e "${GREEN}[+] Detected: Kali Linux $VERSION${NC}"
        elif [[ $ID == "ubuntu" ]] || [[ $ID == "debian" ]]; then
            os_type="debian"
            echo -e "${GREEN}[+] Detected: $NAME $VERSION${NC}"
        fi
    fi
    
    # Check for Termux
    if [ -d /data/data/com.termux ]; then
        os_type="termux"
        echo -e "${GREEN}[+] Detected: Termux (Android)${NC}"
    fi
    
    # Check for iSH
    if [[ $(uname -o) == "iSH" ]] || command -v apk &> /dev/null && [[ ! -d /data/data/com.termux ]]; then
        os_type="ish"
        echo -e "${GREEN}[+] Detected: iSH (iOS)${NC}"
    fi
    
    # Check for macOS
    if [[ $(uname) == "Darwin" ]]; then
        os_type="macos"
        echo -e "${GREEN}[+] Detected: macOS $(sw_vers -productVersion)${NC}"
    fi
    
    if [[ $os_type == "unknown" ]]; then
        echo -e "${YELLOW}[!] Could not detect OS type${NC}"
        echo -e "${YELLOW}[!] Defaulting to Kali Linux mode${NC}"
        os_type="kali"
    fi
    
    echo "$os_type"
}

# Function: Update system packages
update_system() {
    local os_type="$1"
    
    echo -e "${BLUE}[*] Updating system packages...${NC}"
    log_message "Updating system packages for $os_type"
    
    case $os_type in
        kali|debian)
            sudo apt update && sudo apt upgrade -y
            ;;
        termux)
            pkg update && pkg upgrade -y
            ;;
        ish)
            apk update && apk upgrade
            ;;
        macos)
            brew update && brew upgrade
            ;;
        *)
            echo -e "${YELLOW}[!] OS not supported for auto-update${NC}"
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] System updated successfully${NC}"
        log_message "System update successful"
    else
        echo -e "${RED}[-] System update failed${NC}"
        log_message "System update failed"
    fi
}

# Function: Install single package
install_package() {
    local package="$1"
    local os_type="$2"
    
    echo -e "${BLUE}[*] Installing: $package${NC}"
    log_message "Installing package: $package"
    
    case $os_type in
        kali|debian)
            sudo apt install -y "$package"
            ;;
        termux)
            pkg install -y "$package"
            ;;
        ish)
            apk add "$package"
            ;;
        macos)
            brew install "$package"
            ;;
        *)
            echo -e "${RED}[-] Unknown OS type: $os_type${NC}"
            return 1
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] Successfully installed: $package${NC}"
        log_message "Successfully installed: $package"
        return 0
    else
        echo -e "${RED}[-] Failed to install: $package${NC}"
        log_message "Failed to install: $package"
        return 1
    fi
}

# Function: Install tools from category
install_category() {
    local category="$1"
    local os_type="$2"
    
    local list_file="tools_lists/$os_type/${category}.txt"
    
    if [ ! -f "$list_file" ]; then
        echo -e "${YELLOW}[!] No tool list found for $category on $os_type${NC}"
        echo -e "${YELLOW}[!] Looking for common tools...${NC}"
        list_file="tools_lists/common/${category}.txt"
        
        if [ ! -f "$list_file" ]; then
            echo -e "${RED}[-] No tool list found for category: $category${NC}"
            return 1
        fi
    fi
    
    echo -e "${BLUE}[*] Installing $category tools...${NC}"
    log_message "Installing category: $category"
    
    local installed=0
    local failed=0
    local total=0
    
    while IFS= read -r package; do
        # Skip comments and empty lines
        [[ $package =~ ^#.*$ ]] && continue
        [[ -z "$package" ]] && continue
        
        ((total++))
        install_package "$package" "$os_type"
        
        if [ $? -eq 0 ]; then
            ((installed++))
        else
            ((failed++))
        fi
        
    done < "$list_file"
    
    echo -e "${GREEN}[+] Category installation complete!${NC}"
    echo -e "${GREEN}[+] Successfully installed: $installed/$total tools${NC}"
    if [ $failed -gt 0 ]; then
        echo -e "${YELLOW}[!] Failed to install: $failed tools${NC}"
    fi
    
    log_message "Category $category: $installed installed, $failed failed out of $total"
}

# Function: Show main menu
show_main_menu() {
    while true; do
        echo ""
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║               MAIN MENU                      ║${NC}"
        echo -e "${CYAN}╠══════════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║   1. 📦 Install All Tools                    ║${NC}"
        echo -e "${CYAN}║   2. 🗂️  Install by Category                 ║${NC}"
        echo -e "${CYAN}║   3. 🔄 Update System Packages               ║${NC}"
        echo -e "${CYAN}║   4. ⚙️  Setup GitHub Configuration          ║${NC}"
        echo -e "${CYAN}║   5. 📊 Check Installation Status            ║${NC}"
        echo -e "${CYAN}║   6. ℹ️  Show Help & Information             ║${NC}"
        echo -e "${CYAN}║   7. 🚪 Exit Installer                       ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        read -p "$(echo -e ${BLUE}"Select option [1-7]: "${NC})" choice
        
        case $choice in
            1)
                install_all_tools
                ;;
            2)
                show_category_menu
                ;;
            3)
                local os_type=$(detect_os)
                update_system "$os_type"
                ;;
            4)
                setup_github
                ;;
            5)
                check_installation
                ;;
            6)
                show_help
                ;;
            7)
                echo -e "${GREEN}[+] Thank you for using Ethical Hacking Tools Installer!${NC}"
                echo -e "${GREEN}[+] Follow me on GitHub: $GITHUB${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[-] Invalid option! Please select 1-7${NC}"
                ;;
        esac
        
        echo ""
        read -p "$(echo -e ${YELLOW}"Press Enter to continue..."${NC})" -n 1
    done
}

# Function: Install all tools
install_all_tools() {
    echo -e "${YELLOW}[!] WARNING: This will install ALL available tools${NC}"
    echo -e "${YELLOW}[!] It may take a long time and require significant disk space${NC}"
    read -p "$(echo -e ${RED}"Are you sure? [y/N]: "${NC})" -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}[*] Installation cancelled${NC}"
        return
    fi
    
    local os_type=$(detect_os)
    
    # List of categories (you can expand this)
    categories=(
        "information_gathering"
        "vulnerability_analysis"
        "web_application"
        "password_attacks"
        "wireless"
    )
    
    for category in "${categories[@]}"; do
        install_category "$category" "$os_type"
    done
    
    echo -e "${GREEN}[+] All tools installation completed!${NC}"
}

# Function: Show category menu
show_category_menu() {
    while true; do
        echo ""
        echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║           TOOL CATEGORIES                    ║${NC}"
        echo -e "${CYAN}╠══════════════════════════════════════════════╣${NC}"
        echo -e "${CYAN}║   1. 🔍 Information Gathering                ║${NC}"
        echo -e "${CYAN}║   2. 🛡️  Vulnerability Analysis              ║${NC}"
        echo -e "${CYAN}║   3. 🌐 Web Application Analysis             ║${NC}"
        echo -e "${CYAN}║   4. 🔑 Password Attacks                     ║${NC}"
        echo -e "${CYAN}║   5. 📶 Wireless Attacks                     ║${NC}"
        echo -e "${CYAN}║   6. ⚙️  Reverse Engineering                 ║${NC}"
        echo -e "${CYAN}║   7. 💥 Exploitation Tools                   ║${NC}"
        echo -e "${CYAN}║   8. 📡 Sniffing & Spoofing                  ║${NC}"
        echo -e "${CYAN}║   9. 🔙 Back to Main Menu                    ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
        echo ""
        
        read -p "$(echo -e ${BLUE}"Select category [1-9]: "${NC})" choice
        
        local os_type=$(detect_os)
        
        case $choice in
            1)
                install_category "information_gathering" "$os_type"
                ;;
            2)
                install_category "vulnerability_analysis" "$os_type"
                ;;
            3)
                install_category "web_application" "$os_type"
                ;;
            4)
                install_category "password_attacks" "$os_type"
                ;;
            5)
                install_category "wireless" "$os_type"
                ;;
            6)
                install_category "reverse_engineering" "$os_type"
                ;;
            7)
                install_category "exploitation" "$os_type"
                ;;
            8)
                install_category "sniffing_spoofing" "$os_type"
                ;;
            9)
                return
                ;;
            *)
                echo -e "${RED}[-] Invalid option!${NC}"
                ;;
        esac
    done
}

# Function: Setup GitHub
setup_github() {
    echo -e "${BLUE}[*] Setting up GitHub configuration...${NC}"
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}[!] Git not found. Installing...${NC}"
        local os_type=$(detect_os)
        
        case $os_type in
            kali|debian)
                sudo apt install -y git
                ;;
            termux)
                pkg install -y git
                ;;
            ish)
                apk add git
                ;;
            macos)
                brew install git
                ;;
        esac
    fi
    
    # Configure git
    git config --global user.name "mahi-cyberaware"
    git config --global user.email "myprogrammwork1@gmail.com"
    
    echo -e "${GREEN}[+] Git configured successfully!${NC}"
    echo -e "${GREEN}[+] Username: mahi-cyberaware${NC}"
    echo -e "${GREEN}[+] Email: myprogrammwork1@gmail.com${NC}"
    
    # Initialize git repo if not already
    if [ ! -d .git ]; then
        echo -e "${BLUE}[*] Initializing git repository...${NC}"
        git init
        echo -e "${GREEN}[+] Git repository initialized${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           GITHUB SETUP INSTRUCTIONS          ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║  1. Go to: https://github.com/new            ║${NC}"
    echo -e "${CYAN}║  2. Create repository: ethical-hacking-tools ║${NC}"
    echo -e "${CYAN}║  3. Make it PUBLIC                           ║${NC}"
    echo -e "${CYAN}║  4. Don't add README or .gitignore           ║${NC}"
    echo -e "${CYAN}║  5. Then run these commands:                 ║${NC}"
    echo -e "${CYAN}║                                               ║${NC}"
    echo -e "${CYAN}║     git add .                                ║${NC}"
    echo -e "${CYAN}║     git commit -m \"Initial commit\"          ║${NC}"
    echo -e "${CYAN}║     git branch -M main                       ║${NC}"
    echo -e "${CYAN}║     git remote add origin                    ║${NC}"
    echo -e "${CYAN}║       https://github.com/mahi-cyberaware/    ║${NC}"
    echo -e "${CYAN}║         ethical-hacking-tools-installer.git  ║${NC}"
    echo -e "${CYAN}║     git push -u origin main                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
}

# Function: Check installation
check_installation() {
    echo -e "${BLUE}[*] Checking installation status...${NC}"
    
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           INSTALLATION STATUS                ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════╣${NC}"
    
    # Check main files
    echo -e "${CYAN}║  📁 Project Structure:                       ║${NC}"
    
    local files=("ethical_hacking_installer.sh" "setup.sh" "README.md")
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${CYAN}║     ✅ $file${NC}"
        else
            echo -e "${CYAN}║     ❌ $file (MISSING)${NC}"
        fi
    done
    
    # Check directories
    echo -e "${CYAN}║                                              ║${NC}"
    echo -e "${CYAN}║  📂 Directories:                            ║${NC}"
    
    local dirs=("scripts" "tools_lists" "config" "logs" "docs" "utils")
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo -e "${CYAN}║     ✅ $dir/${NC}"
        else
            echo -e "${CYAN}║     ❌ $dir/ (MISSING)${NC}"
        fi
    done
    
    # Check tool lists
    echo -e "${CYAN}║                                              ║${NC}"
    echo -e "${CYAN}║  🔧 Tool Lists:                             ║${NC}"
    
    local os_types=("kali" "termux" "ish")
    for os in "${os_types[@]}"; do
        if [ -d "tools_lists/$os" ]; then
            count=$(find "tools_lists/$os" -name "*.txt" 2>/dev/null | wc -l)
            echo -e "${CYAN}║     ✅ $os: $count list(s)${NC}"
        else
            echo -e "${CYAN}║     ❌ $os: Not found${NC}"
        fi
    done
    
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    
    echo -e "${GREEN}[+] Check complete!${NC}"
}

# Function: Show help
show_help() {
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║               HELP & INFORMATION             ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║  🔧 Tool: Ethical Hacking Tools Installer    ║${NC}"
    echo -e "${CYAN}║  👤 Author: mahi-cyberaware                  ║${NC}"
    echo -e "${CYAN}║  📧 Email: myprogrammwork1@gmail.com         ║${NC}"
    echo -e "${CYAN}║  🌐 GitHub: https://github.com/mahi-cyberaware${NC}"
    echo -e "${CYAN}║                                              ║${NC}"
    echo -e "${CYAN}║  📋 Usage:                                  ║${NC}"
    echo -e "${CYAN}║     ./ethical_hacking_installer.sh           ║${NC}"
    echo -e "${CYAN}║                                              ║${NC}"
    echo -e "${CYAN}║  📁 Project Structure:                       ║${NC}"
    echo -e "${CYAN}║     tools_lists/ - Tool lists by OS          ║${NC}"
    echo -e "${CYAN}║     config/ - Configuration files            ║${NC}"
    echo -e "${CYAN}║     logs/ - Installation logs                ║${NC}"
    echo -e "${CYAN}║     docs/ - Documentation                    ║${NC}"
    echo -e "${CYAN}║                                              ║${NC}"
    echo -e "${CYAN}║  ⚠️  DISCLAIMER:                             ║${NC}"
    echo -e "${CYAN}║     For educational purposes only!           ║${NC}"
    echo -e "${CYAN}║     Use only on authorized systems.          ║${NC}"
    echo -e "${CYAN}║                                              ║${NC}"
    echo -e "${CYAN}║  🆘 Need help? Email: myprogrammwork1@gmail.com${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
}

# Function: Main program
main() {
    print_banner
    check_root
    
    # Log start
    log_message "Installer started"
    log_message "Version: $VERSION"
    
    # Detect OS
    OS_TYPE=$(detect_os)
    log_message "Detected OS: $OS_TYPE"
    
    # Show main menu
    show_main_menu
    
    # Log end
    log_message "Installer exited"
}

# Start the main function
main "$@"
