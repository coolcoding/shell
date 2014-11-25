#!/bin/bash

function pingA(){
    for ip in `seq 1 254`
    do
        (
            ip='192.168.1.'${ip}
            ping -c2 $ip &> /dev/null
            if [ $? -eq 0 ];then
                echo "$ip is alive"
            fi
        ) &
    done
}

function pingB(){
for n in {1..254};do
    host=192.168.1.$n
    ping -c2 $host &> /dev/null
    if [ $? = 0 ];then
        echo "$host is UP"
        
    else
        echo  "$host is DOWN"
    fi
done


}


pingB
