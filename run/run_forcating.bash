#!/bin/bash 
source /home/paulo.kubota/.bashrc
#LABELI=YYYYMMDDHH 
LABELI=`date +'%Y%m%d'00`
NFDAYS=7


export path_run='/home/paulo.kubota/monan_oper/monan/run'

calday ()
{
yi=`echo ${LABELX} |awk '{ print( substr($1,1,4)/1) }'`
mi=`echo ${LABELX} |awk '{ print( substr($1,5,2)/1) }'`
di=`echo ${LABELX} |awk '{ print( substr($1,7,2)/1) }'`
hi=`echo ${LABELX} |awk '{ print( substr($1,9,2)/1) }'`

let ybi=${yi}%4
if [ ${ybi} = 0 ]
then
declare -a md=( 31 31 29 31 30 31 30 31 31 30 31 30 31 )
else
declare -a md=( 31 31 28 31 30 31 30 31 31 30 31 30 31 )
fi
let df=${di}+${NFDAYS}
let mf=${mi}
let yf=${yi}
let hf=${hi} 
let n=${mi}
echo veja ${df} ' '${md[${n}]}
if [ ${df} -gt ${md[${n}]} ];then
   let df=(${df}-${md[${n}]})
   if [  ${df} -ge 1 ];then
      let mf=${mf}+1
      if [ ${mf} -eq 13 ];then
         let mf=1
         let yf=${yf}+1
      fi
   fi
else
   if [ ${mf} -eq 13 ];then
      let mf=1
      let yf=${yf}+1
   fi
fi

if [ ${df} -lt 10 ];then 
  DF=0${df}
else 
  DF=${df}
fi
if [ ${mf} -lt 10 ];then 
  MF=0${mf}
else 
  MF=${mf}
fi
YF=${yf}
if [ ${hf} -lt 10 ];then 
  HF=0${hf}
else 
  HF=${hf}
fi
}

export LABELX=${LABELI}
calday
LABELF=${YF}${MF}${DF}${HF}
echo ${LABELI} ${LABELF} 


#${path_run}/runPre_oper.bash   GFS   1024002  ${LABELI} ${LABELF}  global    global       quasi_uniform

#${path_run}/runModel_oper.bash GFS   1024002  ${LABELI} ${LABELF}  ${LABELF}  ${LABELF} global global quasi_uniform  COLD pnt

#${path_run}/runPost_oper.bash  GFS   1024002   ${LABELI} ${LABELF} global    global       quasi_uniform pnt

${path_run}/runPre_oper.bash   GFS   1024002  ${LABELI} ${LABELF}  global    global	quasi_uniform

${path_run}/runModel_oper.bash GFS   1024002  ${LABELI} ${LABELF}  ${LABELF}  ${LABELF} global global quasi_uniform  COLD pnt

${path_run}/runPost_oper.bash  GFS   1024002   ${LABELI} ${LABELF} global    global	quasi_uniform pnt

${path_run}/copy.bash   ${LABELI} 
