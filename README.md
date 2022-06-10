# mpi_compose
Mpi cluster using docker-compose

Scripts set up and run a cluster using docker-compose.

<!--
## Building image or getting it from DockerHub

To create an image:

```bash
sudo ./build_image.sh
```
This image create a user `mpi` with `UID=1000`. This is useful to share the directory `work` with the host and the cluster nodes.

To get an image from DockerHub:
```bash
sudo docker pull darlon/mpi
sudo docker tag darlon/mpi mpi
```
-->

## Configuring cluster

Let's configure a cluster with `20` machines. The parameter -n set the number of cluster nodes.

```bash
sudo ./cluster.sh -n 20 -r
```

This configuration consists on get the nodes' IP ad resses (machinefile) and generate ssh keys. If more nodes are needed, this script must be re-executed. `-r` must be **after** `-n`. The generated IP addresses list will be put inside the `work` directory. 

Inside containers, there is a `mpi` user with `UID=1000`. The `work` directory must have write permissions to the user with this UID on host, in order to keep this files and write processes outputs. If needed to user another UID, a new image must be built.

This command will start the cluster, configure it and stop it.

## Getting cluster up
Start the cluster, with 10 nodes. This number must be smaller than the number of nodes set when executed with `-r`.
```bash
sudo ./cluster.sh -n 10
```

Test the cluster, with a specific number of jobs. By default, openmpi uses the maximum of 4 jobs per node.
```bash
sudo ./cluster.sh -t 20
```

Shutting the cluster down
```bash
sudo ./cluster.sh -s
```

Setting more nodes to the cluster
```bash
sudo ./cluster.sh -n 30 -r
```

Showing nodes states
```bash
sudo ./cluster.sh -u
```

## Running MPI
To open a bash on master node, use `-e`. The nodes' ip addresses are on `work` directory.
```bash
sudo ./cluster.sh -e
```

**Example**  
```bash
sudo ./cluster.sh -e
pwd
cd work
mpicc -o bin/hello_c src/hello_c.c src/hello_c.c
mpirun -np 4 -machinefile ip_worker.txt bin/hello_c
```

