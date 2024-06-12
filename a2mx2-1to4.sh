#!/bin/bash
# ANICETO B. MAGHIRANG III
# December 17, 2022
# Automate A2MX2 1-Sc to 4-SocBand

shopt -s extglob
set -e

# A2MX2 combinations
read -p "A atom: " A_atom
M_atom="Zn"
X_atom=(P As)

COUNTER=0
compound="A2MX2"

PS3="You entered band structure calculation procedures. Please enter your option: "

select option in sc bs sb zm zb plt quit
do
  case $option in
    sc) len=${#X_atom[@]}
      for (( idx = 0; idx < len; idx++ )); do
       # echo "${tri1[idx]}${tri2[idx]}"
        cd ${A_atom}2${M_atom}${X_atom[idx]}2
        VASPRun.py relax2sc
        cd 1-Sc ; rm *sh ; cp $HOME/sub/vasp.sc.sh .
        cp $HOME/sub/a2mx2-files/1-Sc/{INCAR,KPOINTS} .
        sbatch *.sh ; echo "DONE 1-Sc ${A_atom}2${M_atom}${X_atom[idx]}2" ; cd ../../
      done
    ;;
    bs) len=${#X_atom[@]}
      for (( idx = 0; idx < len; idx++ )); do
       # echo "${tri1[idx]}${tri2[idx]}"
        cd ${A_atom}2${M_atom}${X_atom[idx]}2
        VASPRun.py band ; VASPRun.py soc
        cd 2-Band ; sbatch *.sh ; echo "DONE 2-Band ${A_atom}2${M_atom}${X_atom[idx]}2" ; cd ../ 
        cd 3-Soc ; rm *.sh ; cp $HOME/sub/vasp.soc.sh .
        sbatch *.sh ; echo "DONE 3-Soc ${A_atom}2${M_atom}${X_atom[idx]}2" ; cd ../../ 
      done
    ;;
    sb) len=${#X_atom[@]}
      for (( idx = 0; idx < len; idx++ )); do
       # echo "${tri1[idx]}${tri2[idx]}"
        cd ${A_atom}2${M_atom}${X_atom[idx]}2
        VASPRun.py socband
        cd 4-SocBand
        sbatch *.sh ; echo "DONE 4-SocBand ${A_atom}2${M_atom}${X_atom[idx]}2" ; cd ../../
      done
    ;;
    zm) len=${#X_atom[@]}
      for (( idx = 0; idx < len; idx++ )); do
       # echo "${tri1[idx]}${tri2[idx]}"
        cd ${A_atom}2${M_atom}${X_atom[idx]}2
        VASPRun.py Z2Pack --nproc=16
        cd 7-Z2Pack
        cp $HOME/sub/z2-mono/vasp.z2.sh .
        sbatch *.sh ; echo "DONE 7-Z2Pack ${A_atom}2${M_atom}${X_atom[idx]}2" ; cd ../../
      done
    ;;
    zb) len=${#X_atom[@]}
      for (( idx = 0; idx < len; idx++ )); do
       # echo "${tri1[idx]}${tri2[idx]}"
        cd ${A_atom}2${M_atom}${X_atom[idx]}2
        VASPRun.py Z2Pack --nproc=16 -o 7-Z2Pack-x0 ; cd 7-Z2Pack-x0 ; cp $HOME/sub/z2-bulk/x0.sh . ; sbatch *.sh ; echo "DONE 7-Z2Pack ${A_atom}2${M_atom}${X_atom[idx]}2 x0" ; cd .. 
        VASPRun.py Z2Pack --nproc=16 -o 7-Z2Pack-y0 ; cd 7-Z2Pack-y0 ; cp $HOME/sub/z2-bulk/y0.sh . ; sbatch *.sh ; echo "DONE 7-Z2Pack ${A_atom}2${M_atom}${X_atom[idx]}2 y0" ; cd ..
        VASPRun.py Z2Pack --nproc=16 -o 7-Z2Pack-z0 ; cd 7-Z2Pack-z0 ; cp $HOME/sub/z2-bulk/z0.sh . ; sbatch *.sh ; echo "DONE 7-Z2Pack ${A_atom}2${M_atom}${X_atom[idx]}2 z0" ; cd .. 
        VASPRun.py Z2Pack --nproc=16 -o 7-Z2Pack-z1 ; cd 7-Z2Pack-z1 ; cp $HOME/sub/z2-bulk/z1.sh . ; sbatch *.sh ; echo "DONE 7-Z2Pack ${A_atom}2${M_atom}${X_atom[idx]}2 z1" ; cd .. 
        cd ../
      done
    ;;
    plt)  len=${#X_atom[@]}
      for (( idx = 0; idx < len; idx++ )); do
        cd ${A_atom}2${M_atom}${X_atom[idx]}2 ; echo "Entered ${A_atom}2${M_atom}${X_atom[idx]}2"
        BandGap.py --band 2-Band
        BandGap.py --band 4-SocBand

        read -p "Enter values: " val con val_soc con_soc
        #read -r -p "Please enter kpath separated by space: " -a kpath
        
        Band.py --sc 1-Sc --band 2-Band \
                --range=-2.0:2.0 --tick 1.0 --minor-tick 4 \
                --charsize-axis 2.5 --high-resolution \
                --color band[:1,${val}]=red band[:1,${con}]=blue \
                -o mono-sc ; echo "Plotting SC ${A_atom}2${M_atom}${X_atom[idx]}2" \
        
        Band.py --sc 3-Soc --band 4-SocBand \
                --range=-2.0:2.0 --tick 1.0 --minor-tick 4 \
                --charsize-axis 2.5 --high-resolution \
                --color band[:,${val_soc}]=red band[:,${con_soc}]=blue \
                -o mono-soc ; echo "Plotting SOC ${A_atom}2${M_atom}${X_atom[idx]}2"
        cd ../
      done
    ;;
    quit) echo "You chose to $option! Bye bye!" ; break ;;
      *) echo "ERROR: Invalid selection, $REPLY." ;;
  esac
done
