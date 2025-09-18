#!/bin/bash

# Script cài đặt Control Panel
# Author: DOTRUNGQUAN.INFO

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    printf "${1}${2}${NC}\n"
}

# Function to print header
print_header() {
    clear
    print_color $CYAN "╔════════════════════════════════════════════════════════════════╗"
    print_color $CYAN "║                    CONTROL PANEL INSTALLER                    ║"
    print_color $CYAN "║                   Author: DOTRUNGQUAN.INFO                    ║"
    print_color $CYAN "╠════════════════════════════════════════════════════════════════╣"
    print_color $WHITE "║ Liên hệ:                                                      ║"
    print_color $WHITE "║ Facebook: https://fb.com/dotrungquan.info/                    ║"
    print_color $WHITE "║ Zalo: https://zalo.me/0969030302                              ║"
    print_color $WHITE "║ Telegram: http://t.me/dotrungquan                             ║"
    print_color $WHITE "║ Phone: 0969.03.03.02                                         ║"
    print_color $WHITE "║ Email: lienhe@dotrungquan.info                                ║"
    print_color $CYAN "╚════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Function to check if VPS is clean
check_vps_clean() {
    local issues=()
    
    print_color $YELLOW "Đang kiểm tra trạng thái VPS..."
    echo ""
    
    # Check for web servers
    if systemctl is-active --quiet apache2 2>/dev/null || systemctl is-enabled --quiet apache2 2>/dev/null; then
        issues+=("Apache2 đã được cài đặt")
    fi
    
    if systemctl is-active --quiet nginx 2>/dev/null || systemctl is-enabled --quiet nginx 2>/dev/null; then
        issues+=("Nginx đã được cài đặt")
    fi
    
    if systemctl is-active --quiet httpd 2>/dev/null || systemctl is-enabled --quiet httpd 2>/dev/null; then
        issues+=("HTTP (Apache) đã được cài đặt")
    fi
    
    if systemctl is-active --quiet lighttpd 2>/dev/null || systemctl is-enabled --quiet lighttpd 2>/dev/null; then
        issues+=("Lighttpd đã được cài đặt")
    fi
    
    if systemctl is-active --quiet litespeed 2>/dev/null || systemctl is-enabled --quiet litespeed 2>/dev/null; then
        issues+=("LiteSpeed đã được cài đặt")
    fi
    
    # Check for databases
    if systemctl is-active --quiet mysql 2>/dev/null || systemctl is-enabled --quiet mysql 2>/dev/null; then
        issues+=("MySQL đã được cài đặt")
    fi
    
    if systemctl is-active --quiet mariadb 2>/dev/null || systemctl is-enabled --quiet mariadb 2>/dev/null; then
        issues+=("MariaDB đã được cài đặt")
    fi
    
    if systemctl is-active --quiet mysqld 2>/dev/null || systemctl is-enabled --quiet mysqld 2>/dev/null; then
        issues+=("MySQL/MariaDB đã được cài đặt")
    fi
    
    if systemctl is-active --quiet postgresql 2>/dev/null || systemctl is-enabled --quiet postgresql 2>/dev/null; then
        issues+=("PostgreSQL đã được cài đặt")
    fi
    
    # Check for PHP
    if command -v php >/dev/null 2>&1; then
        php_version=$(php -v 2>/dev/null | head -n1 | grep -oP 'PHP \K[0-9]+\.[0-9]+')
        if [ ! -z "$php_version" ]; then
            issues+=("PHP $php_version đã được cài đặt")
        fi
    fi
    
    # Check for common PHP-FPM services
    for php_ver in 7.4 8.0 8.1 8.2 8.3 8.4; do
        if systemctl is-active --quiet php${php_ver}-fpm 2>/dev/null || systemctl is-enabled --quiet php${php_ver}-fpm 2>/dev/null; then
            issues+=("PHP ${php_ver}-FPM đã được cài đặt")
        fi
    done
    
    # Check for control panels
    if [ -d "/usr/local/CyberCP" ] || systemctl is-active --quiet lscpd 2>/dev/null; then
        issues+=("CyberPanel đã được cài đặt")
    fi
    
    if [ -d "/www/server" ] && [ -f "/www/server/panel/BT.py" ]; then
        issues+=("AAPANEL/BT Panel đã được cài đặt")
    fi
    
    if [ -d "/usr/local/hestia" ] || command -v v-list-users >/dev/null 2>&1; then
        issues+=("HestiaCP đã được cài đặt")
    fi
    
    if [ -d "/usr/local/vesta" ] || command -v v-list-users >/dev/null 2>&1; then
        issues+=("VestaCP đã được cài đặt")
    fi
    
    if [ -d "/home/cloudpanel" ] || systemctl is-active --quiet cloudpanel 2>/dev/null; then
        issues+=("CloudPanel đã được cài đặt")
    fi
    
    if [ -d "/usr/local/mgr5" ] || command -v mgrctl >/dev/null 2>&1; then
        issues+=("FastPanel đã được cài đặt")
    fi
    
    if systemctl is-active --quiet openpanel 2>/dev/null || [ -d "/opt/openpanel" ]; then
        issues+=("OpenPanel đã được cài đặt")
    fi
    
    if command -v easypanel >/dev/null 2>&1 || [ -d "/etc/easypanel" ]; then
        issues+=("EasyPanel đã được cài đặt")
    fi
    
    # Check for common ports
    if netstat -tuln 2>/dev/null | grep -q ":80 \|:443 \|:3306 \|:8080 \|:8443"; then
        local ports=$(netstat -tuln 2>/dev/null | grep -E ":80 |:443 |:3306 |:8080 |:8443 " | awk '{print $4}' | cut -d: -f2 | sort -u | tr '\n' ' ')
        if [ ! -z "$ports" ]; then
            issues+=("Các port web/database đang được sử dụng: $ports")
        fi
    fi
    
    # Return results
    if [ ${#issues[@]} -eq 0 ]; then
        print_color $GREEN "✓ VPS sạch - Sẵn sàng cài đặt Control Panel"
        echo ""
        return 0
    else
        print_color $RED "✗ VPS đã có các dịch vụ được cài đặt:"
        echo ""
        for issue in "${issues[@]}"; do
            print_color $RED "  • $issue"
        done
        echo ""
        print_color $YELLOW "CẢNH BÁO: Control Panel cần VPS trắng để tránh xung đột!"
        print_color $YELLOW "Vui lòng sử dụng VPS mới hoặc xóa các dịch vụ hiện tại."
        echo ""
        return 1
    fi
}

# Function to force check bypass
force_check_bypass() {
    print_color $YELLOW "Bạn có muốn bỏ qua kiểm tra và tiếp tục cài đặt? (NGUY HIỂM)"
    print_color $RED "Chọn 'y' chỉ khi bạn chắc chắn biết mình đang làm gì!"
    print_color $BLUE "Tiếp tục cài đặt? (y/N): "
    read -r force_install
    if [[ $force_install =~ ^[Yy]$ ]]; then
        print_color $YELLOW "⚠️  Đang bỏ qua kiểm tra và tiếp tục cài đặt..."
        return 0
    else
        print_color $GREEN "Hủy cài đặt. Khuyến nghị sử dụng VPS mới."
        return 1
    fi
}

# Function to show main menu
show_menu() {
    print_color $GREEN "Chọn Control Panel bạn muốn cài đặt:"
    echo ""
    print_color $YELLOW "1. CyberPanel"
    print_color $YELLOW "2. AAPANEL"
    print_color $YELLOW "3. HestiaCP"
    print_color $YELLOW "4. VestaCP"
    print_color $YELLOW "5. CloudPanel"
    print_color $YELLOW "6. FASTPANEL"
    print_color $YELLOW "7. OpenPanel"
    print_color $YELLOW "8. EasyPanel"
    print_color $PURPLE "9. Kiểm tra trạng thái VPS"
    print_color $RED "0. Thoát"
    echo ""
    print_color $BLUE "Nhập lựa chọn của bạn: "
}

# Function to install CyberPanel
install_cyberpanel() {
    print_color $GREEN "Đang cài đặt CyberPanel..."
    sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)
}

# Function to install AAPANEL
install_aapanel() {
    print_color $GREEN "Đang cài đặt AAPANEL..."
    URL=https://www.aapanel.com/script/install_7.0_en.sh && if [ -f /usr/bin/curl ];then curl -ksSO "$URL" ;else wget --no-check-certificate -O install_7.0_en.sh "$URL";fi;bash install_7.0_en.sh aapanel
}

# Function to install HestiaCP
install_hestiacp() {
    print_color $GREEN "Đang cài đặt HestiaCP..."
    wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
    bash hst-install.sh
}

# Function to install VestaCP
install_vestacp() {
    print_color $GREEN "Đang cài đặt VestaCP..."
    curl -O https://vestacp.com/pub/vst-install.sh
    bash vst-install.sh
}

# Function to show CloudPanel submenu
show_cloudpanel_menu() {
    print_color $GREEN "Chọn phiên bản Database cho CloudPanel:"
    echo ""
    print_color $YELLOW "1. MySQL 8.4"
    print_color $YELLOW "2. MySQL 8.0"
    print_color $YELLOW "3. MariaDB 11.4"
    print_color $YELLOW "4. MariaDB 10.11"
    print_color $RED "0. Quay lại"
    echo ""
    print_color $BLUE "Nhập lựa chọn của bạn: "
}

# Function to install CloudPanel
install_cloudpanel() {
    while true; do
        print_header
        show_cloudpanel_menu
        read -r choice
        
        case $choice in
            1)
                print_color $GREEN "Đang cài đặt CloudPanel với MySQL 8.4..."
                curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
                echo "985bed747446eabad433c2e8115e21d6898628fa982c9e55ff6cd0d7c35b501d install.sh" | sha256sum -c && sudo DB_ENGINE=MYSQL_8.4 bash install.sh
                break
                ;;
            2)
                print_color $GREEN "Đang cài đặt CloudPanel với MySQL 8.0..."
                curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
                echo "985bed747446eabad433c2e8115e21d6898628fa982c9e55ff6cd0d7c35b501d install.sh" | sha256sum -c && sudo DB_ENGINE=MYSQL_8.0 bash install.sh
                break
                ;;
            3)
                print_color $GREEN "Đang cài đặt CloudPanel với MariaDB 11.4..."
                curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
                echo "985bed747446eabad433c2e8115e21d6898628fa982c9e55ff6cd0d7c35b501d install.sh" | sha256sum -c && sudo DB_ENGINE=MARIADB_11.4 bash install.sh
                break
                ;;
            4)
                print_color $GREEN "Đang cài đặt CloudPanel với MariaDB 10.11..."
                curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
                echo "985bed747446eabad433c2e8115e21d6898628fa982c9e55ff6cd0d7c35b501d install.sh" | sha256sum -c && sudo DB_ENGINE=MARIADB_10.11 bash install.sh
                break
                ;;
            0)
                break
                ;;
            *)
                print_color $RED "Lựa chọn không hợp lệ. Vui lòng thử lại."
                sleep 2
                ;;
        esac
    done
}

# Function to show FASTPANEL options and install
install_fastpanel() {
    print_color $GREEN "Đang kiểm tra các phiên bản Database có sẵn cho FASTPANEL..."
    wget https://repo.fastpanel.direct/install_fastpanel.sh
    
    print_color $YELLOW "Các phiên bản Database có sẵn:"
    bash install_fastpanel.sh --help | grep 'Available versions'
    
    echo ""
    print_color $GREEN "Chọn phiên bản Database:"
    print_color $YELLOW "1. default"
    print_color $YELLOW "2. mariadb10.6"
    print_color $YELLOW "3. mariadb10.11"
    print_color $YELLOW "4. mysql8.0"
    print_color $YELLOW "5. percona8.0"
    print_color $RED "0. Hủy cài đặt"
    echo ""
    print_color $BLUE "Nhập lựa chọn của bạn: "
    read -r db_choice
    
    case $db_choice in
        1)
            print_color $GREEN "Đang cài đặt FASTPANEL với database mặc định..."
            bash install_fastpanel.sh
            ;;
        2)
            print_color $GREEN "Đang cài đặt FASTPANEL với MariaDB 10.6..."
            bash install_fastpanel.sh -m mariadb10.6
            ;;
        3)
            print_color $GREEN "Đang cài đặt FASTPANEL với MariaDB 10.11..."
            bash install_fastpanel.sh -m mariadb10.11
            ;;
        4)
            print_color $GREEN "Đang cài đặt FASTPANEL với MySQL 8.0..."
            bash install_fastpanel.sh -m mysql8.0
            ;;
        5)
            print_color $GREEN "Đang cài đặt FASTPANEL với Percona 8.0..."
            bash install_fastpanel.sh -m percona8.0
            ;;
        0)
            print_color $YELLOW "Hủy cài đặt FASTPANEL."
            return
            ;;
        *)
            print_color $RED "Lựa chọn không hợp lệ. Sử dụng database mặc định."
            bash install_fastpanel.sh
            ;;
    esac
}

# Function to install OpenPanel
install_openpanel() {
    print_color $GREEN "Đang cài đặt OpenPanel..."
    bash <(curl -sSL https://openpanel.org)
}

# Function to install EasyPanel
install_easypanel() {
    print_color $GREEN "Đang cài đặt EasyPanel..."
    curl -sSL https://get.easypanel.io | sh
}

# Function to confirm installation
confirm_installation() {
    local panel_name=$1
    
    # First check if VPS is clean
    if ! check_vps_clean; then
        if ! force_check_bypass; then
            return 1
        fi
    fi
    
    echo ""
    print_color $YELLOW "Bạn có chắc chắn muốn cài đặt $panel_name? (y/n): "
    read -r confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Main script loop
main() {
    while true; do
        print_header
        show_menu
        read -r choice
        
        case $choice in
            1)
                if confirm_installation "CyberPanel"; then
                    install_cyberpanel
                    print_color $GREEN "Cài đặt CyberPanel hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            2)
                if confirm_installation "AAPANEL"; then
                    install_aapanel
                    print_color $GREEN "Cài đặt AAPANEL hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            3)
                if confirm_installation "HestiaCP"; then
                    install_hestiacp
                    print_color $GREEN "Cài đặt HestiaCP hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            4)
                if confirm_installation "VestaCP"; then
                    install_vestacp
                    print_color $GREEN "Cài đặt VestaCP hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            5)
                if confirm_installation "CloudPanel"; then
                    install_cloudpanel
                    print_color $GREEN "Cài đặt CloudPanel hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            6)
                if confirm_installation "FASTPANEL"; then
                    install_fastpanel
                    print_color $GREEN "Cài đặt FASTPANEL hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            7)
                if confirm_installation "OpenPanel"; then
                    install_openpanel
                    print_color $GREEN "Cài đặt OpenPanel hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            8)
                if confirm_installation "EasyPanel"; then
                    install_easypanel
                    print_color $GREEN "Cài đặt EasyPanel hoàn tất!"
                    read -p "Nhấn Enter để tiếp tục..."
                fi
                ;;
            0)
                print_color $GREEN "Cảm ơn bạn đã sử dụng script!"
                print_color $CYAN "Liên hệ hỗ trợ: lienhe@dotrungquan.info"
                exit 0
                ;;
            *)
                print_color $RED "Lựa chọn không hợp lệ. Vui lòng thử lại."
                sleep 2
                ;;
        esac
    done
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_color $RED "Script này cần chạy với quyền root. Vui lòng chạy với sudo."
   exit 1
fi

# Run main function
main
