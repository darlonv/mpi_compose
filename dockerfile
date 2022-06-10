FROM ubuntu:22.04

#Setting mpi user on container in order to write on user shared directory
ARG USERID=1000

#install ssh
RUN apt update && apt -y install openssh-server
#install net tools
RUN apt -y install net-tools
#gcc
RUN apt -y install gcc
#install python
RUN apt -y install python3-pip python3.10 python3.10-doc
#install openmpi
RUN apt -y install openmpi-common openmpi-bin libopenmpi-dev
#install mpi for python
RUN pip3 install mpi4py


#Create user
#user mpi 
#pass mpi
RUN useradd -ms /bin/bash mpi -u $USERID -p '$1$hHHifel0$rGQBO4jGzfuXCFa/tNRTx.'
#Add a 

ENTRYPOINT service ssh start && echo Keeping container up.. && tail -f /dev/null



