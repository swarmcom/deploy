#!/bin/sh
DOMAIN=$1
NETWORK=${2:-"reach3"}

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

cd nginx && ./build.sh && ./run.sh

FS_IP=`bin/get-ip freeswitch.$NETWORK`
sudo /sbin/iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 10000:12000 -j DNAT --to-destination $FS_IP

cd nginx && ./add-domain.sh $DOMAIN $NETWORK && cd ../
