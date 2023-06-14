#!/bin/bash
# Author: DOTRUNGQUAN.INFO

# Nhập tên miền hoặc địa chỉ IP
read -p "Nhập tên miền hoặc địa chỉ IP: " domain

# Tạo thư mục chứa chứng chỉ SSL
mkdir ssl_cert
cd ssl_cert

# Tạo khóa riêng tư
openssl genrsa -out private.key 2048

# Tạo yêu cầu chứng chỉ (CSR)
openssl req -new -key private.key -out certificate.csr -subj "/CN=${domain}"

# Tạo chứng chỉ tự lý sử dụng CSR và khóa riêng tư
openssl x509 -req -days 365 -in certificate.csr -signkey private.key -out certificate.crt

# Hiển thị thông tin về chứng chỉ
openssl x509 -text -noout -in certificate.crt

echo "Quá trình tạo chứng chỉ SSL tự lý đã hoàn tất."
