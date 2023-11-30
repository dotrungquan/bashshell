#!/bin/bash
# Auth: DOTRUNGQUAN.INFO

# Lấy thời gian hiện tại
TIMESTAMP=$(date +"%F")
# Đặt thư mục backup
BACKUP_DIR="mysql_backup/$TIMESTAMP"
# Đặt tên user MySQL
MYSQL_USER=$(whoami)
# Đặt đường dẫn của MySQL, mysqldump
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
# Đặt biến password để nhập từ người dùng
read -s -p "Nhập mật khẩu cPanel: " MYSQL_PASSWORD
echo ""  # In một dòng trống để thụt lề sang script tiếp theo
SECONDS=0

# Tạo thư mục backup nếu nó không tồn tại
mkdir -p "$BACKUP_DIR/mysql"

echo "Backup Database In Process";
# Lấy danh sách các database (loại bỏ hệ thống)
databases=$($MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# Lặp qua từng database và thực hiện backup
for db in $databases; do
    $MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
done
echo "Backup Database Successful";

# Hiển thị thời gian thực hiện
duration=$SECONDS
echo "Thời gian thực hiện: $(($duration / 60)) phút và $(($duration % 60)) giây."
