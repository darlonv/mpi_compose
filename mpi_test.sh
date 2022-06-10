#!/bin/bash

CONTAINER_MASTER="mpi_compose_master_1"
NP=4

compile(){
	echo '== Compiling C Hello .. =='
	docker exec --user mpi "${CONTAINER_MASTER}" bash -c "/usr/bin/mpicc -o ~/work/bin/hello_c ~/work/src/hello_c.c"
}


echo '=========================='

while getopts n:ch flag
do
	case "${flag}" in
		n) 
			NP="${OPTARG}" 
			;;
		c)
			compile
			;;
		h)
			echo "${0}" '[-h|-c|-n <np>]'
			echo "	-h : this help menu."
			echo "	-c : compile src code."
			echo "	-n np : set the np number of process to be used on test. Default: 4."
			exit 0
			;;
	esac
done


echo '== Executing C Hello .. =='
docker exec --user mpi "${CONTAINER_MASTER}" bash -c "mpirun --hostfile ~/work/ip_worker.txt -np $NP ~/work/bin/hello_c"
echo '== C Hello done. =='
echo '=========================='
