#!/bin/sh -e
BACKUP=$1
STORAGE=${2:-$(pwd)}
VOLUME=${3:-"db-reach.reach3"}
HUB=${4:-"reachme3"}

if [ -z $BACKUP ]
then
	echo Usage: $0 backup_file [storage] [volume] [hub]
	exit
fi

docker run --rm \
	 -v $VOLUME:/home/user/data-reach \
	 -v $STORAGE:/backup $HUB/bar \
	 /bin/sh -c "tar xzf /backup/$BACKUP"

