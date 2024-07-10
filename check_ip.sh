#!/bin/bash

# Hàm kiểm tra sự tồn tại của lệnh
command_exists() {
    command -v "$1" &> /dev/null
}

# Hàm kiểm tra và gỡ chặn địa chỉ IP
check_and_unblock_ip() {
    local ip=$1
    local firewall=$2
    local command=$3
    local unblock_command=$4

    echo "Đang kiểm tra $firewall cho địa chỉ IP: $ip..."
    if eval "$command"; then
        echo "Địa chỉ IP $ip bị chặn bởi $firewall."
        read -p "Bạn có muốn gỡ chặn địa chỉ IP này không? (Y/N): " choice
        if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
            eval "$unblock_command"
            echo "Đã gỡ chặn địa chỉ IP $ip từ $firewall."
        else
            echo "Địa chỉ IP $ip vẫn bị chặn trên $firewall."
        fi
    else
        echo "Địa chỉ IP $ip không bị chặn trên $firewall."
    fi
}

# Nhập địa chỉ IP cần kiểm tra
read -p "Nhập địa chỉ IP để kiểm tra: " ip

# Kiểm tra CSF
if command_exists csf; then
    check_and_unblock_ip "$ip" "CSF" "csf -g $ip | grep -q 'DENY'" "csf -dr $ip"
fi

# Kiểm tra Firewalld
if command_exists firewall-cmd; then
    check_and_unblock_ip "$ip" "Firewalld" "firewall-cmd --list-all | grep -q $ip" "firewall-cmd --remove-rich-rule='rule family=ipv4 source address=$ip reject'"
fi

# Kiểm tra Fail2Ban
if command_exists fail2ban-client; then
    jails=$(fail2ban-client status | grep 'Jail list' | cut -d: -f2)
    for jail in $jails; do
        check_and_unblock_ip "$ip" "Fail2Ban ($jail)" "fail2ban-client status $jail | grep -q $ip" "fail2ban-client set $jail unbanip $ip"
    done
fi

# Kiểm tra UFW
if command_exists ufw; then
    check_and_unblock_ip "$ip" "UFW" "ufw status | grep -q $ip" "ufw delete deny from $ip"
fi

# Kiểm tra Iptables
if command_exists iptables; then
    check_and_unblock_ip "$ip" "Iptables" "iptables -L -n | grep -q $ip" "iptables -D INPUT -s $ip -j DROP"
fi

echo "Hoàn thành kiểm tra Firewall."
