#!/bin/bash

#inotifywait -e close_write,delete,create,attrib (写入大文件可如此)

host1=192.168.56.2
host2=192.168.56.3
host3=192.168.56.4
src=/root/backup/
dst=web
user=webuser
/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' -e modify,delete,create,attrib  $src \
| while read files
        do
            /usr/local/bin/rsync -vzrtopg --delete --progress --password-file=/etc/server.pass $src $user@$host1::$dst
#            /usr/local/bin/rsync -vzrtopg --delete --progress --password-file=/etc/server.pass $src $user@$host2::$dst
            /usr/local/bin/rsync -vzrtopg --delete --progress --password-file=/etc/server.pass $src $user@$host3::$dst
            echo "${files} was rsynced" >> /tmp/rsync.log 2>&1
        done
