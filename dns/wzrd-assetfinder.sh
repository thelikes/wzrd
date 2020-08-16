#!/bin/bash

usage () {
    echo "Usage: ./wzrd-assetfinder.sh -d <domain>"
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --domain )         shift
                                domain=$1
                                ;;
        -o | --output )         shift
                                output=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ "$domain" == "" ]] ; then
    echo "[!] Error: missing domain"
    usage
    exit 1
fi

datestr="$(date +%Y-%m-%d)"
outfile="assetfinder-$domain-$datestr.log"
if [[ "$output" != "" ]] ; then 
    outfile=$output
fi

assetfinder -subs-only $domain | tee $outfile

exit 0
