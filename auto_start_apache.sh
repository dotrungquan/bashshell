#!/bin/sh
check=`cat /proc/loadavg | sed 's/\./ /' | awk '{print $1}'`
if [ $check -gt 10 ]
then
/etc/init.d/httpd restart
fi
