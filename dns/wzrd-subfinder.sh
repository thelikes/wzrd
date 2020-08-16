#!/bin/bash

usage () {
    echo "Usage: ./wzrd-subfinder.sh -d <domain>"
    echo "        -o <output> -R <resolvers list> (optional)"
    echo "        -R <resolvers list> (optional)"
    echo "        -C <config> (optional)"
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --domain )         shift
                                domain=$1
                                ;;
        -o | --output )         shift
                                output=$1
                                ;;
        -C | --config )         shift
                                config_file=$1
                                ;;
        -R | --resolvers )      shift
                                resolv_file=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ "$domain" == "" ]] ; then
    echo "[!] Error: domain missing"
    usage
    exit 1
fi

config_str=""
if [[ "$config_file" != "" ]] ; then
    config_str="-config $config_file"
fi

resolver_str=""
if [[ "$resolv_file" != "" ]] ; then
    resolver_str="-rL $resolv_file"
fi

outfile=subfinder-$domain-$(date +%Y-%m-%d).log
if [[ "$output" != "" ]] ; then
    outfile=$output
fi

subfinder $config_str -d $domain -nC -nW -o $outfile $resolver_str -recursive -silent -t 20

exit 0
