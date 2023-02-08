#!/bin/bash
#Auth: DOTRUNGQUAN.INFO
read -p "Nhap ID: " uid
read -p "Nhap File Nam: " filename
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$uid' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\n/p')&id=$uid" -O '$filename' && rm -rf /tmp/cookies.txt
