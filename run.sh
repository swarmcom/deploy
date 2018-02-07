#!/bin/sh
docker network create reach3
for FOLDER in timescale rr kamailio freeswitch reach3 reach-ui
do
	cd $FOLDER && ./run.sh && cd ../
done

cd nginx && ./build.sh && ./run.sh

FS_IP=`bin/get-ip freeswitch.reach3`
/sbin/iptables -t nat -A PREROUTING -i eth0 -p udp -m udp --dport 10000:12000 -j DNAT --to-destination $FS_IP
