#!/bin/bash
usage () {
    echo "Description: Accept URL as input, process minimal enumeration."
    echo
    echo "usage: ./wzrd-dub.sh -t <target>"
}

while [ "$1" != "" ]; do
    case $1 in
        -t | --target )         shift
                                targ=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ "$targ" == "" ]]; then
    echo "[!] Error: No target provided"
    usage
    exit 1
fi

if ! echo $targ | egrep '^http' > /dev/null ; then
    echo "[!] Error: Provided input is not URL"
    usage
    exit 1
fi

d="unknown"
ip="unknown"
if echo $targ | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" >/dev/null; then
    echo IP
    ip=$(echo $targ | unfurl domain)
    revlookup=$(host $ip | rev | awk '{print $1}' | rev | sed 's/\.$//g')
    if [ $? -eq 0 ]; then
        d=$revlookup
    fi
else
    d=$(echo $targ | unfurl domain)

    ip=$(dig +short $d)
fi


mkdir $ip-$d
cd $ip-$d

echo "[+] Running cero"
echo $targ 2>&1 | unfurl domain | cero | tee cero-$(echo $targ | unfurl domain).log
echo

echo "[+] Running webanalyze"
rm /tmp/apps.json 2>/dev/null ; cd /tmp ; webanalyze -update ; cd -
webanalyze -silent -host $targ -apps /tmp/apps.json -crawl 3 | tee webanalyze-$d.log
echo 

echo "[+] Running gau + creating wordlist"
/opt/wzrd/web/wzrd-gau-wordlist.sh -t $targ 
echo 

# todo: run hakwraler
# todo: js param mine
# todo: try cat $targ | unfurl | tok | ffuf -u $targ/FUZZ -w -

echo "[+] Running nmap --top-port 25"
nmap -v -Pn -T4 --top-ports 25 -open $ip -oA nmap-top25-$ip
echo

echo "[+] Complete"

exit 0
