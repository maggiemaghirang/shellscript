#!/bin/bash

### functions ###

### center function ###
center() {
  termwidth="$(tput cols)"
  padding="$(printf '%0.1s' ={1..25})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}
### center function ###

### rounding up float input function ###
round() {
  printf "%.${2}f" "${1}"
}
### rounding up float input  function ###

### functions ###

shopt -s extglob
set -e
shopt -s expand_aliases
#message="******************************JOBS JOBS JOBS JOBS JOBS******************************"
sec=$1 ### first input of user
# remainder=$(( sec / 9 ))
# countdown_message="====================   C O U N T D O W N    =============================="

### infinite checking of queue
while :
do
  clear ; pwd ; ls -X 
  center " JOBS JOBS JOBS JOBS JOBS " ; echo \ ;
  # echo ${message} ; echo \ 
  squeue -u maggie --format "%T     %A     %j     %Z" ; echo \ ;
  #squeue -u maggie ; echo  \ ;
  echo \ ; center " JOBS JOBS JOBS JOBS JOBS " ; sleep 1
  # echo \ ; echo ${message} ; sleep 1
  
  echo \ ; center " = = = = C O U N T D O W N = = = = " ; echo \ ;
  
  for refresh_sec in $(seq ${sec} -1 0)   
  do
    if [[ -z "${sec}" ]] ### check if input exists and an integer
    then
      center " No argument supplied !!! "
      center "Auto-supply 20 seconds to refresh squeue" ; echo \ ;
      for refresh_sec in $(seq 20 -1 0) 
        do
          if [[ ${refresh_sec} -ge 4 ]] && ! (( ${refresh_sec} % 9 == 0 )) ### if >= 4 and not divisible by 9
          then
            center "squeue will refresh in ${refresh_sec} second/s" ; sleep 1 ; echo \ ;
          elif [[ ${refresh_sec} -ge 4 ]] && (( ${refresh_sec} % 9 == 0 )) ### if >=4 and divisble by 9
          then
            center " bored? have a cup of coffee then " ; sleep 1 ; echo \ ; 
          else ### last 3 seconds
            center " = = = = refreshing in ${refresh_sec} = = = = " ; sleep 1 ; echo \ ;
          fi
        done
    break 1
    
    elif [[ -z "${sec}" ]] && ! [[ "$sec" =~ ^-?[0-9]+$ ]] ### check if input exisit and is not an integer 
    then
      exec >&2 ; echo "error: Not a number. TERMINATING!" ; exit 1 ### will terminate
        
    elif [[ ${refresh_sec} -ge 4 ]] && ! (( ${refresh_sec} % 9 == 0 )) 
    then
      center "squeue will refresh in ${refresh_sec} second/s" ; sleep 1 ; echo \ ;
    elif [[ ${refresh_sec} -ge 4 ]] && (( ${refresh_sec} % 9 == 0 ))
    then
      center " bored? have a cup of coffee then " ; sleep 1 ; echo \ ;
    else ### last 3 seconds 
      center " = = = = refreshing in ${refresh_sec} = = = = " ; sleep 1 ; echo \ ;
    fi
    #cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 9 ; sleep 5
  done
done
