#!/bin/bash

if [ $# -eq 0 ];then
    echo 'Error: please specify logfile.'
    exit 1

else 
    LOG=$1
fi

if [ ! -f $LOG ];then
    echo 'log file no found!'
    exit 2
fi

###############################
echo 'Most of time:'
echo '-----------------------------------'
awk '{print $4}' $LOG  | cut -c 14-18 | sort | uniq -c | sort -rn | head -10
echo 
echo 
##############################
echo 'Most of ip:'
echo '---------------------------------'
awk '{print $1}' $LOG | sort | uniq -c | sort -rn | head -10
echo 
echo 
##############################
echo 'Most of page'
echo '---------------------------------'
awk '{print $11}' $LOG | sed 's/^.*\(.cn*\)/\1/g' | sort | uniq -c |sort -rn | head -10
echo 
echo 
################################
echo 'Most of time / most of ip:'
echo '-----------------------------------'
temp=`mktemp timelog.XXXX`
awk '{print $4}' $LOG  | cut -c 14-18 | sort | uniq -c | sort -rn | head -10  > $temp
for i in `awk '{print $2}' $temp`
do
    num=`grep $i $temp | awk '{print $1}'`
    echo "$i $num"
    ip=`grep $i $LOG | awk '{print $1}' | sort -n | uniq -c | sort -rn | head -10`
    echo -e $ip
    echo
done
rm -f $temp
