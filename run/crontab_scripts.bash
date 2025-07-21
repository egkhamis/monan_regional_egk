#######! /bin/bash +x
#[Minute] [Hour] [Day_of_the_Month] [Month_of_the_Year] [Day_of_the_Week] [path/scritps_command]
#
# *  *  *   *   *   /path/to/scripts.sh
# |  |  |   |   |       |
# |  |  |   |   |       |__Command/Scripts to execute
# |  |  |   |   |
# |  |  |   |   |__________Day of Week (0-7) 0,7  are Sunday
# |  |  |   |
# |  |  |   |______________Month of Year (1-12)
# |  |  |
# |  |  |__________________Day of Month (1-31)
# |  |
# |  |_____________________Hours (0-23)
# |
# |________________________Minute (0-59)
#
#
#38  15  *   *  *   /lustre_xc50/paulo_kubota/BAM_V2.2.1/run/get_icn_00h_SLAGR_TQ0666L64.bash >&  /lustre_xc50/paulo_kubota/BAM_V2.2.1/run/get_icn_00h_SLAGR_TQ0666L64.out&
 37  18  *   *  *   /home/paulo.kubota/monan_oper/monan/run/run_forcating.bash >& /home/paulo.kubota/monan_oper/monan/run/run_forcating.out &

