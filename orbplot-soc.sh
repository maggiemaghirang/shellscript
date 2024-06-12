#!/bin/bash

# Aniceto B. Maghirang III
# April 25, 2021
# ORBITAL CONTRIBUTION PLOTTING (s p d tot)

shopt -s extglob
set -e

PS3="You entered orbital contribution plotting. Please enter your option: "

select option in s p d tot quit
do
    case $option in
        s) for orb in s
           do
               echo "Enter element symbol and position: " ; read -r elsym pos 
               read -r -p "Please enter kpath separated by space: " -a kpath
               kpname=`printf "%s" "${kpath[@]}" && echo ""`
               Band.py --sc 3-Soc --band  4-SocBand     \
                       --range=-4.0:4.0 --tick=1.0        \
                       --label-sel ${kpath[@]}               \
                       --charsize-axis 1.5                \
                       --high-resolution                  \
                       --ratio 1.5                        \
                       -p [${pos},${orb}]                 \
                       --color band=gray percent[1]=green \
                       -o ${elsym}-${orb}-nm-soc-${kpname} ; echo "Plotting ${orb} orbital in ${kpath[@]} . . ."
           done ; echo "DONE!"
        ;;
        p) echo "Enter element symbol and position: " ; read -r elsym pos
           read -r -p "Please enter kpath separated by space: " -a kpath
           kpname=`printf "%s" "${kpath[@]}" && echo ""`
           for orb in px py pz
           do
               Band.py --sc 3-Soc --band  4-SocBand   \
                       --range=-4.0:4.0 --tick=1.0      \
                       --label-sel ${kpath[@]}          \
                       --charsize-axis 1.5              \
                       --high-resolution                \
                       --ratio 1.5                      \
                       -p [${pos},${orb}]               \
                       --color band=gray percent[1]=red \
                       -o ${elsym}-${orb}-nm-soc-${kpname} ; echo "Plotting ${orb} orbital in ${kpath[@]} . . ."
           done ; echo "DONE!"
        ;;
        d) echo "Enter element symbol and position: " ; read -r elsym pos
           read -r -p "Please enter kpath separated by space: " -a kpath
           kpname=`printf "%s" "${kpath[@]}" && echo ""`
           for orb in dxy dyz dz2 dxz 'x2-y2'
           do
               Band.py --sc 3-Soc --band  4-SocBand    \
                       --range=-4.0:4.0 --tick=1.0       \
                       --label-sel ${kpath[@]}           \
                       --charsize-axis 1.5               \
                       --high-resolution                 \
                       --ratio 1.5                       \
                       -p [${pos},${orb}]                \
                       --color band=gray percent[1]=blue \
                       -o ${elsym}-${orb}-nm-soc-${kpname} ; echo "Plotting ${orb} orbital in ${kpath[@]} . . ."
           done ; echo "DONE!"
        ;;
        tot) echo "Enter elemement symbol or compound and position: " ; read -r elsym pos
             read -r -p "Please enter kpath separated by space: " -a kpath
             kpname=`printf "%s" "${kpath[@]}" && echo ""`
             for orb in tot
             do
                 Band.py --sc 3-Soc --band  4-SocBand \
                         --range=-4.0:4.0 --tick=1.0    \
                         --label-sel ${kpath[@]}        \
                         --charsize-axis 1.5            \
                         --high-resolution              \
                         --ratio 0.5                    \
                         -p [${pos},s] [${pos},px]+[${pos},py]+[${pos},pz] [${pos},dxy]+[${pos},dyz]+[${pos},dz2]+[${pos},dxz]+[${pos},x2-y2] \
                         --color band=gray percent[1]=green percent[2]=red percent[3]=blue \
                         -o ${elsym}-${orb}-nm-soc-${kpname} ;  echo "Plotting ${option}al contribution in ${kpath[@]}. . ." 
             done ; echo "DONE!"
        ;;
        quit) echo "You chose to $option! Bye bye!" ; break ;;
        *) echo "ERROR: Invalid selection, $REPLY." ;;
    esac
done
