#!/bin/bash

#wfuzz -c -w $list -u $targ/FUZZ -f wfuzz-$input-$(echo $targ | sed 's/\//_/g' | sed 's/\:/_/g').txt -H "$UA"

UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36 (bugcrowd&h1)"

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
