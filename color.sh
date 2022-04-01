#!/usr/bin/env bash

source ./functions/functions.sh


# INIT PICK PALLET
while true
do  
    
    HEX=$(yad --color)
    if [[ "$?" -eq 0 ]]
    then
        validate_state $HEX
    else 
        break
    fi
done

