#!/bin/bash
echo "Welcome to dotrungquan.info"
echo "script sync time DirectADmin"
yum install ntp
chkconfig ntpd on
ntpdate pool.ntp.org
service ntpd start
