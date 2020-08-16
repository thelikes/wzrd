#!/bin/bash

usage () {
    echo "Usage: ./wzrd-httpx.sh -t <target>"
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

if [[ "$targ" == "" ]] ; then 
    echo "[!] Error: No target provided"
    exit 1
fi

out=httpx-$(echo $targ | sed 's/:\/\//./g'|sed 's/\/$//g').txt

if [[ -f $targ ]]; then
    httpx -l $targ -H "User-Agent: $UA" -no-color -o $out -threads 20 -ports 80,443,8080,8443 -title -content-length -status-code -web-server -silent
else
    echo $targ | httpx -H "User-Agent: $UA" -no-color -o $out -threads 20 -ports 80,443,8080,8443 -title -content-length -status-code -web-server -silent
fi

exit 0
