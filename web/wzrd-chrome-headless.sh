#!/bin/bash

usage () {
    echo "Usage: ./wzrd-chrome-headless.sh -t <target> -o <output>"
}

while [ "$1" != "" ]; do
    case $1 in
        -t | --target )         shift
                                targ=$1
                                ;;
        -o | --output )         shift
                                output=$1
                                ;;
        -i | --interactive )    interactive=1
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

outfile=headless-$(echo $targ | sed 's/:\/\//./g'|sed 's/\/$//g').txt
if [[ "$output" != "" ]] ; then
    outfile=$output
fi

chromium-browser -headless --user-agent="$UA" --no-sandbox --dump-dom $targ |tee $outfile

exit 0
