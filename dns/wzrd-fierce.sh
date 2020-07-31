#!/bin/bash

usage () {
    echo "./wzrd-fierce.sh -d <domain> -w <wordlist>"
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --domain )         shift
                                targ_domain=$1
                                ;;
        -w | --wordlist )       shift
                                sub_list=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

fierce -dns $targ_domain -wordlist $sub_list 2>&1 | tee fierce-$(basename $sub_list).txt

exit 0
