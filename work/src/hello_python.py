#
#Author: Darlon Vasata
#


from mpi4py import MPI

comm = MPI.COMM_WORLD
mpi_rank = comm.Get_rank()
mpi_size = comm.Get_size()

print(f'[Python] Hello World! My MPI_rank is {mpi_rank} of {mpi_size}.')
