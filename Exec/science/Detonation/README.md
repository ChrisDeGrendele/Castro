To generate the hang compile with

make -j4 DIM=1 USE_GRAV=TRUE USE_MPI=TRUE USE_OMP=TRUE EOS_DIR=helmholtz NETWORK_DIR=aprox13

and run with

mpirun -np 16 ./Castro1d.gnu.MPI.OMP.ex inputs

This will run 2000 steps. When it fails, it fails non-deterministically and sometimes not at
all, so you may have to run it a few times to see the failure.
