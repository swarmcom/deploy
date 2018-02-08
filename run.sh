#!/bin/sh
USE_LE=${USE_LE:-""}
DOMAIN=$1
export NETWORK=${2:-"reach3"}

if [ -z $DOMAIN ]
then
	echo Usage: $0 domain [network]
	exit
fi

docker network create $NETWORK
for FOLDER in timescale rr kamailio freeswitch reach3 reach-ui
do
	cd $FOLDER && ./run.sh && cd ../
done

cd nginx && ./build.sh && ./run.sh && cd ../

FS_IP=`bin/get-ip freeswitch.$NETWORK`
sudo /sbin/iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 10000:12000 -j DNAT --to-destination $FS_IP

if [ -z $USE_LE ]
then
	cd nginx && ./add-domain.sh $DOMAIN $NETWORK && cd ../
else
	export USE_LE
	cd nginx && ./add-domain-le.sh $DOMAIN $NETWORK && cd ../
fi
