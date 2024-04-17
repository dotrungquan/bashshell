#!/bin/bash
#Author: DOTRUNGQUAN.INFO
echo -e "\n"
echo "####################################################################################"
echo "#                                                                                  #"
echo "#  Script tổng hợp cài đặt các Control Panel và Script được viết bởi Đỗ Trung Quân #"
echo "#  Tham gia nhóm Hỗ trợ Server - Hosting & WordPress để được trợ giúp.             #"
echo "#  Facebook: https://www.facebook.com/groups/hotroserverhostingwordpress           #"
echo "#  Telegram: https://t.me/hotrohostingvps                                          #"
echo "#  Zalo: https://zalo.me/g/gpcvgh410                                               #"
echo "#                                                                                  #"
echo "####################################################################################"
echo -e "\n"

os_info=$(awk -F= '/^PRETTY_NAME/{print $2}' /etc/os-release | tr -d '"')
os_info_no_core=$(echo "$os_info" | sed 's/ (Core)//')

loadavg=$(uptime | awk -F'[a-z]:' '{ print $2}' | sed 's/,//g' | xargs)

cpu_model=$(lscpu | grep 'Model name' | awk -F':' '{print $2}' | xargs)
num_cores=$(lscpu | grep '^CPU(s):' | awk '{printf "%s", $2}')
cpu_frequency=$(lscpu | grep 'CPU MHz' | awk -F':' '{printf "%s", $2}' | xargs)

total_disk_size=$(df -h --total | awk '/^total/ {printf "%s", $2}')
total_mem=$(free -h | awk '/^Mem/ {printf "%s", $2}')
total_swap=$(free -h | awk '/^Swap/ {printf "%s", $2}')

uptime_info=$(uptime | awk '{print $3, $4}' | sed 's/,//')
arch_info=$(uname -m)
kernel_info=$(uname -r)
current_date=$(date)

echo "Thông tin máy chủ đang sử dụng:"
echo "-----------------------------------------------------------"
echo "Hệ điều hành:      $os_info_no_core"
echo "IP:                 $(hostname -I | cut -f1 -d' ')"
echo "Hostname:           $(hostname)"
echo "Dung lượng:         $(df -h | awk '$NF=="/"{printf "%s", $2}')"
echo "RAM:                $(free -h | awk '/^Mem/ {printf "%s", $2}')"
echo "Swap:               $(free -h | awk '/^Swap/ {printf "%s", $2}')"
echo "CPU:                $num_cores core(s) - $cpu_model - $cpu_frequency MHz"
echo "Load Average:       $loadavg"
echo "Arch:               $arch_info"
echo "Kernel:             $kernel_info"
echo "Date:               $current_date"
echo "System Uptime:      $uptime_info"
echo "-----------------------------------------------------------"
echo -e "\n"

install_hestiacp() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
        os_version=$(grep -oP '(?<=^VERSION_ID=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
        os_version=""
    fi

    supported_os=("Debian" "Ubuntu")
    debian_versions=("10" "11" "12")
    ubuntu_versions=("20.04" "22.04")

    if [[ "${supported_os[@]}" =~ "${os_name}" ]]; then
        if [[ "${os_name}" == "Debian" && "${debian_versions[@]}" =~ "${os_version}" ]] || \
           [[ "${os_name}" == "Ubuntu" && "${ubuntu_versions[@]}" =~ "${os_version}" ]]; then
            apt -y install curl wget sudo
            wget https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh
            bash hst-install.sh -f
        else
            echo "HestiaCP chỉ hỗ trợ Debian 10, 11, 12 và Ubuntu 20.04, 22.04 LTS. Thoát."
            exit 1
        fi
    else
        echo "HestiaCP chỉ hỗ trợ Debian và Ubuntu. Thoát."
        exit 1
    fi
}


install_cloudpanel() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
        os_version=$(grep -oP '(?<=^VERSION_ID=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
        os_version=""
    fi

    supported_os=("Debian" "Ubuntu")
    debian_version="11"
    ubuntu_version="22.04"

    if [[ "${supported_os[@]}" =~ "${os_name}" ]]; then
        if [[ "${os_name}" == "Debian" && "${os_version}" == "${debian_version}" ]] || \
           [[ "${os_name}" == "Ubuntu" && "${os_version}" == "${ubuntu_version}" ]]; then
            apt -y install curl wget sudo
            curl -sS https://installer.cloudpanel.io/ce/v2/install.sh -o install.sh
            echo "85762db0edc00ce19a2cd5496d1627903e6198ad850bbbdefb2ceaa46bd20cbd install.sh" | sha256sum -c && sudo DB_ENGINE=MARIADB_10.6 bash install.sh
        else
            echo "CloudPanel chỉ hỗ trợ Debian 11 và Ubuntu 22.04. Thoát."
            exit 1
        fi
    else
        echo "CloudPanel chỉ hỗ trợ Debian và Ubuntu. Thoát."
        exit 1
    fi
}


install_aapanel() {
    echo "Đang xác định hệ điều hành..."

    # Lấy thông tin OS từ /etc/os-release
    if [ -f "/etc/os-release" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' /etc/os-release | tr -d '"')
    else
        echo "Không thể xác định hệ điều hành. Thoát."
        exit 1
    fi

    # Chuyển đổi tên hệ điều hành thành chữ thường để kiểm tra
    os_name_lower=$(echo "$os_name" | tr '[:upper:]' '[:lower:]')

    # Xác định lệnh cài đặt tương ứng với hệ điều hành
    case $os_name_lower in
        *centos* | *almalinux*)
            yum install -y wget
            wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh
            sh install.sh 93684c35
            ;;
        *ubuntu*)
            apt-get update
            apt-get -y install wget
            wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh
            bash install.sh 93684c35
            ;;
        *debian*)
            apt-get update
            apt-get -y install wget
            wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh
            bash install.sh 93684c35
            ;;
        *)
            echo "Hệ điều hành không được hỗ trợ. Thoát."
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

install_cpanel() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
    fi

    if [[ $os_name == *"CentOS"* ]]; then
        echo "cPanel không hỗ trợ trên CentOS. Thoát."
        exit 1
    else
        cd /home && curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
    fi
}


install_cwp() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
    fi

    supported_os="CentOS"

    if [[ $os_name == *"$supported_os"* ]]; then
        cd /usr/local/src && wget http://centos-webpanel.com/cwp-el7-latest && sh cwp-el7-latest
    else
        echo "CWP (CentOS Web Panel) chỉ hỗ trợ trên CentOS. Thoát."
        exit 1
    fi
}

install_webmin() {
    curl -o setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh && sh setup-repos.sh
}

install_directadmin() {
    echo "Vui lòng chọn:"
    echo "1. Cài đặt DirectAdmin mới"
    echo "2. Bypass License DirectAdmin"
    echo "0. Quay lại Menu Chính"
    read -p "Nhập vào lựa chọn của bạn: " os_choice

    case $os_choice in
        1)
            os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

            if [[ $os_name == *"CentOS"* ]]; then
                wget https://tool.dotrungquan.info/DA/setup.sh && chmod +x setup.sh && ./setup.sh
            else
                echo "Directadmin Bypass chỉ hỗ trợ CentOS. Thoát."
                exit 1
            fi
            ;;

        2)
            os_info_file="/etc/os-release"

            if [ -f "$os_info_file" ]; then
                os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
            else
                os_name=""
            fi

            supported_os="CentOS"

            if [[ $os_name == *"$supported_os"* ]]; then
                wget https://raw.githubusercontent.com/dotrungquan/directadmin/main/fixpath.sh && chmod +x fixpath.sh && ./fixpath.sh
            else
                echo "Directadmin Bypass chỉ hỗ trợ CentOS. Thoát."
                exit 1
            fi
            ;;

        0)
            main_menu ;;
        
        *)
            echo "Lựa chọn không hợp lệ. Thoát."
            exit 1
            ;;
    esac
}

install_vestacp() {
    curl -O http://vestacp.com/pub/vst-install.sh && bash vst-install.sh
}

install_hostvn_script() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
        os_version=$(grep -oP '(?<=^VERSION_ID=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
        os_version=""
    fi

    supported_os=("Ubuntu")
    supported_versions=("18.04" "20.04")

    if [[ "${supported_os[@]}" =~ "${os_name}" ]] && [[ "${supported_versions[@]}" =~ "${os_version}" ]]; then
        wget https://scripts.hostvn.net/install && bash install
    else
        echo "HostVN Script chỉ hỗ trợ Ubuntu 18.04 và 20.04. Thoát."
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

install_webinoly_script() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
        os_version=$(grep -oP '(?<=^VERSION_ID=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
        os_version=""
    fi

    supported_os=("Ubuntu")
    supported_versions=("20.04" "22.04")

    if [[ "${supported_os[@]}" =~ "${os_name}" ]] && [[ "${supported_versions[@]}" =~ "${os_version}" ]]; then
        wget -qO weby qrok.es/wy && sudo bash weby -lemp
    else
        echo "webinoly Script chỉ hỗ trợ Ubuntu 20.04, 22.04. Thoát."
        exit 1
    fi
}

install_easyengine_script() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
        os_version=$(grep -oP '(?<=^VERSION_ID=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
        os_version=""
    fi

    supported_os=("Ubuntu" "Debian")
    ubuntu_versions=("18.04" "20.04" "22.04")
    debian_versions=("8" "9" "10")

    if [[ "${supported_os[@]}" =~ "${os_name}" ]]; then
        if [[ "${os_name}" == "Ubuntu" && "${ubuntu_versions[@]}" =~ "${os_version}" ]] || \
           [[ "${os_name}" == "Debian" && "${debian_versions[@]}" =~ "${os_version}" ]]; then
            wget -qO ee https://rt.cx/ee4 && sudo bash ee
        else
            echo "EE (EasyEngine) chỉ hỗ trợ Ubuntu 18.04, 20.04 và Debian 8, 9, 10. Thoát."
            exit 1
        fi
    else
        echo "EE (EasyEngine) chỉ hỗ trợ Ubuntu và Debian. Thoát."
        exit 1
    fi
}

install_wordops_script() {
    os_info_file="/etc/os-release"

    if [ -f "$os_info_file" ]; then
        os_name=$(grep -oP '(?<=^NAME=).*' "$os_info_file" | tr -d '"')
        os_version=$(grep -oP '(?<=^VERSION_ID=).*' "$os_info_file" | tr -d '"')
    else
        os_name=""
        os_version=""
    fi

    supported_os=("Ubuntu" "Debian")
    ubuntu_versions=("16.04" "18.04" "20.04" "22.04")
    debian_versions=("9" "10")
    raspbian_versions=("9" "10")

    if [[ "${supported_os[@]}" =~ "${os_name}" ]]; then
        if [[ "${os_name}" == "Ubuntu" && "${ubuntu_versions[@]}" =~ "${os_version}" ]] || \
           [[ "${os_name}" == "Debian" && "${debian_versions[@]}" =~ "${os_version}" ]]; then
            wget -qO wo wops.cc && sudo bash wo
        elif [[ "${os_name}" == "Raspbian" && "${raspbian_versions[@]}" =~ "${os_version}" ]]; then
            wget -qO wo wops.cc && sudo bash wo
        else
            echo "WordOps chỉ hỗ trợ Ubuntu 16.04, 18.04, 20.04, 22.04, Debian 9, 10, Raspbian 9, 10. Thoát."
            exit 1
        fi
    else
        echo "WordOps chỉ hỗ trợ Ubuntu, Debian và Raspbian. Thoát."
        exit 1
    fi
}

install_dlemp_script() {
    os_name=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

    if [[ $os_name == *"CentOS"* ]]; then
        curl -L https://script.dlemp.net -o dlemp && bash dlemp
    else
        echo "DLEMP chỉ hỗ trợ CentOS. Thoát."
        exit 1
    fi
}

install_lempstack() {
    wget http://mirrors.linuxeye.com/oneinstack-full.tar.gz && tar xzf oneinstack-full.tar.gz && cd oneinstack && ./install.sh
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
    echo "| 6. Cài đặt CWP (Control-WebPanel)           |"
    echo "| 7. Cài đặt Webmin                           |"
    echo "| 8. Cài đặt DirectAdmin                      |"
    echo "| 9. Cài đặt VestaCP                          |"
    echo "| 10. Cài đặt cPanel                          |"
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
        6) install_cwp ;;
        7) install_webmin ;;
        8) install_directadmin ;;
        9) install_vestacp ;;
        10) install_cpanel ;;
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
    echo "| 6. Cài đặt Webinoly                         |"
    echo "| 7. Cài đặt EE (EasyEngine)                  |"
    echo "| 8. Cài đặt WordOps                          |"
    echo "| 9. Cài đặt DLEMP                            |"
    echo "| 10. Cài đặt LEMP Stack                      |"
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
        6) install_webinoly_script ;;
        7) install_easyengine_script ;;
        8) install_wordops_script ;;
        9) install_dlemp_script ;;
        10) install_lempstack ;;
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
    echo "| 0. Thoát                                    |"
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
