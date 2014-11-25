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
echo "ulimit -SHn 102400" >> /etc/rc.local
#set locale
cat >> /etc/sysconfig/i18n <<EOF
LANG="zh_CN.GB18030"
EOF
#set sysctl
true > /etc/sysctl.conf
/sbin/sysctl -p
echo 'sysctl set ok!'
#close ctrl + alt + del
#set purview
#disable ipv6
#disable selinux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
echo "selinux id disabled"
#vim
sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
echo 'syntax on' > /root/.vimrc
#zh_cn
sed -i -e 's/^LANG=.* /LANG="en"/' /etc/sysconfig/i18n
#init ssh
ssh_cf="/etc/ssh/sshd_config"
#turnoff services
cat << EOF
+------------------------------------------------------------+
|                  Turnoff  services                         |
+------------------------------------------------------------+
EOF

for i in `ls /etc/rc3.d/S*`
do
    CURSRV=`echo $i -c 15-`
    case $CURSRV in
        crond | irqbalance | network | random | sshd | syslog | local)
    echo $CURSRV
