#!/usr/bin/bash
set -e

username=$(whoami)
password=$(peget -r)

if [ password == "" ]
then
   password=$(read -sp "Enter your dcu password: ")
fi
eget $1 "stats/uploads?user=$username" graph-data-temp.txt
c=0
i=0
for _fn in `cat graph-data-temp.txt`; do
    if [ $_fn == "" ];
    then
        continue
    fi
    c=$((c+1))
    if [[ $_fn != *".incorrect"* ]];
    then
        continue
    fi
    taskname=${_fn/"$1/$username/"/""}
    taskname=${taskname/.incorrect/""}
    echo -e "\e[1;31mYou have not completed $taskname.\e[0m"
    i=$((i+1))
done
percentage=$(awk -v c="$c" -v i="$i" "BEGIN{print((($c-$i)/c)*100)}")
c=0
bar="[\e[1;32m"
percentage_t=$( printf "%.0f" $percentage )
while [ $c -lt 100 ];
do
    if [ $c -lt $percentage_t ];
    then
        bar="${bar}■"
    else
        bar="${bar}  "
    fi
    c=$((c+2))
done
bar="${bar}\e[0m]"
echo
echo -e $bar
echo
echo -e "You have completed $C_GREEN$percentage%$C_RESET of tasks."
rm graph-data-temp.txt
