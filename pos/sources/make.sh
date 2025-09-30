#!/bin/bash
#Usage: make target CORE=[core] [options]
#Example targets:
#    ifort
#    gfortran
#    xlf
#    pgi
#Availabe Cores:
#    atmosphere
#    init_atmosphere
#    landice
#    ocean
#    seaice
#    sw
#    test
#Available Options:
#    DEBUG=true    - builds debug version. Default is optimized version.
#    USE_PAPI=true - builds version using PAPI for timers. Default is off.
#    TAU=true      - builds version using TAU hooks for profiling. Default is off.
#    AUTOCLEAN=true    - forces a clean of infrastructure prior to build new core.
#    GEN_F90=true  - Generates intermediate .f90 files through CPP, and builds with them.
#    TIMER_LIB=opt - Selects the timer library interface to be used for profiling the model. Options are:
#                    TIMER_LIB=native - Uses native built-in timers in MPAS
#                    TIMER_LIB=gptl - Uses gptl for the timer interface instead of the native interface
#                    TIMER_LIB=tau - Uses TAU for the timer interface instead of the native interface
#    OPENMP=true   - builds and links with OpenMP flags. Default is to not use OpenMP.
#    OPENACC=true  - builds and links with OpenACC flags. Default is to not use OpenACC.
#    USE_PIO2=true - links with the PIO 2 library. Default is to use the PIO 1.x library.
#    PRECISION=single - builds with default single-precision real kind. Default is to use double-precision.
#    SHAREDLIB=true - generate position-independent code suitable for use in a shared library. Default is false.

source load_module_convert_mpas.bash
source ../../../run/scripts/VarEnvironmental.bash

VarEnvironmental

export DIRroot=`cd ../../;pwd`

export CONVERT_MPAS_DIR=${DIRroot}/sources/${version_pos}
export MONAN_EXEC_DIR=${DIRroot}/exec/${version_pos}
cd ${CONVERT_MPAS_DIR}
echo ""
echo -e  "${GREEN}==>${NC} Installing convert_mpas...\n"
make clean
make  2>&1 | tee make.convert.output

mkdir -p ${MONAN_EXEC_DIR}/exec/

cp -f ${CONVERT_MPAS_DIR}/convert_mpas ${MONAN_EXEC_DIR}/exec/

cd ${DIRroot}

if [ -s "${MONAN_EXEC_DIR}/exec/convert_mpas" ] ; then
    echo ""
    echo -e "${GREEN}==>${NC} File convert_mpas generated Sucessfully in ${CONVERT_MPAS_DIR} and copied to ${MONAN_EXEC_DIR}/exec !"
    echo
else
    echo -e "${RED}==>${NC} !!! An error occurred during convert_mpas build. Check output"
    exit -1
fi

echo -e  "${GREEN}==>${NC} Script ${0} completed. \n"

