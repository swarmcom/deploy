#!/bin/sh
DOMAIN=$1
NETWORK=${2:-"reach3"}
if [ -z $DOMAIN ]
then
	echo Usage: $0 domain network
	exit
fi
[ ! -z $USE_LE ] && ./le $DOMAIN $USE_LE
./gen-conf.sh $DOMAIN $NETWORK > conf.d/$DOMAIN.conf
./build.sh
./run.sh

docker exec reach.$NETWORK ./rpc.sh reach_db add_domain b:$DOMAIN
