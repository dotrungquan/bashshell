#!/bin/bash

# Yêu cầu người dùng nhập vào link sitemap
read -p "Nhập link sitemap: " main_sitemap

output_file="link.txt"
curl_log="curl.log"

# Kiểm tra sự tồn tại của cURL
if ! command -v curl &> /dev/null; then
    echo "cURL không được cài đặt. Vui lòng cài đặt cURL và thử lại."
    exit 1
fi

# Tải nội dung từ sitemap chính và trích xuất các liên kết sitemap con
sub_sitemaps=($(curl -s "$main_sitemap" | grep -oP '<loc>\K[^<]+'))

# Lặp qua từng sitemap con và trích xuất các liên kết
for sub_sitemap in "${sub_sitemaps[@]}"; do
    # Tải nội dung từ sitemap con và trích xuất các liên kết bằng grep và sed
    curl -s "$sub_sitemap" | grep -oP '<loc>\K[^<]+' >> "$output_file"
    
    # Kiểm tra xem có lỗi khi tải nội dung từ sitemap con không
    if [ $? -ne 0 ]; then
        echo "Lỗi khi tải nội dung từ sitemap con: $sub_sitemap"
    fi
done

# Đọc từ file link.txt và sử dụng curl -s cho mỗi liên kết (thực hiện lệnh GET)
while IFS= read -r link; do
    # Thực hiện lệnh curl -s và ghi kết quả vào curl.log
    curl -s "$link" >> "$curl_log" 2>&1
done < "$output_file"

echo "Kết quả đã được ghi vào $curl_log"
