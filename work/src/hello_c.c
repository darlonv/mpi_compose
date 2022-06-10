/*
Author: Darlon Vasata
*/

#include <stdio.h>
#include "mpi.h"

int main(int argc, char* argv[])
{
    int mpi_rank, //Process id on cluster
     mpi_size;    //Number of cluster processes


    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &mpi_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &mpi_size);
    
    printf("[C] Hello World! My MPI_rank is %d of %d.\n",  mpi_rank, mpi_size);
    MPI_Finalize();

    return 0;
}
