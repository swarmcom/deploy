#!/bin/sh
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
NAME=${NAME:-"rr.$NETWORK"}
NODE=${NODE:-"rr@$NAME"}
VOLUME=${VOLUME:-"db-$NAME"}
HUB=${HUB:-"reach3"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

if [ ! -z $CLEAR_RR_DATA ]
then
	docker volume rm $VOLUME
fi

if [ -z $(docker volume ls -q -f name=$VOLUME) ]
then
	docker volume create $VOLUME
fi

echo -n "starting: $NAME volume: data: $VOLUME"
docker run $FLAGS \
	-v $VOLUME:/home/user/rr/data \
	--net $NETWORK \
	-h $NAME \
	--restart=always \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env NODE=$NODE \
	$HUB/rr
