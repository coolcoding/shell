#!/bin/bash

#deny ssh host
secure_path='/var/log/secure'
black_path=`mktemp black.XXXX`
MAXIP=5
#sed -n '/sshd/p' $secure_path | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $2"="$1}'| tee  $black_path
sed -n '/sshd/p' $secure_path | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $2"="$1}' > $black_path
for i in `cat $black_path`
do
    IP=`echo $i | awk -F= '{print $1}'`
    NUM=`echo $i | awk -F= '{print $2}'`
    if [ $NUM -gt $MAXIP ];then
        grep $IP /etc/hosts.deny > /dev/null
        if [ $? -ne 0 ];then
            echo "sshd:$IP" >> /etc/hosts.deny
        fi
    fi
done



rm -f $black_path
