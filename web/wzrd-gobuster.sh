#!/bin/bash

# dead simple execution of gobuster
#
# usage ./wzrd-gobuster.sh $target $wordlist $res_codes $extension

interactive=
filename=~/sysinfo_page.html

while [ "$1" != "" ]; do
    case $1 in
        -f | --file )           shift
                                filename=$1
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

echo "file: $filename"

exit 0
