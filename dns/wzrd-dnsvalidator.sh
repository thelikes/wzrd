#!/bin/bash

usage () {
    echo "Usage: ./wzrd-dnsvalidator.sh -o <outfile>"
}

while [ "$1" != "" ]; do
    case $1 in
        -o | --output )         shift
                                outfile=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ "$outfile" == "" ]] ; then 
    outfile=resolvers.txt
fi

dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o $outfile

exit 0
