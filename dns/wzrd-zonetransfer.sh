#!/bin/bash

domain_name=$1
ns_list=$2
cat $ns_list |
while read line
do
    echo "[*] Trying $line"
    echo ""
    host -l $domain_name $line 2>&1 | tee ns-$domain_name-$line.txt
done

exit 0
