#!/bin/bash
# Run Nmap and map an entire network thoroughly

scope=$1

if [ -f $scope ] ; then
    echo "[!] Missing scope"
    exit 1
fi

# Host identification
echo "[+] Running: ping sweep"
echo 
nmap -v -sP -PS7,9,13,21-23,25-26,37,53,79-81,88,106,110-111,113,119,135,139,143-144,179,199,389,427,443-445,465,513-515,543-544,548,554,587,631,646,873,990,993,995,1025-1029,1110,1433,1720,1723,1755,1900,2000-2001,2049,2121,2717,3000,3128,3306,3389,3986,4899,5000,5009,5051,5060,5101,5190,5357,5432,5631,5666,5800,5900,6000-6001,6646,7070,8000,8008-8009,8080-8081,8443,8888,9100,9999-10000,32768,49152-49157 -PE -PP -PA80 --stats-every 3m --max-retries 1 --max-scan-delay 20 --min-parallelism 55 --min-hostgroup 16 -T4  -iL $scope -oA nmap-ping-large

# Port identification
echo "[+] Running: port sweep"
echo 
egrep 'Host' nmap-ping-large.gnmap | grep 'Status: Up' | awk '{print $2}' | sort -Vu | tee alive.txt
nmap -v -Pn -sS --stats-every 3m --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit --min-parallelism 55 --min-hostgroup 16 -T4 -p- -iL alive.txt -oA nmap-tcp_all

# Service identification
echo "[+] Running: service enumeration"
echo 
ports=$(cat nmap-tcp_all.gnmap |grep -oP '\d{1,5}/open' | cut -d\/ -f1 |sort -un|tee services.txt | tr '\n' ',')
nmap -n -vv --stats-every 3m -sV -sC -p $ports $ip -iL alive.txt -oA nmap-tcp_targeted

echo "[+] Done"
echo

exit 0
