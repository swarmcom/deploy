#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
NAME=${NAME:-"reach-ui.$NETWORK"}
REACH_WS=${REACH_WS:-""}
CFG_DB=${CFG_DB:-"$HOME/db"}
HUB=${HUB:-"reach3"}

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

# file must exist
mkdir -p $CFG_DB
touch $CFG_DB/reach_db.json

echo -n "starting: $NAME data: $CFG_DB "
docker run $FLAGS \
	-v $CFG_DB:/home/user/reach/db \
	--net $NETWORK \
	-h $NAME \
	--restart=always \
	--name $NAME \
	--env NETWORK=$NETWORK \
	--env REACH_WS=$REACH_WS \
	$HUB/reach-ui
