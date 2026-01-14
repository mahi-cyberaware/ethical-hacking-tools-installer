#!/bin/bash

# Quick test script for Ethical Hacking Tools Installer

echo "🧪 Testing Ethical Hacking Tools Installer..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total_tests=0
passed_tests=0

# Function to run a test and increment counters
run_test() {
    local test_name="$1"
    local command_to_run="$2"
    total_tests=$((total_tests + 1))
    if eval "$command_to_run"; then
        echo -e "${GREEN}✅ $test_name${NC}"
        passed_tests=$((passed_tests + 1))
    else
        echo -e "${RED}❌ $test_name${NC}"
    fi
}

# Test 1: Check main files
echo -e "${BLUE}🔍 Checking main files...${NC}"
run_test "Main installer exists" "[ -f 'ethical_hacking_installer.sh' ]"
run_test "Setup script exists" "[ -f 'setup.sh' ]"
run_test "README.md exists" "[ -f 'README.md' ]"

# Test 2: Check directories
echo ""
echo -e "${BLUE}📁 Checking directories...${NC}"
run_test "scripts/ exists" "[ -d 'scripts' ]"
run_test "tools_lists/ exists" "[ -d 'tools_lists' ]"
run_test "config/ exists" "[ -d 'config' ]"
run_test "logs/ exists" "[ -d 'logs' ]"
run_test "docs/ exists" "[ -d 'docs' ]"
run_test "utils/ exists" "[ -d 'utils' ]"

# Test 3: Check tool lists
echo ""
echo -e "${BLUE}🔧 Checking tool lists...${NC}"
run_test "Kali directory exists" "[ -d 'tools_lists/kali' ]"
run_test "Termux directory exists" "[ -d 'tools_lists/termux' ]"
run_test "iSH directory exists" "[ -d 'tools_lists/ish' ]"

# Test 4: Check permissions
echo ""
echo -e "${BLUE}🔐 Checking permissions...${NC}"
run_test "Main installer is executable" "[ -x 'ethical_hacking_installer.sh' ]"
run_test "Setup script is executable" "[ -x 'setup.sh' ]"

# Test 5: Show banner
echo ""
echo -e "${BLUE}🎨 Testing banner display...${NC}"
echo -e "${BLUE}----------------------------------------${NC}"
if [ -f "assets/images/banner.txt" ]; then
    head -10 assets/images/banner.txt
else
    echo "Banner file not found"
fi
echo -e "${BLUE}----------------------------------------${NC}"

# Test 6: Check configuration
echo ""
echo -e "${BLUE}⚙️ Checking configuration...${NC}"
run_test "Settings configuration exists" "[ -f 'config/settings.conf' ]"
run_test "Colors configuration exists" "[ -f 'config/colors.conf' ]"

# Final summary
echo ""
echo -e "${BLUE}📊 SUMMARY:${NC}"
echo -e "${GREEN}✅ $passed_tests tests passed out of $total_tests${NC}"
if [ $passed_tests -eq $total_tests ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
else
    echo -e "${YELLOW}⚠️  Some tests failed${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Test completed!${NC}"
echo ""
echo -e "${BLUE}🚀 NEXT STEPS:${NC}"
echo "1. Run the installer: ${GREEN}./ethical_hacking_installer.sh${NC}"
echo "2. Or run setup again: ${GREEN}./setup.sh${NC}"
echo "3. Add more tools to tool lists"
echo "4. Push to GitHub"
echo ""
echo -e "${BLUE}👤 Author: mahi-cyberaware${NC}"
echo -e "${BLUE}📧 Email: myprogrammwork1@gmail.com${NC}"
