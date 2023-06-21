#!/bin/bash

# Đường dẫn lưu backup
backup_dir="/opt/zimbra/backup/zm-backup"

# Định dạng ngày-tháng-năm
date_format=$(date +'%d-%m-%Y')

# Tạo thư mục backup mới
new_backup_dir="$backup_dir/$date_format"
mkdir -p "$new_backup_dir"

# Tên file log
log_file="/opt/zimbra/backup/logs/zm.log"
user_log_file="/opt/zimbra/backup/logs/user.log"

# Backup danh sách tài khoản
echo "$(date): Starting backup" >> "$log_file"

/opt/zimbra/bin/zmprov -l gaa | while read -r account; do
    backup_file="$new_backup_dir/backup-$account.tgz"

    /opt/zimbra/bin/zmmailbox -z -m "$account" getRestURL "/?fmt=tgz" > "$backup_file"

    if [ -f "$backup_file" ]; then
        echo "$(date): Backup successful for user $account" >> "$user_log_file"
    else
        echo "$(date): Backup failed for user $account" >> "$user_log_file"
    fi
done

# Số lượng thư mục backup hiện tại
backup_count=$(ls -l "$backup_dir" | grep '^d' | wc -l)

# Xóa thư mục backup cũ nếu số lượng vượt quá 3
if [ "$backup_count" -gt 3 ]; then
    oldest_backup=$(ls -t "$backup_dir" | tail -1)
    rm -rf "$backup_dir/$oldest_backup"
fi

echo "$(date): Backup completed" >> "$log_file"
