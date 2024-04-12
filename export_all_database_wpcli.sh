#!/bin/bash

# Yêu cầu người dùng nhập đường dẫn gốc của các website
echo "Vui lòng nhập đường dẫn gốc của các website (Ví dụ: /usr/local/lsws/):"
read WEBSITE_BASE_DIR

# Kiểm tra nếu đường dẫn không kết thúc bằng dấu '/' thì thêm vào
if [[ "${WEBSITE_BASE_DIR}" != */ ]]; then
    WEBSITE_BASE_DIR="${WEBSITE_BASE_DIR}/"
fi

# Lặp qua tất cả các website trong thư mục
for dir in "${WEBSITE_BASE_DIR}"*"/html"; do
    # Kiểm tra nếu đường dẫn tồn tại và là thư mục
    if [ -d "$dir" ]; then
        # Lấy tên miền từ đường dẫn
        domain=$(basename $(dirname "$dir"))

        # Đường dẫn cho file SQL xuất ra
        sql_file="$dir/${domain}_database.sql"

        # Thực hiện lệnh export database
        echo "Exporting database for $domain"
        wp db export --allow-root --path="$dir" "$sql_file"
    fi
done
