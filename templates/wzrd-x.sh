#!/bin/bash

usage () {
    echo "Usage: "
}

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                filename=$1
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

if [[ ! -f $filename ]] ; then 
    echo "[!] Error: "
    exit 1
fi

# do stuff

exit 0
