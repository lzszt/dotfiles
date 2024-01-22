#! /usr/bin/env sh

DATE=`date +%Y-%m-%d`
REGEX="^$DATE, (\d{1,2}:\d\d)"

TIME_TOTAL=`ssh root@apps.lzszt.info '/root/shortcuts -x c947767a-37f4-913f-1009-e97e87cee4b9 --config-path /etc/nixos/shortcuts/prod.conf --current-net-hours -n 1' | tail -n1 | rg "$REGEX" -or '$1'`
TIME_ILLWERKE=`ssh root@apps.lzszt.info '/root/shortcuts -x c947767a-37f4-913f-1009-e97e87cee4b9 --config-path /etc/nixos/shortcuts/prod.conf --current-net-hours --project Illwerke -n 1' | tail -n1 | rg "$REGEX" -or '$1'`
TIME_IT=`ssh root@apps.lzszt.info '/root/shortcuts -x c947767a-37f4-913f-1009-e97e87cee4b9 --config-path /etc/nixos/shortcuts/prod.conf --current-net-hours --project IT -n 1' | tail -n1 | rg "$REGEX" -or '$1'`

echo $TIME_TOTAL $TIME_ILLWERKE $TIME_IT