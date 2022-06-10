#!/bin/bash

#Get container ips
echo -n "Getting node's IP addresses.. "
for NAME in 'master' 'worker'
do
	#echo '=================='

	#echo "Getting $NAME IP addresses..."
	> ip_.tmp
	for IP in $(docker ps | grep _"$NAME"_ | awk '{print $1}')
	do
		docker exec $IP bash -c "/sbin/ifconfig eth0 | /usr/bin/egrep -o 'inet.* netmask'" >> ip_.tmp
	done

	awk '{print $2}' ip_.tmp > ip_"$NAME".txt
	rm ip_.tmp
	#cat ip_"$NAME".txt
	mv ip_"$NAME".txt ./work/
	docker exec $IP bash -c "/usr/bin/chown mpi.mpi /home/mpi/work/ip_${NAME}.txt"
done
echo "done."
#echo '=================='
