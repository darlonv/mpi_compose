#!/bin/bash

NP=10

#Cluster up
cluster_up(){
	echo "**** Starting cluster ****"
	docker-compose up -d --scale worker="${1}"
	#Update ips list
	./get_ips.sh
}

#Cluster down
cluster_stop(){
	echo "**** Stopping cluster ****"
	docker-compose stop
	echo "**** Cluster down ****"
}

#Cluster test
cluster_test(){
	echo "**** Executing test ****"
	./mpi_test.sh -c -n "${1}"
	echo "**** Test done ****"
}

cluster_status(){
	docker-compose ps
}

reset_ssh_keys(){
	#Geting master container id
	MASTER_ID=$(awk '{print $1}' <(docker-compose ps | egrep master))
	
	#copy script to generate ssh keys to master
	docker cp gen_keys.sh "$MASTER_ID":/home/mpi/
	
	echo "Generating ssh keys on Master (${MASTER_ID}) .."
	docker exec --user mpi "$MASTER_ID" /home/mpi/gen_keys.sh

	#Copy .ssh to other containers
	echo "Getting keys from Master.."
	docker cp "$MASTER_ID":/home/mpi/.ssh .
	for WORKER_NAME in $(awk '{print $1}' <(docker-compose ps | egrep worker))
	do
		echo "Copying keys to Worker $WORKER_NAME .."
		docker cp .ssh "$WORKER_NAME":"/home/mpi/"
		echo $WORKER_NAME
#		docker exec -t "$WORKER_NAME" bash -c "/usr/bin/ls /"
		docker exec "$WORKER_NAME" bash -c '/usr/bin/chown -R mpi.mpi /home/mpi/.ssh'
	done
	rm -r .ssh
}

while getopts n:hst:ure flag
do
	case "${flag}" in
		h)
			echo "${0}" '[-h|-n <np>]'
			echo "	-h : this help menu."
			echo "  -e : execute a bash on Master node."
			echo "	-r : set the cluster size and generate new ssh keys."
			echo "	-s : stop the cluster."
			echo "	-t <np>: execute cluster test with np processes."
			echo "	-u : show running cluster containers."
			echo "	-n <np> : set the number of containers to configure for the cluster. Default: 10."
			exit 0
			;;
		e)
			#Geting master container id
	MASTER_ID=$(awk '{print $1}' <(docker-compose ps | egrep master))
			docker exec --user mpi -w '/home/mpi' -it "${MASTER_ID}" bash 
			;;
		n) 
			NP="${OPTARG}"
			cluster_up "${NP}"
			;;
		r)
#			cluster_up "${NP}"
			reset_ssh_keys
			cluster_stop
			exit 0
			;;
		t)
			cluster_test "${OPTARG}" 
			exit 0
			;;
		s)
			cluster_stop
			exit 0
			;;
		u)
			cluster_status
			exit 0
			;;
		*)
			echo "Wrong args. see ${0} -h"
			exit 1
			;;
	esac
done

if [ $# -eq 0 ]
then
	cluster_up "${NP}"
fi
