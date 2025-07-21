#! /bin/bash
#help#
#************************************************************************************#
#                                                                                    #
# script to run CPTEC OPERATION                                                      #
# runPost LABELI                                                                     #
#                                                                                    #
# example :                                                                          #
# runPost  LABELI                                                                    #
#                                                                                    #
#                                                                                    #
#                 LABELI    => initial data YYYYMMDDHH                               #
#                                                                                    #
#************************************************************************************#
#help#
if [ "${1}" = "help" -o -z "${1}" ]
then
  cat < ${0} | sed -n '/^#help#/,/^#help#/p'
  exit 1
else
export LABELI=$1
fi

        #/mnt/beegfs/paulo.kubota/monan_oper/monan/2025022600/pos/runs/GFS/postprd
path_in='/mnt/beegfs/paulo.kubota/monan_oper/monan/'${LABELI}'/pos/runs/GFS/postprd/'
path_out='/pesq/dados/bam/paulo.kubota/monan/MPAS_Model_Global/pos/runs/GFS/'
path_bkp=${path_out}/${LABELI}

mkdir -p ${path_bkp}
cp -u ${path_in}/*.ctl ${path_bkp}/
cp -u ${path_in}/*.nc  ${path_bkp}/

ls ${path_out}
