#!/bin/bash
# A script to execute getallurls on a URL and generate
# a wordlist based on the output. 
# https://github.com/lc/gau


usage() {
	echo "usage ./wzrd-gau-wordlist.sh -t \$target -d \$out_dir"
}

while [ "$1" != "" ]; do
    case $1 in
        -t | --targ )			shift
                                targ=$1
                                ;;
        -d | --directory )    	shift
								dir=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

if [[ $targ == "" ]]; then
    usage
    exit 1
fi

if [[ $dir == "" ]]; then
    gauout=gau-$(echo $targ | sed 's/:\/\//./g' | sed 's/\/$//g').txt
    wlout=wordlist-gau-$(echo $targ | sed 's/:\/\//./g' | sed 's/\/$//g').txt
else
    gauout=$dir/gau-$(echo $targ | sed 's/:\/\//./g' | sed 's/\/$//g').txt
    wlout=$dir/wordlist-gau-$(echo $targ | sed 's/:\/\//./g' | sed 's/\/$//g').txt
fi

# output getallurls to file
echo $targ|getallurls|tee $gauout 

# output wordlist
# to-do: unfurl keys
cat $gauout |grep -Evi '\.png|\.jpg|\.jpeg|\.gif|\.pdf|\.doc|\.xls|\.css|\.eot|\.woff|\.svg|\.ttf|\.ppt|\.mp3|\.dot'|unfurl paths|sort -u |tee /tmp/paths

{ cat /tmp/paths ; cat /tmp/paths | tok; } | sed 's/^\///g' | sort -u | tee $wlout

exit 0
