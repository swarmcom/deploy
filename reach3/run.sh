#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
NAME=${NAME:-"reach.$NETWORK"}
FSNODE=${FSNODE:-"freeswitch@freeswitch.$NETWORK"}
KAMNODE=${KAMNODE:-"kamailio@kamailio.$NETWORK"}
NODE=${NODE:-"reach@$NAME"}
VOLUME=db-$NAME

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	STAMP=`date +%Y-%m-%d-%H-%M-%S`
	mkdir -p logs
	docker logs $NAME > logs/$STAMP

	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

if [ -z $(docker volume ls  -q -f name=$VOLUME) ]
then
	docker volume create $VOLUME
fi

echo -n "starting: $NAME "
docker run $FLAGS \
	-v $VOLUME:/home/user/reach/db \
	--net $NETWORK \
	-h $NAME \
	--restart=always \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env NODE=$NODE \
	--env FSNODE=$FSNODE \
	--env KAMNODE=$KAMNODE \
	ezuce/reach
