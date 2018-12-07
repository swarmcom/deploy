#!/bin/sh -e
STORAGE=$1
NETWORK=${2:-"reach3"}
HUB=${3:-"reachme3"}

if [ -z $STORAGE ]
then
        echo Usage: $0 storage [network] [hub]
        exit
fi

docker run --rm  \
	-v db-reach.$NETWORK:/home/user/data-reach \
	-v $STORAGE:/backup $HUB/bar \
	 /bin/sh -c 'tar cfz "/backup/backup_$(date +"%Y%m%d%H%M").tar.gz" ./*'


