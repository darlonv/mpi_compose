#
#Author: Darlon Vasata
#

from mpi4py import MPI
from termcolor import colored

mpi_comm = MPI.COMM_WORLD
mpi_rank = mpi_comm.Get_rank()
mpi_size = mpi_comm.Get_size()

dest = mpi_rank-1
src = mpi_rank+1

rank_color = colored(mpi_rank, "red")

sent_color = colored('sent', 'yellow')
recv_color = colored('recv', 'blue')

#The highest rank only send message
if mpi_rank == mpi_size -1:
    mpi_comm.send(mpi_rank, dest=dest)
    
    print(f'[{rank_color}] Data {sent_color} to {dest}')

if mpi_rank != mpi_size -1:
    
    #Everyone but highest receive message
    val_rec = mpi_comm.recv(source = src)
    print(f'[{rank_color}] Data {recv_color} from {src}')

    #Everyone but the smallest rank send message
    if mpi_rank!=0:
        mpi_comm.send(mpi_rank, dest=dest)
        print(f'[{rank_color}] Data {sent_color} to {dest}')
