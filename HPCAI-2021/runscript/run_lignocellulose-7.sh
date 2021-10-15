#!/bin/bash

export MKL_LIB=/opt/intel/oneapi/mkl/2021.3.0/lib/intel64/
export COMPILER=/opt/intel/oneapi/compiler/2021.3.0/linux/compiler/lib/intel64_lin/
export DATA="/home/data/run" 
export OMP_NUM_THREADS=6

source /tools/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-ubuntu16.04-x86_64/hpcx-mt-init-ompi.sh
hpcx_load

cd $DATA

mpirun -x \
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MKL_LIB:$COMPILER \
-n 4 \
mdrun_mpi -ntomp ${OMP_NUM_THREADS} \
-s lignocellulose-rf.tpr \
-v -noconfout \
-maxh 0.1 \
-resethway \
-nsteps 100000 \
-pin on \
-nb cpu
