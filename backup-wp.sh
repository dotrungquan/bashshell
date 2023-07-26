#!/bin/bash

# Đường dẫn đến file wp-config.php
wp_config_file="wp-config.php"

# Kiểm tra xem file wp-config.php tồn tại hay không
if [ ! -f "$wp_config_file" ]; then
  echo "Không tìm thấy file wp-config.php."
  exit 1
fi

# Lấy giá trị DB_NAME từ file wp-config.php
db_name=$(grep -o "define(\"DB_NAME\", \"[^\"]*\");" "$wp_config_file" | sed 's/define("DB_NAME", "\(.*\)");/\1/')

# Lấy giá trị DB_USER từ file wp-config.php
db_user=$(grep -o "define(\"DB_USER\", \"[^\"]*\");" "$wp_config_file" | sed 's/define("DB_USER", "\(.*\)");/\1/')

# Lấy giá trị DB_PASSWORD từ file wp-config.php
db_pass=$(grep -o "define(\"DB_PASSWORD\", \"[^\"]*\");" "$wp_config_file" | sed 's/define("DB_PASSWORD", "\(.*\)");/\1/')

# Kiểm tra xem các giá trị đã được lấy chưa
if [ -z "$db_name" ] || [ -z "$db_user" ] || [ -z "$db_pass" ]; then
  echo "Không thể lấy thông tin DB_NAME, DB_USER hoặc DB_PASSWORD từ file wp-config.php."
  exit 1
fi

# Ngày-tháng-năm hiện tại
current_date=$(date +"%Y-%m-%d")

# Tên file backup có định dạng backup+ngày-tháng-năm.tar.gz
backup_file="backup_$current_date.tar.gz"

# Dump database
echo "Đang dump database..."
mysqldump -u "$db_user" -p"$db_pass" "$db_name" > "$db_name.sql"

# Nén toàn bộ dữ liệu và database thành một tập tin tar.gz
echo "Đang nén toàn bộ dữ liệu..."
tar -czvf "$backup_file" "$db_name.sql" *

# Xóa file .sql không cần thiết sau khi đã nén
rm "$db_name.sql"

echo "Backup hoàn thành! Tập tin backup được lưu với tên $backup_file"
