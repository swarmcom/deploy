#!/bin/sh
for FOLDER in timescale rr kamailio freeswitch reach3 reach-ui nginx
do
	cd $FOLDER && ./run.sh && cd ../
done
exit

