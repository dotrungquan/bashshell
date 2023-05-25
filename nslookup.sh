#!/bin/bash
#DOTRUNGQUAN.INFO
read -p "Nhập domain cần kiểm tra: " domain

dns_servers=("8.8.8.8 Google DNS"
             "1.1.1.1 Cloudflare DNS"
             "208.67.222.222 OpenDNS"
             "9.9.9.9 Quad9"
             "84.200.69.80 DNS.WATCH"
             "8.26.56.26 Comodo Secure DNS")

for server in "${dns_servers[@]}"
do
    dns_ip=$(echo "$server" | cut -d ' ' -f1)
    dns_name=$(echo "$server" | cut -d ' ' -f2)

    echo "Kết quả từ máy chủ DNS $dns_name ($dns_ip):"
    nslookup "$domain" "$dns_ip"
    echo "----------------------------------"
done
