#!/usr/bin/bash

PY_SHEBANG="#!/usr/bin/env python3"


pw_file=$HOME/.einstein-passwd-v2.txt
secret="Eey6ahchDoho5yu5"

decrypt_pass ()
{
    password=$(openssl enc -d -pbkdf2 -aes256 -base64 -pass pass:$secret -in $pw_file)
}


EINSTEIN_URL="https://$1.computing.dcu.ie/einstein/get-task-list"

username=$(whoami)
password=""

decrypt_pass
if [ password == "" ]
then
   password=$(read -sp "Enter your dcu password: ")
fi

curl $EINSTEIN_URL --location --header "x-ssh_client: $ssh_client" --silent --config - $argv <<< "user = \"$username:$password\"" -o task-list-temp.txt

if [ ! -d "$HOME/$1" ]; then
    mkdir "$HOME/$1"
fi
if [ ! -d "$HOME/$1/labsheet_$2" ]; then
    mkdir "$HOME/$1/labsheet_$2"
fi

echo "searching for labsheets with name:" $2
for _fn in `cat task-list-temp.txt`; do
    if [[ $_fn != *"$2"* ]];
    then
        continue
    fi
    _fn=${_fn/.html#_/"/"}
    task=$(echo $_fn| cut -d'-' -f 2)
    task=${task//_/-}
    taskpath="$HOME/$1/labsheet_$task.py"
    if ! test -f "$HOME/$1/labsheet_$task.py"; then
        echo "Creating task labsheet_"$task"..."
        touch $taskpath
        echo $PY_SHEBANG >> $taskpath
    fi
done

rm task-list-temp.txt
