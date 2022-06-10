# mpi_compose
Mpi cluster using docker-compose

Scripts to create an image


## Building image or getting it from DockerHub

To create an image:

```bash
sudo ./build_image.sh
```

To get an image from DockerHub:
```bash
sudo docker pull darlonv/mpi
```

## Configuring cluster

Let's configure a cluster with `20` machines. The parameter -n set the number of cluster nodes.

```bash
sudo ./cluster.sh -n 20 -r
```

This configuration consists on get the nodes' IP adresses and generate ssh keys. If more nodes are needed, this script must be re-executed.

## Getting cluster up
Start the cluster, with 10 nodes.
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

