FROM ubuntu:22.04

#Setting mpi user on container in order to write on user shared directory
ARG USERID=1000

#Install packages
# - ssh server
# - ifconfig
# - gcc
# - python 3.10
# - openmpi
RUN apt update && apt -y install openssh-server net-tools gcc python3-pip python3.10 python3.10-doc openmpi-common openmpi-bin libopenmpi-dev

#install mpi for python
RUN pip3 install mpi4py


#Create user
#user mpi 
#pass mpi
RUN useradd -ms /bin/bash mpi -u $USERID -p '$1$hHHifel0$rGQBO4jGzfuXCFa/tNRTx.'

#Start ssh on boot and keep container running
ENTRYPOINT service ssh start && echo Keeping container up.. && tail -f /dev/null



