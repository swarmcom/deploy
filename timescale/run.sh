#!/bin/sh -e
FLAGS=${FLAGS:-"-td"}
NETWORK=${NETWORK:-"reach3"}
PASSWORD=${PASSWORD:-"reachpass"}
NAME=${NAME:-"timescale.$NETWORK"}
VOLUME=db-$NAME

if [ -n "$(docker ps -aq -f name=$NAME)" ]
then
	echo -n "stopping: "
	docker stop -t 1 $NAME
	echo -n "removing: "
	docker rm -f $NAME
fi

if [ -z $(docker volume ls  -q -f name=$VOLUME) ]
then
	CREATE_VOLUME=1
	docker volume create $VOLUME
fi

echo -n "starting: $NAME data:$VOLUME "
docker run $FLAGS \
	-v $PG_DB:/var/lib/postgresql/data \
	--net $NETWORK \
	-h $NAME \
	--restart=always \
	--name $NAME \
	--env NETWORK=$NETWORK \
	ezuce/timescale

if [ ! -z $CREATE_VOLUME ]
then
	docker exec $NAME /wait-for.sh "CREATE USER reach WITH PASSWORD '$PASSWORD' SUPERUSER"
	docker exec $NAME /wait-for.sh "CREATE DATABASE reach OWNER reach"
	docker exec $NAME /wait-for.sh "GRANT ALL PRIVILEGES ON DATABASE reach to reach"
else
	echo Skip database initialization, data volume exists
fi
