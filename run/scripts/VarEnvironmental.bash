#!/bin/bash -x

function VarEnvironmental() {
    local  mensage=$1
    echo   ${mensage}
    export ESMF_COMPILER=gnu
    export USER_COMPILER=$ESMF_COMPILER #${USER_COMPILER}
    export DIR_HOME=`cd ..;pwd`
    export SUBMIT_HOME=`cd ..;pwd`
    export DIRMONAN_PRE_SCR=${SUBMIT_HOME}   # will override scripts at MONAN
    export DIRMONAN_MODEL_SCR=${DIR_HOME}    # will override scripts at MONAN
    export DIRDADOS=/mnt/beegfs/monan/dados/MONAN_v1.4.x 
    export path_mets=/mnt/beegfs/monan/7dados/MONAN-Regional_v1.4.x/metis-5.1.0/build/Linux-x86_64/programs
    export NCARG_ROOT=/usr/local/ncarg
    export NCARG_BIN=${NCARG_ROOT}/bin
    export NCAR_Tools=${SUBMIT_HOME}/pre/sources/MPAS-Tools
    export NCAR_MPAS=${NCAR_Tools}/MPAS-Limited-Area
    export version_pos=convert_mpas_v1.2.0_egeon.${USER_COMPILER}940
    export version_model=MONAN-Model_v1.4.2-rc_egeon.${USER_COMPILER}940
    export SLURM='YES'
    export GREEN='\033[1;32m'  # Green
    export RED='\033[1;31m'    # Red
    export NC='\033[0m'        # No Color
}
