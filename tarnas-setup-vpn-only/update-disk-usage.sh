#!/bin/bash
if [ $# -eq 0 ]; then
	echo "missing nginx file path" >&2
	exit 1
fi

NGINX_FILE_PATH=$1
DL_PCT=$(df --output=pcent /dev/nvme0n1p2 | tail -1 | tr -dc '0-9')
ST_PCT=$(df | grep /home/tarnas/media-server/radarr/movies | awk '{ print $5; exit }'| tr -dc '0-9')
NOW=$(date '+%Y-%m-%d %H:%M')

sed -i "s/--downloads-percent: [0-9]\+/--downloads-percent: $DL_PCT/" $NGINX_FILE_PATH
sed -i "s|id=\"last-updated-time\">[^<]*<|id=\"last-updated-time\">$NOW<|" $NGINX_FILE_PATH
# this disk is not always present and if it's unmounted it's gonna return empty
if [ -n "$ST_PCT" ]; then
	sed -i "s/--storage-percent: [0-9]\+/--storage-percent: $ST_PCT/" "$NGINX_FILE_PATH"
fi
