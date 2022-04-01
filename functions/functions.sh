#!/usr/bin/env bash

HOST=$(yarn run magic-home scan --json | sed '1,2d'| sed '8d' | jq -r '.[].host')


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
     yarn run magic-home on $HOST
}

validate_color(){
    local color=$(echo $2 |jq -r '.color| "\(.red) \(.green) \(.blue)"')
    if [[ "$color" == "$1" ]]
    then
        exit
    fi
}

validate_state(){
   STATE=$(yarn run magic-home state $HOST | sed '14d;1d;2d')
   local status=$(echo "$STATE" | jq .on)

    if [[ "$status" == "true" ]]
    then
        local color=$(hex2rgb $1)
        validate_color "$color" "$STATE"
        yarn run magic-home color $HOST $color
    else
        on_led;
    fi
}
