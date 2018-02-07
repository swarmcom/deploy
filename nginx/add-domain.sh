#!/bin/sh
DOMAIN=$1
NETWORK=${2:-"reach3"}
if [ -z $DOMAIN ]
then
	echo Usage: $0 domain network
	exit
fi
./le $DOMAIN
./gen-conf.sh $DOMAIN $NETWORK
./build.sh
./run.sh
