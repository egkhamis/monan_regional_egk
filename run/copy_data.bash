#!/bin/bash -x
path_prefix_in="/mnt/beegfs/monan/714/monan_oper/monan"
path_prefix_out=`cd ..;pwd`

# Input variables:-----------------------------------------------------
#EXP=${1};         #EXP=GFS
#RES=${1};         #RES=1024002
YYYYMMDDHHi=${1}; #YYYYMMDDHHi=2024012000
#echo "EXP: ${EXP}"
#echo "RES: ${RES}"
echo "LABELI: ${YYYYMMDDHHi}"
#----------------------------------------------------------------------

# Define a function with local variables

copy_mesh_quasi_uniform() {
  local path_in=${1}/pre/databcs/meshes/quasi_uniform/global/015_km
  local path_out=${2}/pre/databcs/meshes/quasi_uniform/global/015_km

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

  local path_in=${1}/pre/databcs/meshes/quasi_uniform/global/024_km
  local path_out=${2}/pre/databcs/meshes/quasi_uniform/global/024_km

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

}

# Define a function with local variables

copy_mesh_variable_resolution() {
  local path_in=${1}/pre/databcs/meshes/variable_resolution/global/060_015km
  local path_out=${2}/pre/databcs/meshes/variable_resolution/global/060_015km

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

  local path_in=${1}/pre/databcs/meshes/variable_resolution/global/092_025km
  local path_out=${2}/pre/databcs/meshes/variable_resolution/global/092_025km

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

}

# Define a function with local variables

copy_mesh_WPS_GEOG() {
  local path_in=${1}/pre/databcs/WPS_GEOG
  local path_out=${2}/pre/databcs/WPS_GEOG

  echo "cp -urfp: ${path_in} ${path_in}"
  
  mkdir -p ${path_out}/
  cd ${path_out}/
  ln -s ${path_in}/* .
}


# Define a function with local variables

copy_mesh_datain_gfs() {
  local path_in§=${1}/pre/datain/regional/gfs/
  local path_out=${2}/pre/datain/regional/gfs/

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

  local path_in=${1}/pre/datain/global/gfs/
  local path_out=${2}/pre/datain/global/gfs/

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

}

# Define a function with local variables

copy_mesh_datain_era5() {
  local path_in=${1}/pre/datain/regional/era5/
  local path_out=${2}/pre/datain/regional/era5/

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/

  local path_in=${1}/pre/datain/global/era5/
  local path_out=${2}/pre/datain/global/era5/

  cp -urfp ${path_in}/* ${path_out}/

}

# Define a function with local variables

copy_mesh_exec() {
  local path_in=${1}/pre/exec
  local path_out=${2}/pre/exec

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/
}

# Define a function with local variables

copy_mesh_tables() {
  local path_in=${1}/pre/tables/
  local path_out=${2}/pre/tables/

  echo "cp -urfp: ${path_in} ${path_in}"
  
  cp -urfp ${path_in}/* ${path_out}/
}

# Define a function with local variables

copy_datain_gfs() {

  local path_in=${1}/pre/datain/regional/gfs/
  local path_out=${2}/pre/datain/regional/gfs/
  local data=${3}

  mkdir -p ${path_in}/${data}

#  echo "cp -urfp: ${path_in} ${path_in}"
#  
#  cp -urfp ${path_in}/* ${path_out}/
#
#  local path_in=${1}/pre/datain/global/gfs/
#  local path_out=${2}/pre/datain/global/gfs/
#
#  echo "cp -urfp: ${path_in} ${path_in}"
#  
#  cp -urfp ${path_in}/* ${path_out}/
#
#
#  mkdir -p pre/datain/regional/gfs/2025071500
#
#  cd pre/datain/regional/gfs/2025071500
#
#  for i in $(seq -w 000 3 048); do cp /oper/dados/ioper/tempo/GFS/0p25/brutos/2025/07/15/00/gfs.t00z.pgrb2.0p25.f${i}.* . ; done
#
#  cp /mnt/beegfs/monan/CIs/GFS/2025/2025071500/GFS:2025-07-15_00 .

}

# (if) se nao ha flag nenhuma
copy_mesh_quasi_uniform       ${path_prefix_in}  ${path_prefix_out}
copy_mesh_variable_resolution ${path_prefix_in}  ${path_prefix_out}
copy_mesh_WPS_GEOG            ${path_prefix_in}  ${path_prefix_out}
copy_mesh_datain_gfs          ${path_prefix_in}  ${path_prefix_out}
#copy_mesh_datain_era5         ${path_prefix_in}  ${path_prefix_out}
copy_mesh_exec                ${path_prefix_in}  ${path_prefix_out}
copy_mesh_tables              ${path_prefix_in}  ${path_prefix_out}

# (if) se tem flag da data
#copy_datain_gfs               ${path_prefix_in}  ${path_prefix_out} ${YYYYMMDDHHi}


