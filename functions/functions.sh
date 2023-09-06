#!/usr/bin/env bash

#HOST=$(magic-home discovery_json | sed '1,2d'| sed '8d' | jq -r '.[].host')
HOST="10.0.1.119"

hex2rgb() {
    hex=$(echo "${1^^}" | sed 's/#//g')
    
    a=$(echo $hex | cut -c-2)
    b=$(echo $hex | cut -c3-4)
    c=$(echo $hex | cut -c5-6)
    
    r=$(echo "ibase=16; $a" | bc)
    g=$(echo "ibase=16; $b" | bc)
    b=$(echo "ibase=16; $c" | bc)
    
    echo $r $g $b
}


on_led(){
    magic-home on $HOST
}

validate_color(){
    local color=$(echo $2 |jq -r '.color| "\(.red) \(.green) \(.blue)"')
    if [[ "$color" == "$1" ]]
    then
        exit
    fi
}

validate_state(){
    local status=$(magic-home query $HOST  | jq .on)
    
    if [[ "$status" == "true" ]]
    then
        local color=$(hex2rgb $1)
        validate_color "$color" "$STATE"
        magic-home setcolor $HOST $color
    else
        on_led;
    fi
}
