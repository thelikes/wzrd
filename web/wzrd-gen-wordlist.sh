#!/bin/bash
# Accept a list of domains and/or list of endpoints and
# generate a wordlist
#

usage() {
    echo "To use, combine all your sub/domains (subfinder, amass, etc) into one list and all your URLs into a second list (wayback, alientvault, crawled, fuzzed, etc)"
    echo
	echo "usage ./wzrd-gen-wordlist.sh -D \$domains -U \$urls"
}

while [ "$1" != "" ]; do
    case $1 in
        -D | --domains )		shift
                                domains=$1
                                ;;
        -U | --urls )       	shift
								urls=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# { ls fuzz/ffuf-* | fuzznav e ; cat kohls.com/dns/domains-kohls.com.txt ; } |unfurl format '%r.%t'

if [[ $domains == "" ]] && [[ $urls == "" ]] ; then
    usage
    exit 1
fi

#
# Domains
#
subdomains_raw=wzrd_part-subdomains-raw
subdomains_out=wzrd_part-subdomains-out
rootdomains_raw=wzrd_part-rootdomains-raw
rootdomains_out=wzrd_part-rootdomains-out
domains_out=wzrd_part-domains_out

if [[ $domains != "" ]] ; then
    if [ -f $domains ] ; then
        echo "[*] Manipulating domains"
        # extract all subdomains
        cat $domains | unfurl format '%S' | tr '[:upper:]' '[:lower:]' | sort -u > $subdomains_raw
        { cat $subdomains_raw; cat $subdomains_raw | tok; } | sort -u > $subdomains_out

        # extract all root domains
        cat $domains | unfurl format '%r' | tr '[:upper:]' '[:lower]' | sort -u > $rootdomains_raw
        { cat $rootdomains_raw; cat $rootdomains_raw | tok; } | sort -u > $rootdomains_out

        # combine
        cat $subdomains_out $rootdomains_out | sort -u > $domains_out

        # clean up
        rm $subdomains_raw
        rm $rootdomains_raw
        rm $subdomains_out
        rm $rootdomains_out
    else
        echo "[!] Error, file does not exist: $domains"
    fi

fi

#
# URLs
#
paths_raw=wzrd_part-paths-raw
paths_out=wzrd_part-paths-out
keys_raw=wzrd_part-keys-raw
keys_out=wzrd_part-keys-out
urls_out=wzrd_part-urls

if [[ $urls != "" ]] ; then
    # to do: consider both upper and lower case list, or one list with both
    if [ -f $urls ] ; then
        echo "[*] Manipulating URLs"

        # paths
        cat $urls |unfurl paths  > $paths_raw
        { cat $paths_raw; cat $paths_raw | tok; } | grep -Evi '\.png|\.jpg|\.jpeg|\.gif|\.pdf|\.doc|\.xls|\.css|\.eot|\.woff|\.svg|\.ttf|\.ppt|\.mp3|\.dot' | sed 's/^\///g' | sort -u > $paths_out

        # keys
        cat $urls | unfurl keys > $keys_raw
        { cat $keys_raw; cat $keys_raw | tok; } | sort -u > $keys_out
        # to-do: get-title

        # combine
        cat $paths_out $keys_out | sort -u > $urls_out

        # clean up
        rm $paths_raw
        rm $keys_raw
        rm $paths_out
        rm $keys_out

        else
            echo "[!] Error, file does not exist: $urls"
        fi
fi

{ if [ -f $domains_out ]; then cat $domains_out; rm $domains_out; fi; if [ -f $urls_out ]; then cat $urls_out; rm $urls_out; fi; } | sort -u > wordlist.txt

echo "[*] Done. Outputfile is wordlist.txt ($(wc -l wordlist.txt|awk '{print $1}') lines)"

exit 0
