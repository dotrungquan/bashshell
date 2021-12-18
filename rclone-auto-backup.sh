#!/bin/bash
#Auth: QUAN
 
SERVER_NAME=dotrungquan ## Tên thư mục trong Google Drive 
 
TIMESTAMP=$(date +"%F")
BACKUP_DIR="/root/backup/$TIMESTAMP"
MYSQL_USER="root"
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD="s6faahjqHo66fpL" ## Nhap Pass Root MYSQL cua ban vao
MYSQLDUMP=/usr/bin/mysqldump
SECONDS=0
 
mkdir -p "$BACKUP_DIR/mysql"

echo "Backup Database In Process";
databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)"`
 
for db in $databases; do
	$MYSQLDUMP --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
done
echo "Backup Database Successful";
echo '';
 
echo "Backup Website In Process";
# Loop through /home directory
for D in /home/*; do
	if [ -d "${D}" ]; then #If a directory
		domain=${D##*/} # Domain name
		echo "- "$domain;
		zip -r $BACKUP_DIR/$domain.zip /home/$domain/public_html/ -q -x /home/$domain/public_html/wp-content/cache/**\* #Exclude cache
	fi
done
echo "Backup Website Successful";
echo '';

echo "Dang tien hanh Backup len Google Drive";
/usr/sbin/rclone move $BACKUP_DIR "remote:$SERVER_NAME/$TIMESTAMP" >> /var/log/rclone.log 2>&1  #remote: remote config name created in previous step.
# Clean up
rm -rf $BACKUP_DIR  #Delete backup directory on VPS
/usr/sbin/rclone -q --min-age 2w delete "remote:$SERVER_NAME" #Remove all backups older than 2 week on Google Drive Backup Directory
/usr/sbin/rclone -q --min-age 2w rmdirs "remote:$SERVER_NAME" #Remove all empty folders older than 2 week Google Drive Backup Directory
/usr/sbin/rclone cleanup "remote:" #Cleanup Trash , Delete all files in trash directory
echo "Da dua tat ca du lieu len Gooogle Drive hoan tat";
echo '';
 
duration=$SECONDS
echo "Total $size, $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
