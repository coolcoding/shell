#!/bin/sh

TMP_PREFIX="/tmp/ddos"
BAN_IP_LIST_TMP=`mktemp $TMP_PREFIX.XXXXX`
BANNED_IP_LIST="/tmp/banned.ip.list"
IGNORE_IP_LIST="/tmp/ignore.ip.list"
MAX_CONNECTIONS=2
IPT="/sbin/iptables"

if [ ! -f $BANNED_IP_LIST ];then
    touch $BANNED_IP_LIST
fi

if [ ! -f $IGNORE_IP_LIST ];then
    touch $IGNORE_IP_LIST
fi

function iptablesBan(){
#    netstat -ntu | awk '/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A[i],i}' | sort -rn | head -n10 | tee  ${BAN_IP_LIST_TMP}
    netstat -ntu | awk '/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A[i],i}' | sort -rn | head -n10 > ${BAN_IP_LIST_TMP}
    while read line; do
        NUM=$(echo ${line} | cut -d" " -f1)
        IP=$(echo ${line} | cut -d" " -f2)
        if [ ${NUM} -lt ${MAX_CONNECTIONS} ]; then
            continue
        fi
        IGNORE_BAN=`grep -c ${IP} ${IGNORE_IP_LIST}`
        if [ ${IGNORE_BAN} -ge 1 ]; then
            continue
        fi
        BANNED_BAN=`grep -c ${IP} ${BANNED_IP_LIST}`
        if [ ${BANNED_BAN} -ge 1 ]; then
            continue
        fi
        echo ${IP} >> ${BANNED_IP_LIST}
        ${IPT} -I INPUT -s ${IP} -j DROP
        /sbin/service iptables save
    done  < ${BAN_IP_LIST_TMP}
}

while :
do
    iptablesBan
    /bin/sleep 10
    rm -f $BAN_IP_LIST_TMP
done
