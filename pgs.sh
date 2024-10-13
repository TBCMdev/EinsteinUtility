#!/usr/bin/bash
set -e
pw_file=$HOME/.einstein-passwd-v2.txt
secret="Eey6ahchDoho5yu5"

decrypt_pass ()
{
    password=$(openssl enc -d -pbkdf2 -aes256 -base64 -pass pass:$secret -in $pw_file)
}


username=$(whoami)
password=""
decrypt_pass

EINSTEIN_URL="https://$1.computing.dcu.ie/einstein/stats/uploads?user=$username"

if [ password == "" ]
then
   password=$(read -sp "Enter your dcu password: ")
fi

curl $EINSTEIN_URL --location --header "x-ssh_client: $ssh_client" --silent --config - $argv <<< "user = \"$username:$password\"" -o graph-data-temp.txt
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
bar="${bar}\e[0m ]"
echo
echo -e $bar
echo
echo -e "You have completed \e[1;32m$percentage%\e[0m of tasks."
# rm graph-data-temp.txt
