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

echo $targ | httpx -content-length -no-color  -silent -status-code -title -web-server -o $out -threads 20

exit 0
