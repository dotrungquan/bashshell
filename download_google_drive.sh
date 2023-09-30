#!/bin/bash
#Author: DOTRUNGQUAN.INFO
# Thay thế các giá trị sau bằng thông tin thích hợp
google_drive_id="xxxx"
output_file_name="yyyy"

# Tạo tệp cookie tạm thời
temp_cookies="/tmp/cookies.txt"

# Tải file từ Google Drive
wget --load-cookies "$temp_cookies" "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies "$temp_cookies" --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=$google_drive_id" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$google_drive_id" -O "$output_file_name"

# Xóa tệp cookie tạm thời
rm -rf "$temp_cookies"
