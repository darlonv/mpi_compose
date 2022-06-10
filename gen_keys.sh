#!/bin/bash

echo Generating new ssh keys...
mkdir -p /home/mpi/.ssh
ssh-keygen -q -t rsa -N "" -f /home/mpi/.ssh/id_rsa <<<y >/dev/null 2>&1
cp /home/mpi/.ssh/id_rsa.pub /home/mpi/.ssh/authorized_keys


> /home/mpi/.ssh/known_hosts
grep -h "" /home/mpi/work/ip_master.txt | xargs ssh-keyscan >> /home/mpi/.ssh/known_hosts 2>/dev/null
grep -h "" /home/mpi/work/ip_worker.txt | xargs ssh-keyscan >> /home/mpi/.ssh/known_hosts 2>/dev/null

chown -R mpi.mpi /home/mpi/.ssh

