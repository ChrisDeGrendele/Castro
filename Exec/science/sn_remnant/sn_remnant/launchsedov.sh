#!/bin/bash
#SBATCH -N 128
#SBATCH -C haswell
#SBATCH -q regular
#SBATCH -J Sedov
#SBATCH -t 01:30:00

#OpenMP settings:
export OMP_NUM_THREADS=1
export OMP_PLACES=threads
export OMP_PROC_BIND=spread


#run the application:
srun -n 2048 -c 4 --cpu_bind=cores /global/homes/c/chrisdeg/codes/Castro/Exec/hydro_tests/Sedov/Castro3d.gnu.haswell.MPI.ex inputs.starlord
