#!/bin/bash
mem=$(free -m | awk '/Mem:/{print $4}')
#echo $mem
#Restart php-fpm when free memory too low
(( mem <= 70 )) && systemctl restart php-fpm
