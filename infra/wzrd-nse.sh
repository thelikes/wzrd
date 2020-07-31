#!/bin/bash

# script by deep-ping & CuCHulaind
# This script is designed to use all nmap scripts for a given user supplied service
# on a user given host, with user supplied ports

GREEN="\033[32m"
RED="\033[31m"
NORMAL="\033[0;39m"

if [ $# -ne 3 ]; then
    echo "usage:"
    echo "run-nse.sh <ip> <port> <key>"
    echo "run-nse.sh 10.11.1.223 135,139,445 smb"
    exit 1
fi

targ=$1
port=$2
key=$3

echo TARG=$targ
echo PORT=$port
echo KEY=$key

ls /usr/share/nmap/scripts/ | grep $key |
while read line
do 
    desc=$(nmap --script-help $line | head -n 10)
    printf $GREEN
    echo "$desc"
    printf $RED
    read -p "Scan with $line? " -n 1 -r </dev/tty
    echo
    printf $NORMAL
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        nmap -v -Pn -p $port $targ --script $line -oN nse-$line-$targ.txt
    fi
done
