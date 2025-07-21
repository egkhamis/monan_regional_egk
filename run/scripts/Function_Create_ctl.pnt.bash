#!/bin/bash -x
function Function_Create_ctl.pnt() {
#-----------------------------------------------------------------------------#
#                                   DIMNT/INPE                                #
#-----------------------------------------------------------------------------#
#BOP
#
# !SCRIPT: Function_Create_ctl
#
# !DESCRIPTION:
#        Script para rodar o Post-Processing of MONAN
#        Realiza as seguintes tarefas:
#           o Pos-processamento (netcdf para grib2, regrid latlon, crop)
#
# For GFS datasets
#
#        ./Function_Create_ctl.bash  GFS 535554   2024042700  
#           o EXP_NAME   : Forcing: ERA5, CFSR, GFS, etc.
#           o EXP_RES    : mesh npts : 535554 etc
#           o LABELI     : Initial: date 2015030600
#
# !REVISION HISTORY:
# 30 sep 2022 - JPRF
# 12 oct 2022 - GAM Group - MONAN on EGEON DELL cluster
# 23 oct 2022 - GAM Group - MONAN benchmark on EGEON
#
# !REMARKS:
#
#EOP
#-----------------------------------------------------------------------------!
#EOC

function usage(){
   sed -n '/^# !CALLING SEQUENCE:/,/^# !/{p}' ./Function_Create_ctl.bash | head -n -1
}

#
# Verificando argumentos de entrada
#
echo $#

if [ $# -ne 6 ]; then
   usage
   exit 1
fi

echo 'aa'
echo ${1}
EXP_NAME=${1}
EXP_RES=${2}
LABELI=${3} 
Domain=${4} 
AreaRegion=${5}
len_disp=${6}


pathin=${SUBMIT_HOME}/${LABELI}/pos/runs/${EXP_NAME}/postprd
pathmesh=${SUBMIT_HOME}


MON=${LABELI:4:2}
case "`echo ${MON} | gawk '{print $1/1 }'`" in
     1)CMON="Jan" ;;
     2)CMON="Feb" ;;
     3)CMON="Mar" ;;
     4)CMON="Apr" ;;
     5)CMON="May" ;;
     6)CMON="Jun" ;;
     7)CMON="Jul" ;;
     8)CMON="Aug" ;;
     9)CMON="Sep" ;;
    10)CMON="Oct" ;;
    11)CMON="Nov" ;;
    12)CMON="Dec" ;;
esac
echo $CMON

start_date=${LABELI:8:2}:00Z${LABELI:6:2}${CMON}${LABELI:0:4}
if [ ${Domain} = "regional" ]; then
echo "----------------------------"  
echo "       REGIONAL DOMAIN      "  
echo "----------------------------" 
DOM=R 
postname='MONAN_DIAG_'${DOM}'_POS_'${EXP_NAME}'_'${LABELI}'_'${LABELI}'.mm.x'${frac}'.'${EXP_RES}'L55.nc'

ncdump -v longitude ${pathin}/${postname} > ${pathin}/file.tmp0
aa=`cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}' | bc -l`
nn=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -1" | bc -l`
bb=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -2" | bc -l`
tail -n $nn  ${pathin}/file.tmp0 > ${pathin}/file.tmp1
head -n $bb  ${pathin}/file.tmp1 > ${pathin}/file.tmp2
coma=","
blanck=" "
sed 's/,/ /g;s/;/ /g;s/longitude/ /g;s/=/ /g' ${pathin}/file.tmp2 > ${pathin}/longitude.tmp


ncdump -v latitude ${pathin}/${postname} > ${pathin}/file.tmp0
aa=`cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}' | bc -l`
nn=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -1" | bc -l`
bb=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -2" | bc -l`
tail -n $nn  ${pathin}/file.tmp0 > ${pathin}/file.tmp1
head -n $bb  ${pathin}/file.tmp1 > ${pathin}/file.tmp2
coma=","
blanck=" "
sed 's/,/ /g;s/;/ /g;s/latitude/ /g;s/=/ /g' ${pathin}/file.tmp2 > ${pathin}/latitude.tmp
echo $nn $aa
echo $nn $aa

export DIR_MESH=${pathmesh}/pre/databcs/meshes/regional_domain/
clon=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Point: | gawk '{printf "%.5f\n", $3/1}'`
clat=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Point: | gawk '{printf "%.5f\n", $2/1}'`
#
#   1grau -  110000
#   y     - 1000000.
#
Semi_major_axis=`cat ${DIR_MESH}/${AreaRegion}.ellipse.pts | grep Semi-major-axis: | gawk '{printf "%.5f\n", (($2/1)/100000)+2}'`
startlon=`echo ${clon}  ${Semi_major_axis}| gawk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -64.0
endlon=`echo   ${clon}  ${Semi_major_axis}| gawk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -39.0
startlat=`echo ${clat}  ${Semi_major_axis}| gawk '{printf "%.5f\n", $1-(($2/2)+7)} '`   # -40.0
endlat=`echo ${clat}    ${Semi_major_axis}| gawk '{printf "%.5f\n", $1+(($2/2)+7)} '`   # -20.0
nlat=`echo ${startlat}  ${endlat} ${len_disp}| gawk '{printf "%d\n", sqrt(((($2-$1+1)*110000)/$3)^2) } '`    # 700
nlon=`echo ${startlon}  ${endlon} ${len_disp}| gawk '{printf "%d\n", sqrt(((($2-$1+1)*110000)/$3)^2) } '`    #  867
else

echo "----------------------------"  
echo "        GLOBAL DOMAIN       "  
echo "----------------------------"  
DOM=G 
postname='MONAN_DIAG_'${DOM}'_POS_'${EXP_NAME}'_'${LABELI}'_'${LABELI}'.mm.x'${frac}'.'${EXP_RES}'L55.nc'

ncdump -v longitude ${pathin}/${postname} > ${pathin}/file.tmp0
aa=`cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}' | bc -l`
nn=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -1" | bc -l`
bb=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -2" | bc -l`
tail -n $nn  ${pathin}/file.tmp0 > ${pathin}/file.tmp1
head -n $bb  ${pathin}/file.tmp1 > ${pathin}/file.tmp2
coma=","
blanck=" "
sed 's/,/ /g;s/longitude/ /g;s/=/ /g' ${pathin}/file.tmp2 > ${pathin}/longitude.tmp


ncdump -v latitude ${pathin}/${postname} > ${pathin}/file.tmp0
aa=`cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}' | bc -l`
nn=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -1" | bc -l`
bb=`a=$(cat ${pathin}/file.tmp0 | wc -l) && b=$(cat -n ${pathin}/file.tmp0 | grep data: | gawk '{print $1}') && echo "$a - $b -2" | bc -l`
tail -n $nn  ${pathin}/file.tmp0 > ${pathin}/file.tmp1
head -n $bb  ${pathin}/file.tmp1 > ${pathin}/file.tmp2
coma=","
blanck=" "
sed 's/,/ /g;s/latitude/ /g;s/=/ /g' ${pathin}/file.tmp2 > ${pathin}/latitude.tmp
echo $nn $aa
echo $nn $aa
#
#   1grau -  110000
#   y     - 1000000.
#
nlat=`ncdump -c ${postname} | head -n 6| grep latitude | gawk '{print $3}'`
nlon=`ncdump -c ${postname} | head -n 6| grep longitude | gawk '{print $3}'`

fi
cat<<EOF1>${pathin}/file.ctl
DSET ^MONAN_DIAG_${DOM}_POS_${EXP_NAME}_${LABELI}_%y4%m2%d2%h2.mm.x${frac}.${EXP_RES}L55.nc

DTYPE netcdf

Options template

TITLE Ocean Surface Variables

UNDEF 9.96921e+36

*UNPACK scale_factor add_offset

*XDEF ${nlon} levels
XDEF ${nlon} linear    0.0  0.5
*YDEF ${nlat} levels
YDEF  ${nlat} linear  -89.875 0.5

ZDEF 27 levels 1000.0 975.0  950.0  925.0  900.0  875.0  850.0  825.0  800.0
                775.0 750.0  700.0  650.0  600.0  550.0  500.0  450.0  400.0
	        350.0 300.0  250.0  225.0  200.0  175.0  150.0  125.0  100.0
		
tdef  10000 linear ${start_date} 3hr
VARS 34
mslp=>psnm                  0 t,y,x   Mean sea-level pressure [Pa]
t_isobaric=>temp           27 t,z,y,x Temperature interpolated to isobaric surfaces [K]
rh_isobaric=>rhum          27 t,z,y,x Relative humidity interpolated to isobaric surfaces [%]
w_isobaric=>wvel           27 t,z,y,x Vertical wind interpolated to isobaric surfaces [m/s]
ommt_isobaric=>ommt        27 t,z,y,x Vertical wind interpolated to isobaric surfaces [Pa/s]
cape=>cape                  0 t,y,x   Convective available potential energy  [J kg^-1]
lcl=>lcl                    0 t,y,x   Lifted condensation level [m]
lfc=>lfc                    0 t,y,x   Level of free convection  [m]
zgeo_isobaric=>zgeo        27 t,z,y,x Geopotential height interpolated to isobaric surfaces [m]
vvel_isobaric=>vvel        27 t,z,y,x Meridional wind interpolated to isobaric surfaces[m/s]
uvel_isobaric=>uvel        27 t,z,y,x Zonal wind interpolated to isobaric surfaces[m/s]  
qv_isobaric=>umes          27 t,z,y,x Water vapor mixing ratio interpolated to isobaric surfaces [kg/kg]
t2m=>t2m                    0   t,y,x 2-meter temperature  [K]
q2=>q2m                     0   t,y,x 2-meter specific humidity [kg/kg]
v10=>v10m                   0   t,y,x 10-meter meridional wind[m/s]
u10=>u10m                   0   t,y,x 10-meter zonal wind [m/s]
precipw=>agpl               0   t,y,x precipitable water [kg/m²]
aclwupt=>aclwupt            0   t,y,x accumulated all-sky upward top-of-the-atmosphere longwave radiation flux  [W/m²]
aclwupb=>aclwupb            0   t,y,x accumulated all-sky upward surface longwave radiation flux [W/m²]
aclwdnt=>aclwdnt            0   t,y,x accumulated all-sky downward top-of-the-atmosphere longwave radiation flux [W/m²]
aclwdnb=>aclwdnb            0   t,y,x accumulated all-sky downward surface longwave radiation flux[W/m²]
acswupt=>acswupt            0   t,y,x accumulated all-sky upward top-of-atmosphere shortwave radiation flux [W/m²]
acswupb=>acswupb            0   t,y,x accumulated all-sky upward surface shortwave radiation flux[W/m²]
acswdnt=>acswdnt            0   t,y,x accumulated all-sky downward top-of-atmosphere shortwave radiation flux[W/m²]
acswdnb=>acswdnb            0   t,y,x accumulated all-sky downward surface shortwave radiation flux[W/m²]
prec=>prec                  0   t,y,x  total preciptation
prcv=>prcv                  0   t,y,x  convective precipitation
alh=>clsf                   0   t,y,x accumulated latent heat flux at the surface [W m^{-2}]
ahfx=>cssf                  0   t,y,x accumulated upward heat flux at the surface [W m^{-2}]
spmt=>spmt                  0   t,y,x  Time Mean sea-level pressure
t02mt=>t02mt                0   t,y,x Time Mean 2-meter temperature [K]
q02mt=>q02mt                0   t,y,x Time Mean 2-meter specific humidity [kg kg^{-1}]
u10mt=>u10mt                0   t,y,x Time Mean 10-meter zonal wind [m s^{-1}]
v10mt=>v10mt                0   t,y,x Time Mean 10-meter meridional wind[m s^{-1}]
ENDVARS
EOF1

#sed '15 r '${pathin}'/latitude.tmp' ${pathin}/file.ctl > ${pathin}/file.tmp0
#sed '13 r '${pathin}'/longitude.tmp' ${pathin}/file.tmp0 > ${pathin}/template.ctl
cp ${pathin}/file.ctl  ${pathin}/template.ctl
rm -f ${pathin}/file.*
}

