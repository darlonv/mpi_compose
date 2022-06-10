# mpi_compose
Mpi cluster using docker-compose

Scripts to create an image

##Building image or getting it from DockerHub

##Building image

This step will create an image from

```bash
sudo ./build_image.sh
```

## Configuring cluster

Let's configure a cluster with `10` machines. The parameter -n set the number of cluster nodes.

```bash
sudo ./config_cluster.sh -n 20
```

## Getting cluster up

```bash
sudo ./cluster 
```

Test the cluster
```bash
sudo ./cluster -t
```

Shutdown the cluster
```bash
sudo ./cluster -s
```

