#!/bin/bash

usage () {
    echo "Usage: ./wzrd-httpx.sh -t <target>"
    echo "       -o <output> (optional)"
}

while [ "$1" != "" ]; do
    case $1 in
        -t | --target )         shift
                                targ=$1
                                ;;
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

if [[ "$targ" == "" ]] ; then 
    echo "[!] Error: No target provided"
    usage
    exit 1
fi

if [[ "$outfile" != "" ]] ; then
    out_str="-o $outfile"
fi

if [[ -f $targ ]]; then
    httpx -l $targ -H "User-Agent: $UA" -no-color $out_str -threads 50 -ports 80,443,8080,8443 -title -content-length -status-code -web-server -silent
else
    echo $targ | httpx -H "User-Agent: $UA" -no-color $out_str -threads 50 -ports 80,443,8080,8443 -title -content-length -status-code -web-server -silent
fi

exit 0
