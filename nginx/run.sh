#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
NAME=${NAME:-"nginx.$NETWORK"}
HUB=${HUB:-"reach3"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run $FLAGS \
	-p 80:80 \
	-p 443:443 \
	--net $NETWORK \
	--restart=always \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	-v /home/ezuce/keys-challenge:/challenge \
	-v /home/ezuce/keys:/keys \
	$HUB/nginx
