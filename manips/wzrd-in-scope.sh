#!/bin/bash

# Take a list of IP addrs that are in scope and search a list of resolved domains.
# Results in a list of in-scope domains.

usage () { 
    echo "./wzrd-in-scope.sh -s scope.txt -r resolved.txt"
}

while [ "$1" != "" ]; do
    case $1 in
        -s | --scope )          shift
                                scope=$1
                                ;;
        -r | --resolved )       shift
                                resolved=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ "$scope" == "" ]] || [[ "$resolved" == "" ]] ; then usage ; exit 1 ; fi

if [[ ! -f $scope ]] ; then
    echo "[!] Error: $scope not found"
    usage
    exit 1
fi

if [[ ! -f $resolved ]] ; then
    echo "[!] Error: $resolved not found"
    usage
    exit 1
fi

cat $scope | while read ip; do searchip=$(echo $ip | sed 's/\./\\\./g'); grep -w "$searchip" $resolved ; done

exit 0
