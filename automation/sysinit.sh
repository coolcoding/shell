#!/bin/bash

cat << EOF
+------------------------------------------------------------+
|                  Centos System init                        |
+------------------------------------------------------------+
EOF

#set ntp
yum -y install ntp
echo "* 1 * * *  /usr/sbin/ntpdate s1a.time.edu.cn  > /dev/null 2>&1" >> /etc/crontab
service crond restart
#set ulimit
echo "ulimit -SHn 102400"
