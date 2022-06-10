#!/bin/bash

NP=10

#Cluster up
cluster_up(){
	echo "**** Starting cluster ***"
	docker-compose up -d --scale worker="${1}"
}

#Cluster down
cluster_stop(){
	echo "**** Stopping cluster ***"
	docker-compose stop
	echo "**** Cluster down ***"
}

#Cluster test
cluster_test(){
	echo "**** Executing test ***"
	./mpi_test.sh -c -n "${1}"
	echo "**** Test done ***"
}

while getopts n:hst: flag
do
	case "${flag}" in
		h)
			echo "${0}" '[-h|-n <np>]'
			echo "	-h : this help menu."
			echo "	-s : stop the cluster."
			echo "	-t <np>: execute cluster test with np processes."
			echo "	-n <np> : set the number of containers to configure for the cluster. Default: 10."
			exit 0
			;;
		n) 
			NP="${OPTARG}" 
			;;
		t)
			cluster_test "${OPTARG}" 
			exit 0
			;;
		s)
			cluster_stop
			exit 0
			;;
		*)
			echo "Wrong args. see ${0} -h"
			exit 1
			;;
	esac
done

cluster_up "${NP}"
