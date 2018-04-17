#!/bin/sh
USE_LE=${USE_LE:-""}
DOMAIN=$1
export NETWORK=${2:-"reach3"}

if [ -z $DOMAIN ]
then
	echo Usage: $0 domain [network]
	exit
fi

echo Update images
for IMAGE in ezuce/reach ezuce/reach-ui nginx ezuce/kamailio ezuce/freeswitch-reach3 ezuce/rr ezuce/timescale
do
	docker pull $IMAGE
done

docker network create $NETWORK
for FOLDER in timescale rr kamailio freeswitch reach3 reach-ui
do
	cd $FOLDER && ./run.sh && cd ../
done

cd nginx && ./build.sh && ./run.sh && cd ../

# This extra rules we need somehow to manage to be able dynamically add containers
EXT_IP=${EXT_IP:-"$(curl -4 -s ifconfig.co)"}
FS_IP=`bin/get-ip freeswitch.$NETWORK`
sudo /sbin/iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 10000:12000 -j DNAT --to-destination $FS_IP
KAM_IP=`bin/get-ip kamailio.$NETWORK`
sudo /sbin/iptables -t nat -A PREROUTING -p udp -m udp -d $EXT_IP --dport 5060 -j DNAT --to-destination $KAM_IP

export USE_LE
cd nginx && ./add-domain.sh $DOMAIN $NETWORK && cd ../

# Configure reach runtime
docker exec reach.$NETWORK ./rpc.sh db_instance_param set a:record_server b:http://rr.$NETWORK:9090
docker exec reach.$NETWORK ./rpc.sh db_instance_param set a:moh_server b:shout://rr.$NETWORK:9091

