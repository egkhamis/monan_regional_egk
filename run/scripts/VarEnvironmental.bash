#!/bin/bash -x

function VarEnvironmental() {
    local  mensage=$1
    echo   ${mensage}
    export ESMF_COMPILER=gnu
    export USER_COMPILER=$ESMF_COMPILER #${USER_COMPILER}
    export DIR_HOME=`cd ..;pwd`
    export SUBMIT_HOME=`cd ..;pwd`
    export SUBMIT_HOME=/mnt/beegfs/eduardo.khamis/issues/714/monan_oper/monan
    export DIRMONAN_PRE_SCR=${SUBMIT_HOME}   # will override scripts at MONAN
    export DIRMONAN_MODEL_SCR=${DIR_HOME}    # will override scripts at MONAN
    #export DIRDADOS=/mnt/beegfs/monan/dados/MONAN_v0.1.0 
    export DIRDADOS=/mnt/beegfs/monan/dados/MONAN_v0.5.0 
    #export path_mets=/opt/ohpc/pub/libs/gnu9/metis/5.1.0/bin
    #export path_mets=/mnt/beegfs/paulo.kubota/monan_project/metis-5.1.0/build/Linux-x86_64/programs
    export path_mets=/mnt/beegfs/eduardo.khamis/issues/714/metis-5.1.0/build/Linux-x86_64/programs
    #export NCARG_ROOT=/home/paulo_kubota/anaconda3/envs/ncl_stable
    export NCARG_ROOT=/usr/local/ncarg
    export NCARG_BIN=${NCARG_ROOT}/bin

    export NCAR_Tools=${SUBMIT_HOME}/pre/sources/${USER_COMPILER}/MPAS-Tools
    export NCAR_MPAS=${NCAR_Tools}/MPAS-Limited-Area
    export version_pos=convert_mpas_v0.1.0_egeon.${USER_COMPILER}940
    export version_model=MONAN-Model_v2.0.0_egeon.${USER_COMPILER}940
    export SLURM='YES'
    export GREEN='\033[1;32m'  # Green
    export RED='\033[1;31m'    # Red
    export NC='\033[0m'        # No Color
}
