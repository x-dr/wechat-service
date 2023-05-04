#!/usr/bin/env bash
set -ex

if [ -n "$VNC_PASSWORD" ]; then
    echo -n "$VNC_PASSWORD" > /home/app/.password1
    x11vnc -storepasswd $(cat /home/app/.password1) /home/app/.password2
    chmod 400 /home/app/.password*
    export VNC_PASSWORD=
fi

RUN_XTERM=${RUN_XTERM:-no}
case $RUN_XTERM in
  false|no|n|0)
    sudo rm -f /etc/supervisord.d/xterm.conf
    ;;
esac
exec sudo -E bash -c 'supervisord -c /etc/supervisord.conf -l /var/log/supervisord.log'
