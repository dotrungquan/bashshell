#!/bin/bash
#Author: Đỗ Trung Quân
echo "####################################################################################"
echo "#                                                                                  #"
echo "#  Script tổng hợp cài đặt các Control Panel và Script được viết bởi               #"
echo "#  DOTRUNGQUAN.INFO. Hãy chọn Control Panel hoặc Script mà bạn muốn cài đặt.       #"
echo "#  Tham gia nhóm Hỗ trợ Server - Hosting & WordPress để được trợ giúp.             #"
echo "#  Facebook: https://www.facebook.com/groups/hotroserverhostingwordpress.          #"
echo "#                                                                                  #"
echo "####################################################################################"

# Thông tin hệ điều hành
echo "Thông tin hệ điều hành đang sử dụng:"
echo "-------------------------------------"
echo "IP:          $(hostname -I | cut -f1 -d' ')"
echo "Dung lượng:  $(df -h | awk '$NF=="/"{printf "%s", $2}')"
echo "RAM:         $(free -h | awk '/^Mem/ {printf "%s", $2}')"
echo "Swap:        $(free -h | awk '/^Swap/ {printf "%s", $2}')"
echo "CPU:         $(lscpu | grep '^CPU(s):' | awk '{printf "%s", $2}') core(s)"

# Kiểm tra hệ điều hành và hiển thị thông tin phù hợp
if [ -f /etc/os-release ]; then
    # Hệ điều hành sử dụng /etc/os-release (bao gồm Ubuntu)
    echo "Hệ điều hành: $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '"')"
elif [ -f /etc/redhat-release ]; then
    # Hệ điều hành dựa trên Red Hat (bao gồm CentOS)
    echo "Hệ điều hành: $(cat /etc/redhat-release)"
else
    # Trường hợp khác
    echo "Không thể xác định hệ điều hành"
fi
echo "-------------------------------------"
echo -e "\n"

install_hestiacp() {
    apt -y install curl wget sudo
    wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
    bash hst-install.sh -f
}

install_cloudpanel() {
    apt -y install curl wget sudo
    curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
    echo "85762db0edc00ce19a2cd5496d1627903e6198ad850bbbdefb2ceaa46bd20cbd install.sh" | sha256sum -c && sudo DB_ENGINE=MARIADB_10.6 bash install.sh
}

install_aapanel() {
    echo "Chọn hệ điều hành để cài đặt AApanel:"
    echo "1. CentOS"
    echo "2. Ubuntu"
    echo "3. Debian"
    echo "0. Quay lại Menu Chính"
    read -p "Nhập vào lựa chọn của bạn: " os_choice

    case $os_choice in
        1)
            yum install -y wget
            wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh
            sh install.sh 93684c35
            ;;
        2)
            apt-get update
            apt-get -y install wget
            wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh
            sudo bash install.sh 93684c35
            ;;
        3)
            apt-get update
            apt-get -y install wget
            wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh
            bash install.sh 93684c35
            ;;
        0) main_menu ;;
        *)
            echo "Lựa chọn không hợp lệ. Thoát."
            exit 1
            ;;
    esac
}

install_fastpanel() {
    wget http://repo.fastpanel.direct/install_fastpanel.sh -O - | bash -
}

install_cyberpanel() {
    sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)
}

install_directadmin() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"CentOS"* ]]; then
        wget https://topwhmcs.com/DA/setup.sh && chmod +x setup.sh && ./setup.sh
    else
        echo "Directadmin Bypass chỉ hỗ trợ CentOS. Thoát."
        exit 1
    fi
}

install_bypassdirectadmin() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    
    if [[ $os_name == *"CentOS"* ]]; then
        wget https://raw.githubusercontent.com/dotrungquan/directadmin/main/fixpath.sh && chmod +x fixpath.sh && ./fixpath.sh
    else
        echo "Directadmin Bypass chỉ hỗ trợ CentOS. Thoát."
        exit 1
    fi
}

install_hostvn_script() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
    os_version=$(lsb_release -rs)

    if [[ $os_name == "Ubuntu" && ($os_version == "18.04" || $os_version == "20.04") ]] || [[ $os_name == "Debian" && $os_version == "10" ]]; then
        wget https://scripts.hostvn.net/install && bash install
    else
        echo "HostVN Script chỉ hỗ trợ Ubuntu 18.04, 20.04 và Debian 10. Thoát."
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

# Hàm quay lại Menu Chính
back_to_main_menu() {
    echo "Quay lại Menu Chính..."
    sleep 2
    clear
    main_menu
}

# Menu Control Panel
install_control_panel() {
    echo "+---------------------------------------------+"
    echo "| Chọn Control Panel mà bạn muốn cài:         |"
    echo "+---------------------------------------------+"
    echo "| 1. Cài đặt HestiaCP                         |"
    echo "| 2. Cài đặt CloudPanel                       |"
    echo "| 3. Cài đặt AApanel                          |"
    echo "| 4. Cài đặt FastPanel                        |"
    echo "| 5. Cài đặt CyberPanel                       |"
    echo "| 6. Cài đặt DirectAdmin                      |"
    echo "| 7. ByPass DirectAdmin đã cài ở trên                      |"
    echo "| 0. Quay lại Menu Chính                      |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " control_panel_choice
    case $control_panel_choice in
        0) back_to_main_menu ;;
        1) install_hestiacp ;;
        2) install_cloudpanel ;;
        3) install_aapanel ;;
        4) install_fastpanel ;;
        5) install_cyberpanel ;;
        6) install_directadmin ;;
        7) install_bypassdirectadmin ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

# Menu Script
install_script() {
    echo "+---------------------------------------------+"
    echo "| Chọn Script mà bạn muốn cài:                |"
    echo "+---------------------------------------------+"
    echo "| 1. Cài đặt HostVN Script                    |"
    echo "| 2. Cài đặt HocVPS                           |"
    echo "| 3. Cài đặt LarVPS                           |"
    echo "| 4. Cài đặt Centmind Mod                     |"
    echo "| 5. Cài đặt TinoVPS Script                   |"
    echo "| 0. Quay lại Menu Chính                      |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " script_choice
    case $script_choice in
        0) back_to_main_menu ;;
        1) install_hostvn_script ;;
        2) install_hocvps ;;
        3) install_larvps ;;
        4) install_centmind_mod ;;
        5) install_tinovps_script ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

# Menu Chính
main_menu() {
    # Các phần hiển thị thông tin máy chủ và hệ điều hành ở đây

    echo "+---------------------------------------------+"
    echo "| Chọn loại cài đặt mà bạn muốn thực hiện:    |"
    echo "+---------------------------------------------+"
    echo "| 1. Cài đặt Control Panel                    |"
    echo "| 2. Cài đặt Script                           |"
    echo "| 0. Thoát                                   |"
    echo "+---------------------------------------------+"
    read -p "Nhập vào lựa chọn: " main_choice
    case $main_choice in
        0) exit ;;
        1) install_control_panel ;;
        2) install_script ;;
        *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
    esac
}

# Gọi hàm main_menu ở cuối script để bắt đầu chương trình
main_menu