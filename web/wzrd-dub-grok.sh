#!/bin/bash
usage () {
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
    usage
    exit 1
fi

# if targ begins with http, targ is URL
# if no http and valid IP address, we have an IP addr
# if neither, *assume* we have sub/domain name
if echo $targ | egrep '^http' >/dev/null; then
    echo URL
elif echo $targ | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)" >/dev/null; then
    echo IP
fi

exit 0

d=$(echo $targ | unfurl domain)

ip=$(dig +short $d)

mkdir $ip-$d
cd $ip-$d

webanalyze -silent -host $targ -apps ~/.apps.json -crawl 3 | tee webanalyze-$d.log

/opt/wzrd/web/wzrd-gau-wordlist.sh -t $targ -d ../../gau

nmap -vv -Pn --top-ports 10 $ip -oN nmap-top1000-$ip.txt
