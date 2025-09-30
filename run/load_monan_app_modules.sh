# Load Modules

module purge
module load ohpc
module load phdf5
module load netcdf 
module load netcdf-fortran 
module load cdo-2.0.4-gcc-9.4.0-bjulvnd
module load opengrads/2.2.1
module load nco-5.0.1-gcc-11.2.0-u37c3hb
module load python-3.9.13-gcc-9.4.0-moxjnc6
module load metis
module list

export OMP_NUM_THREADS=1
export OMPI_MCA_btl_openib_allow_ib=1
export OMPI_MCA_btl_openib_if_include="mlx5_0:1"
export PMIX_MCA_gds=hash
export MPI_PARAMS="-iface ib0 -bind-to core -map-by core"

export NETCDF=/mnt/beegfs/monan/libs_openmpi/netcdf
export PNETCDF=/mnt/beegfs/monan/libs_openmpi/PnetCDF
export PIO=

export MKL_NUM_THREADS=1
export I_MPI_DEBUG=5
export MKL_DEBUG_CPU_TYPE=5
export I_MPI_ADJUST_BCAST=12 ## NUMA aware SHM-Based (AVX512)
