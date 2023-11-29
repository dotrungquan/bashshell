#!/bin/bash

echo "####################################################################################"
echo "#                                                                                  #"
echo "#  Đây là script tổng hợp cài đặt các Control Panel được viết bởi DOTRUNGQUAN.INFO #"
echo "#  Hãy chọn Control Panel mà bạn muốn cài đặt theo menu dưới đây.                  #"
echo "#  Tham gia nhóm Hỗ trợ Server - Hosting & WordPress để được trợ giúp              #"
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

update_system() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

    if [[ $os_name == *"CentOS"* ]] || [[ $os_name == *"AlmaLinux"* ]]; then
        yum makecache
        yum -y install wget
    elif [[ $os_name == *"Ubuntu"* ]] || [[ $os_name == *"Debian"* ]]; then
        apt-get update
        apt-get -y install wget
    else
        echo "Không thể xác định OS được hỗ trợ."
        exit 1
    fi
}

install_hestiacp() {
    update_system
    apt -y install curl wget sudo
    wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
    bash hst-install.sh -f
}

install_cloudpanel() {
    update_system
    apt -y install curl wget sudo
    curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
    echo "85762db0edc00ce19a2cd5496d1627903e6198ad850bbbdefb2ceaa46bd20cbd install.sh" | sha256sum -c && sudo DB_ENGINE=MARIADB_10.6 bash install.sh
}

install_aapanel() {
    update_system
    echo "Chọn hệ điều hành để cài đặt AApanel:"
    echo "1. CentOS"
    echo "2. Ubuntu"
    echo "3. Debian"
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
        *)
            echo "Lựa chọn không hợp lệ. Thoát."
            exit 1
            ;;
    esac
}

install_fastpanel() {
    update_system
    wget http://repo.fastpanel.direct/install_fastpanel.sh -O - | bash -
}

install_cyberpanel() {
    update_system
    sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh)
}

# Main Menu
echo "+---------------------------------------------+"
echo "| Chọn Control Panel mà bạn muốn cài:         |"
echo "+---------------------------------------------+"
echo "| 1. Cài đặt HestiaCP                          |"
echo "| 2. Cài đặt CloudPanel                        |"
echo "| 3. Cài đặt AApanel                           |"
echo "| 4. Cài đặt FastPanel                         |"
echo "| 5. Cài đặt CyberPanel                        |"
echo "+---------------------------------------------+"

read -p "Nhập vào lựa chọn: " menu_choice

case $menu_choice in
    1) install_hestiacp ;;
    2) install_cloudpanel ;;
    3) install_aapanel ;;
    4) install_fastpanel ;;
    5) install_cyberpanel ;;
    *) echo "Lựa chọn không hợp lệ. Thoát." && exit 1 ;;
esac
