
GROMACS: https://github.com/Uzii-hugo/gromacs-2012.3

* Introduction
	In the challenge, We perform using Singularity images. Utilize base images as ubuntu16.04 built on GROMACS version 2021.3 with OpenMPI version 4.1.1 and Intel oneAPI version 2013.3 (C compiler and MKL).
* Requirements
	1. Singularity images
		***gmx-intel-ompi-release.sif (CPU ONLY) 
		***gmx-intel-ompi-gpu-release.sif
		
	2. Run script.
	3. PBS script.
	4. Input File.
		4.1 lignocellulose-tf
		4.2 stmv

* How to run
	******the MPI implementation in the container is solely used.******
	1. Prepare the dataset example Requirements.
		
	2. Run script.
	example
	```
	---------------------------------------------------------------------------------
	#!/bin/bash
	export MKL_LIB=/opt/intel/oneapi/mkl/2021.3.0/lib/intel64/
	export COMPILER=/opt/intel/oneapi/compiler/2021.3.0/linux/compiler/lib/intel64_lin/
	export DATA=<PATH_INPUT_FILE>
	export NUM_OMP_THREADS=<NUM_OMP>

	source /tools/hpcx-v2.9.0-gcc-MLNX_OFED_LINUX-5.4-1.0.3.0-ubuntu16.04-x86_64/hpcx-mt-init-ompi.sh
	hpcx_load

	cd $DATA
	mpirun -x \
	LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MKL_LIB:$COMPILER \
	-n <NUM_MPI> \
	mdrun_mpi -ntomp ${OMP_NUM_THREADS} \
	-s <INPUT_FILE> \
	-v -noconfout \
	-maxh 0.1 \
	-resethway \
	-nsteps 100000 \
	-pin on \
	-nb cpu
	---------------------------------------------------------------------------------
	```

	3. PBS script
	example
	```
	---------------------------------------------------------------------------------
	#!/bin/bash
	#PBS -q normal
	#PBS -l select=<NUM_NODE>:ncpus=<NUM_CPUS>:mpiprocs=<NUM_MPI>:ompthreads=<NUM_OMP>
	#PBS -l walltime=1:00:00
	#PBS -m ae
	#PBS -P 
	#PBS -N GROMACS
	#PBS -o 
	#PBS -e 
	module load singularity
	export PROJ=<PATH_PROJECT>
	export SIF=<PATH_SINGULARITY_IMAGES>
	export GMXRUN=<PATH_RUN_SRCIPT>
	cd $PROJ
	singularity exec -B $PROJ $SIF bash $GMXRUN
	---------------------------------------------------------------------------------
	```
	4. submit Job

