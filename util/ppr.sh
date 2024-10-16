#!/usr/bin/bash

str=$1
i=-1
while [ $i -lt ${#str} ]; do
    i=$((i+1))
    chr="${str:i:1}"

    if [[ "$chr" == "\\"  ]]; then
        chr=${str:$((i+1)):1}
        if [[ $chr == "%" ]]; then
            str="${$str:0:i}${$str:$((i+2))}"
            i=$((i+1))
        fi
    elif [[ "$chr" != "%" ]]; then
        continue
    fi
    ind=$((i+1))
    col=${str:ind:1}
    repl=
    case $col in
        "0")
            repl=$C_RESET;;
        "r")
            repl=$C_RED;;
        "g")
            repl=$C_GREEN;;
        "b")
            repl=$C_BLUE;;
        *)
            echo -e "Unknown Sequence $C_RED%$col$C_RESET."
            exit
    esac
    if [ $((i+2)) -eq ${#str} ]; then
        break
    fi

    nchar=${str:$((i+2)):1}

    if [[ "$nchar" != "|" ]]; then
        str="${str:0:$((ind-1))}$repl${str:$((ind+1))}"
        l=${#repl}
        i=$((i+l))
    else
        j=$((i+3))
        b=$j
        len=${#str}
        while [ $j -lt $len ]; do
            chr2=${str:j:1}
            if [[ "$chr2" == "|" ]]; then
                break
            fi
            j=$((j+1))
        done
        if [[ j == $((len-1)) ]];then
            echo "ERROR: Expected closing brace ('|') to pair opening brace at index $b"
            exit
        fi
        # Closing brace found here
        encaplen=$((j-b))
        encap=${str:b:encaplen}
        encap="$repl$encap$C_RESET"
        # remove old encap and add new one
        str2="${str:0:i}$encap${str:$((j+1))}"
        lendiff=$((${#str2}-${#str}))
        str=$str2
        i=$((i+lendiff+$((j-i))))
    fi
done
echo -e $str
