#!/bin/bash

# Hàm tạo mật khẩu ngẫu nhiên 8 ký tự
generate_random_password() {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*' | fold -w 8 | head -n 1
}

# Yêu cầu người dùng nhập thông tin
read -p "Nhập tên cơ sở dữ liệu (UserDB): " user_db
read -p "Nhập tên người dùng cơ sở dữ liệu (Username): " db_username
read -s -p "Nhập mật khẩu người dùng cơ sở dữ liệu (passwdUsername): " db_password
echo
read -p "Nhập URL của website (ví dụ: https://example.com): " url

# Lấy title từ URL (lấy domain không có giao thức)
title=$(echo $url | sed -e 's|https\?://||' -e 's|/.*$||')

# Tạo email admin dựa trên URL
email="admin@$title"

# Tạo mật khẩu ngẫu nhiên cho admin WordPress
admin_password=$(generate_random_password)

# In ra các thông tin để kiểm tra
echo "Thông tin cài đặt:"
echo "Database: $user_db"
echo "DB Username: $db_username"
echo "DB Password: [Ẩn]"
echo "URL: $url"
echo "Title: $title"
echo "Admin User: admin"
echo "Admin Password: $admin_password"
echo "Admin Email: $email"

# Thực hiện cài đặt WordPress
echo "Bắt đầu cài đặt WordPress..."
wp core download --allow-root
wp core config --dbname="$user_db" --dbuser="$db_username" --dbpass="$db_password" --allow-root
wp core install --url="$url" --title="$title" --admin_user="admin" --admin_password="$admin_password" --admin_email="$email" --allow-root

# Kiểm tra kết quả cài đặt
if [ $? -eq 0 ]; then
    echo "Cài đặt WordPress thành công!"
    echo "URL: $url"
    echo "Admin User: admin"
    echo "Admin Password: $admin_password"
    echo "Admin Email: $email"
else
    echo "Cài đặt WordPress thất bại. Vui lòng kiểm tra lại."
fi
