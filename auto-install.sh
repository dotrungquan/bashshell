#!/bin/bash

echo "####################################################################################"
echo "#                                                                                  #"
echo "#  Đây là script tổng hợp cài đặt các Control Panel và Script được viết bởi        #"
echo "#  DOTRUNGQUAN.INFO. Hãy chọn Control Panel hoặc Script mà bạn muốn cài đặt.       #"
echo "#  Tham gia nhóm Hỗ trợ Server - Hosting & WordPress để được trợ giúp.             #"
echo "#  Facebook: https://www.facebook.com/groups/hotroserverhostingwordpress.          #"
echo "#                                                                                  #"                                                                           #"
echo "####################################################################################"

# Thông tin máy chủ
echo "+-----------------------------------------------------------------------------------+"
echo "| Thông tin máy chủ Server/VPS đang sử dụng:                                        |"
echo "+-----------------------------------------------------------------------------------+"
echo "| IP: $(hostname -I | cut -f1 -d' ')                                                |"
echo "| Dung lượng: $(df -h | awk '$NF=="/"{printf "%s", $2}')                            |"
echo "| RAM: $(free -h | awk '/^Mem/ {print $2}')                                         |"
echo "| Swap: $(free -h | awk '/^Swap/ {print $2}')                                       |"
echo "| CPU: $(lscpu | grep '^CPU(s):' | awk '{print $2}') core(s)                        |"
echo "+-----------------------------------------------------------------------------------+"
echo -e "\n"

install_hostvn_script() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"Ubuntu"* ]]; then
        wget https://scripts.hostvn.net/install && bash install
    else
        echo "HostVN Script chỉ hỗ trợ Ubuntu. Thoát."
        exit 1
    fi
}

install_hocvps() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"Ubuntu"* || $os_name == *"CentOS"* ]]; then
        curl -sO https://hocvps.com/install && bash install
    else
        echo "HocVPS chỉ hỗ trợ Ubuntu và CentOS. Thoát."
        exit 1
    fi
}

install_larvps() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"AlmaLinux"* || $os_name == *"Rocky"* || $os_name == *"Ubuntu"* ]]; then
        curl -sO https://larvps.com/scripts/larvps && bash larvps
    else
        echo "LarVPS chỉ hỗ trợ cài đặt trên Almalinux 8, Rocky 8 và Ubuntu. Thoát."
        exit 1
    fi
}

install_centmind_mod() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"CentOS"* ]]; then
        curl -O https://centminmod.com/betainstaller74.sh && chmod 0700 betainstaller74.sh && bash betainstaller74.sh
    else
        echo "Centmin Mod chỉ hỗ trợ CentOS. Thoát."
        exit 1
    fi
}

install_tinovps_script() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"CentOS"* || $os_name == *"AlmaLinux"* ]]; then
        curl -sO https://scripts.tino.org/tinovps-install && sh tinovps-install
    else
        echo "TinoVPS Script chỉ hỗ trợ CentOS và Almalinux. Thoát."
        exit 1
    fi
}

# Main Menu
echo "+---------------------------------------------+"
echo "| Chọn loại cài đặt mà bạn muốn thực hiện:    |"
echo "+---------------------------------------------+"
echo "| 1. Cài đặt Control Panel                    |"
echo "| 2. Cài đặt Script                           |"
echo "+---------------------------------------------+"

read -p "Nhập vào lựa chọn: " install_choice

case $install_choice in
    1)
        # Menu Control Panel
        echo "+---------------------------------------------+"
        echo "| Chọn Control Panel mà bạn muốn cài:         |"
        echo "+---------------------------------------------+"
        echo "| 1. Cài đặt HestiaCP                         |"
        echo "| 2. Cài đặt CloudPanel                       |"
        echo "| 3. Cài đặt AApanel                          |"
        echo "| 4. Cài đặt FastPanel                        |"
        echo "| 5. Cài đặt CyberPanel                       |"
        echo "+---------------------------------------------+"
        read -p "Nhập vào lựa chọn: " control_panel_choice
        case $control_panel_choice in
            1) install_hestiacp ;;
            2) install_cloudpanel ;;
            3) install_aapanel ;;
            4) install_fastpanel ;;
            5) install_cyberpanel ;;
            *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
        esac
        ;;
    2)
        # Menu Script
        echo "+---------------------------------------------+"
        echo "| Chọn Script mà bạn muốn cài:                |"
        echo "+---------------------------------------------+"
        echo "| 1. Cài đặt HostVN Script                    |"
        echo "| 2. Cài đặt HocVPS                           |"
        echo "| 3. Cài đặt LarVPS                           |"
        echo "| 4. Cài đặt Centmind Mod                     |"
        echo "| 5. Cài đặt TinoVPS Script                   |"
        echo "+---------------------------------------------+"
        read -p "Nhập vào lựa chọn: " script_choice
        case $script_choice in
            1) install_hostvn_script ;;
            2) install_hocvps ;;
            3) install_larvps ;;
            4) install_centmind_mod ;;
            5) install_tinovps_script ;;
            *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
        esac
        ;;
    *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
esac
