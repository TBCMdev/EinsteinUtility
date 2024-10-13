#!/usr/bin/bash

peget ()
{
    pw_file=$HOME/.einstein-passwd-v2.txt
    secret="Eey6ahchDoho5yu5"
    password=$(openssl enc -d -pbkdf2 -aes256 -base64 -pass pass:$secret -in $pw_file)
    touch einstein-password.txt
    if [ $1 == "-r" ];
    then
        echo $password
    else
        echo $password >> einstein-password.txt
        echo "Saved to ./einstein-password.txt"
    fi
    unset password
}
eget ()
{
    username=$(whoami)
    password=$(peget -r)
    curl "https://$1.computing.dcu.ie/einstein/$2" --location --header "x-ssh_client: $ssh_client" --silent --config - $argv <<< "user = \"$username:$password\"" -o $3
}
export ESECRET="Eey6ahchDoho5yu5"
export -f peget
export -f eget
echo "(EUTILS) - EUtils Loaded."
