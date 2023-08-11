#!/bin/bash

echo "Chào mừng bạn đến với DOTRUNGQUAN.INFO!"
read -p "Nhập kích thước swap bạn muốn (theo đơn vị GB): " swap_size

# Kiểm tra xem người dùng đã nhập số hợp lệ hay chưa
re='^[0-9]+$'
if ! [[ $swap_size =~ $re ]]; then
    echo "Lỗi: Bạn cần phải nhập một số nguyên dương!"
    exit 1
fi

# Tạo swap với kích thước đã nhập
echo "Đang tạo swap với kích thước $swap_size GB..."
sudo dd if=/dev/zero of=/swapfile bs=1G count=$swap_size
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Thêm swap vào file /etc/fstab để tự động kích hoạt sau khi khởi động
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

echo "Swap đã được tạo thành công và đã kích hoạt!"
echo "Thông tin swap:"
free -h

echo "Xin cảm ơn đã sử dụng script!"
