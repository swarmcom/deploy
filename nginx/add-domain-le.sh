#!/bin/sh
DOMAIN=$1
NETWORK=${2:-"reach3"}
if [ -z $DOMAIN ]
then
	echo Usage: $0 domain network
	exit
fi
./le $DOMAIN $USE_LE
./gen-conf-le.sh $DOMAIN $NETWORK > conf.d/$DOMAIN.conf
./build.sh
./run.sh
