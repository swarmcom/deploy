#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
PASSWORD=${PASSWORD:-"reachpass"}
NAME=${NAME:-"timescale.$NETWORK"}

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
	--env NETWORK=$NETWORK \
	reach3/timescale

sleep 5
docker exec -it --user postgres $NAME psql -c "CREATE USER reach WITH PASSWORD '$PASSWORD'"
docker exec -it --user postgres $NAME createdb -O reach reach
docker exec -it --user postgres $NAME psql -c "CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE" reach
