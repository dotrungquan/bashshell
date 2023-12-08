#!/bin/bash

# Kiểm tra quyền root
if [[ $EUID -ne 0 ]]; then
    echo "Script phải chạy với quyền root." 
    exit 1
fi

# Kiểm tra hệ điều hành
os_version=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')

# Cài đặt các gói cần thiết dựa trên hệ điều hành
case "$os_version" in
    ubuntu)
        apt update
        apt install -y perl zip unzip libwww-perl liblwp-protocol-https-perl
        ;;
    centos)
        yum install -y wget perl unzip net-tools perl-libwww-perl perl-LWP-Protocol-https perl-GDGraph
        ;;
    alm*)
        dnf install -y perl-libwww-perl perl-Math-BigInt wget
        ;;
    *)
        echo "Hệ điều hành không được hỗ trợ."
        exit 1
        ;;
esac

# Tải và cài đặt CSF
curl -O https://download.configserver.com/csf.tgz
tar xf csf.tgz
cd csf
sh install.sh

# Khởi động CSF và lưu cấu hình
csf -e
csf -r

# Sửa TESTING = "1" thành TESTING = "0" trong csf.conf
sed -i 's/TESTING = "1"/TESTING = "0"/g' /etc/csf/csf.conf

# Port muốn thêm vào TCP_IN
additional_port="2023"

# Đường dẫn tới file csf.config
csf_config="/etc/csf/csf.conf"

# Kiểm tra xem port đã tồn tại trong TCP_IN hay chưa
if ! grep -q "TCP_IN.*$additional_port" $csf_config; then
    echo "Adding TCP_IN for port $additional_port"
    sed -i "s/\(^TCP_IN = \)\(.*\)/\1\"\2,$additional_port\"/" $csf_config
else
    echo "Port $additional_port already exists in TCP_IN"
fi

# Khởi động lại CSF để áp dụng thay đổi
csf -ra

echo "Cài đặt CSF và cấu hình thành công."
