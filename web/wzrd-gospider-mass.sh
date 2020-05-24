#!/bin/bash

usage() {
    echo "Pass this script a file containing a list of domains. Optionally, specify an output directory."
    echo
    echo "./wzrd-gospider-mass.sh -D hosts.txt -O run1/"
    echo
}

while [ "$1" != "" ]; do
    case $1 in
        -D | --domains )		shift
                                domains=$1
                                ;;
        -O | --out )        	shift
								out=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


if [[ "$domains" == "" ]]; then usage ; exit 1; fi; 

if [[ "$out" != "" ]]; then 
    if [ ! -d $out ]; then
        mkdir $out
    fi
fi

cat $domains |while read targ; do 
    if [[ "$out" != "" ]]; then
        log=$out/gospider-$(echo $targ | sed 's/:\/\//./g' | sed 's/\/$//g').txt
    else
        log=gospider-$(echo $targ | sed 's/:\/\//./g' | sed 's/\/$//g').txt
    fi

    gospider -s $targ -u "$UA" -d 5 -r | tee $log
done

exit 0

