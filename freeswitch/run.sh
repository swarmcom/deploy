#!/bin/sh -e
FLAGS=${1:-"-td"}
NETWORK=${NETWORK:-"reach3"}
NAME=${NAME:-"freeswitch.$NETWORK"}
REACH_NODE=${REACH_NODE:-"reach@reach.$NETWORK"}
REACH_HOST=${REACH_HOST:-"http://reach.$NETWORK:8937"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

echo -n "starting: $NAME "
docker run $FLAGS \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NODE=freeswitch@$NAME \
	--env REACH_NODE=$REACH_NODE \
	--env REACH_HOST=$REACH_HOST \
	reach3/freeswitch
