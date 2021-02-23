#!/bin/bash

in=$1
run=run.sh

cat $in |
while read line; do
    ip=$(echo $line | awk '{print $2}')
    ports=$(echo $line | grep -oP '\d{1,5}/open' | cut -d\/ -f1 | tr '\n' ','|sed 's/\(.*\),/\1 /')
    #echo "$ip $ports"
    if [[ ""$ports"" != "" ]]; then
        #echo "nmap -n -v -sV -sC --script vuln -p $ports $ip -oN nmap-targeted-$ip.txt" | tee -a $run
        echo "nmap -vv --stats-every 3m -sS -A --version-all -Pn -p$ports $ip -oA nmap-targeted-$ip" | tee -a $run
    fi
done
