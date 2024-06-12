#!/bin/bash
# ANICETO B. MAGHIRANG III
# December 17, 2022
# Automate A2MX2 rel sub

today=`date +%d-%m-%Y`

# A2MX2 combinations
read -p "A atom: " A_atom
M_atom="Zn"
X_atom=(P As)

COUNTER=0
compound="A2MX2"

echo $(date) >${today}_log.log
echo "Submission log for ${compound} compounds" >>${today}_log.log

# ${#array[@]} is the number of elements in the array , use this for index manipulation
#for (( i=0; i<${#tri[@]}; i++ )) ; do
#  for (( j=0; j<${#tri[@]}; j++ )) ; do

len=${#X_atom[@]}
for (( idx = 0; idx < len; idx++ )); do
 # echo "${tri1[idx]}${tri2[idx]}"
  if [[ ! -d ${A_atom}2${M_atom}${X_atom[idx]}2 ]]; then
    mkdir -p ${A_atom}2${M_atom}${X_atom[idx]}2
    echo "done creating ${A_atom}2${M_atom}${X_atom[idx]}2"
    cd ${A_atom}2${M_atom}${X_atom[idx]}2
    cp -r $HOME/sub/a2mx2-files/{0-Relax,BAND} .
    cd 0-Relax/
      
cat >POSCAR <<!
Mono ${A_atom}2${M_atom}${X_atom[idx]}2
   1.00000000000000
     2.1633685712809552   -3.7470642809563031   -0.0000000000000000
     2.1633685712809534    3.7470642809563026   -0.0000000000000000
     0.0000000000000000    0.0000000000000000    8.2998858842200907
   ${A_atom}    ${M_atom}   ${X_atom[idx]}
     2     1     2
Direct
  0.0000000000000000 -0.0000000000000000  0.7094921075908200
  0.0000000000000000 -0.0000000000000000  0.2905078924091791
  0.6666666666666643  0.3333333333333357  0.0000000000000000
  0.6666666666666643  0.3333333333333357  0.5000000000000000
  0.3333333333333357  0.6666666666666643  0.0000000000000000
!
  if [[ ${A_atom} == Co ]] || [[ ${A_atom} == Co ]] ; then
    SetPOT.py -i -o POTCAR
  else
    SetPOT.py PAW PBE -o POTCAR
  fi
      
    sbatch *.sh ; echo "DONE ${A_atom}2${M_atom}${X_atom[idx]}2" ; cd ../../
    #cd ../ ; echo "fake submit" ; echo "DONE $PWD" ; cd ../
    let COUNTER++ ; echo "Submission # ${COUNTER}: ${A_atom}2${M_atom}${X_atom[idx]}2" >>${today}_log.log
    
  elif [[ -d ${A_atom}2${M_atom}${X_atom[idx]}2 ]]; then
    echo "${A_atom}2${M_atom}${X_atom[idx]}2 already exists" 1>&2
  fi
done
    
echo $(date) >${today}_total_no_sub.log
echo "The submissions made are for ${compound}" >>${today}_total_no_sub.log
echo "Total number of submissions for ${compound} is: ${COUNTER}" >>${today}_total_no_sub.log