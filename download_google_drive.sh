#!/bin/bash
#Author: DOTRUNGQUAN.INFO
# Hỏi người dùng nhập ID của file từ Google Drive
read -p "Nhập ID của file trên Google Drive: " file_id

# Hỏi người dùng nhập tên file lưu trữ
read -p "Nhập tên file lưu trữ: " file_name

# Sử dụng wget để tải file từ Google Drive
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$file_id" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$file_id" -O "$file_name" && rm -rf /tmp/cookies.txt

echo "Tải file thành công! File đã được lưu trữ với tên '$file_name'."
