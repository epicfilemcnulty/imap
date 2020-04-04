#!/bin/sh

trap cleanup SIGTERM SIGINT SIGQUIT SIGKILL
cleanup () {
    echo "Caught TERM sig, stopping dovecot..."
    doveadm stop
}


/usr/sbin/dovecot -c /etc/dovecot/dovecot.conf

while true; do
    sleep 10
    pid=$(cat /run/dovecot/master.pid)
    if [[ ! -d "/proc/${pid}" ]]; then
        echo "Dovecot process ${pid} is not running!"
        exit 1
    fi
done
