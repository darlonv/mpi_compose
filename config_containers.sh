#!/bin/bash

NP=10

cluster_up(){
	echo "**** Starting cluster ***"
	docker-compose up -d --scale worker="${1}"
}
cluster_stop(){
	echo "**** Stopping cluster ***"
	docker-compose stop
	echo "**** Cluster down ***"
}

cluster_clean(){
	echo "Removing old containers.. "
	docker-compose rm -f
}

reset_ssh_keys(){
	#copy script to generate ssh keys to master
	docker cp gen_keys.sh "$MASTER_ID":/home/mpi/
	docker exec --user mpi "$MASTER_ID" /home/mpi/gen_keys.sh

	#Copy .ssh to other containers
	docker cp "$MASTER_ID":/home/mpi/.ssh .
	for WORKER_NAME in $(awk '{print $1}' <(docker-compose ps | egrep worker))
	do
		echo "Copying keys to $WORKER_NAME .."
		docker cp .ssh "$WORKER_NAME":/home/mpi/
		docker exec "$WORKER_NAME" chown -R mpi.mpi /home/mpi/.ssh
	done
	rm -r .ssh
}


#



while getopts n:h flag
do
	case "${flag}" in
		n) 
			NP="${OPTARG}" 
			;;
		h)
			echo "${0}" '[-h|-n <np>]'
			echo "	-h : this help menu."
			echo "	-n <np> : set the max number of containers to configure for the cluster. Default: 10."
			exit 0
			;;
	esac
done

echo "========="
echo "Configuring with ${NP} workers."
echo "${0} -h for help"
echo "========="
#Removing old containers
cluster_clean
#Starts cluster
cluster_up "${NP}"

#Getting container ips..
./get_ips.sh

#Geting master container id
MASTER_ID=$(awk '{print $1}' <(docker-compose ps | egrep master))
echo $MASTER_ID
#Create ssh keys
reset_ssh_keys

cluster_stop

echo done.


