#!/bin/bash

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

# ffuf -c -u $targ/FUZZ -w $list -o ffuf-$(basename $list)-$(echo $targ | sed 's/\//_/g' | sed 's/\:/_/g').txt -t 10 -H "User-Agent: $UA" -mc all -ac
#

exit 0
