#!/bin/bash

GREEN="\033[32m"
RED="\033[31m"
NORMAL="\033[0;39m"
LBLUE="\e[94m"
CYAN="\e[96m"

echo
echo -e "\e[96m

     __     _   __    __ _ _    
  /\ \ \___| |_/ / /\ \ \ | | __
 /  \/ / _ \ __\ \/  \/ / | |/ /
/ /\  /  __/ |_ \  /\  /| |   < 
\_\ \/ \___|\__| \/  \/ |_|_|\_\\
                                

----------------------------------"
echo
echo

function usage {
    printf $RED
    echo need target
    printf $NORMAL
    exit 1
}

if [[ $# -ne 1 ]]
then
    usage
else
    targ=$1
fi

echo -e "${GREEN}[+] TARGET: ${targ}"
echo

# get the ball rolling
echo -e "${LBLUE}[+] Starting NMAP top 1000..."
echo
sleep 1

printf $NORMAL
nmap -v -Pn --top-ports 1000 $targ -oA nmap-top1000-$targ

# Quick scanning
quick_tcp=nmap-tcp_quick-$targ
quick_udp=nmap-udp_quick-$targ

echo
echo -e "${LBLUE}[+] Starting TCP scan..."
echo
sleep 1

printf $NORMAL
nmap -v -Pn -sS --stats-every 3m --max-retries 1 --max-scan-delay 20 --defeat-rst-ratelimit -T4 -p- $targ -oA $quick_tcp

echo
echo -e "${LBLUE}[+] Starting UDP scan..."
echo
sleep 1

printf $NORMAL
nmap -v -Pn --top-ports 1000 -sU --stats-every 3m --max-retries 1 -T3 $targ -oA $quick_udp

openports_tcp=ports-tcp-$targ
openports_udp=ports-udp-$targ.

# grep the full for open ports
if grep open $quick_tcp | grep 'tcp' >/dev/null 2>&1; then
    grep open $quick_tcp | grep 'tcp' |grep -v Discovered 2>&1 | cut -d\/ -f1 | tee $openports_tcp.nmap
fi
if grep open $quick_udp | grep 'udp' >/dev/null 2>&1; then
    grep open $quick_udp | grep 'udp' |grep -v Discovered 2>&1 | cut -d\/ -f1 | tee $openports_udp.nmap
fi

# build the port list for NMAP full
ports_list=""
if [[ -e $openports_tcp ]]
then
    tcp_count=$(cat $openports_tcp | wc -l)
    tcplist=$(cat $openports_tcp | tr '\n' ','| sed 's/.$//')
    ports_list="T:$tcplist"
else
    tcp_count="${RED}0${NORMAL}"
fi

if [[ -e $openports_udp ]]
then
    udp_count=$(cat $openports_udp | wc -l)
    udplist=$(cat $openports_udp | tr '\n' ','| sed 's/.$//')
    ports_list="$ports_list,U:$udplist"
else
    udp_count="${RED}0"
fi

echo
echo -e "${GREEN}[+] Open ports:\n TCP ($tcp_count): $tcplist\n UDP ($udp_count): $udplist"
echo
sleep 1

# nmap
nmapfull=nmap-full-$targ

if [[ "$ports_list" == "" ]]
then
    echo -e "${RED}[!] No ports found, skipping full NMAP..."
    exit 1
else
    echo -e "${LBLUE}[+] Starting full nmap..."
    echo
fi
sleep 1

printf $NORMAL

# run thorough nmap against identified ports
nmap -v --stats-every 3m -A --version-all  -Pn -p$ports_list $targ -oA $nmapfull
# add SYN and UDP flags to get UDP and TCP together
#nmap -vv --stats-every 3m -sU -sS -A --version-all -Pn -p$ports_list $targ -oN $nmapfull

# services
services=services-$targ.txt

grep open $nmapfull.nmap | grep 'tcp\|udp' |grep -v Discovered 2>&1 | tee $services

echo
echo -e "${GREEN}[+] Discovered services:"
echo
cat $services
sleep 1

echo
echo -e "${CYAN}Complete."
echo

exit 0
