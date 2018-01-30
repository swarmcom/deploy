#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
REACH_NODE=${REACH_NODE:-"reach@reach.$NETWORK"}
NAME=${NAME:-"kamailio.$NETWORK"}
NODE=${NODE:-"kamailio@$NAME"}
EXT_IP=${EXT_IP:-"$(curl -s ifconfig.co)"}
PORTMAP=${PORTMAP:-"-p 5060:5060/udp"}

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

echo -n "starting: $NAME ext_ip: $EXT_IP "
docker run $FLAGS $PORTMAP \
	--net $NETWORK \
	-h $NAME \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env REACH_NODE=$REACH_NODE \
	--env NAME=$NAME \
	--env EXT_IP=$EXT_IP \
	--env NODE=$NODE \
	reach3/kamailio
