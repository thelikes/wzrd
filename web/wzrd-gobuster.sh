#!/bin/bash

# dead simple execution of gobuster
#
usage() {
	echo "usage ./wzrd-gobuster.sh -u \$target -w \$wordlist -s \$res_codes -x \$extension"
}

UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
statuscodes="200,204,301,302,307,500,502"

while [ "$1" != "" ]; do
    case $1 in
        -u | --url )			shift
                                targ=$1
                                ;;
        -w | --wordlist )    	shift
								wordlist=$1
                                ;;
        -s | --statuscodes )	shift
								statuscodes=$1
                                ;;
        -x | --extensions )		shift
								extensions=$1
                                ;;
        -p | --print )          print=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

input=$(basename $wordlist)

if [[ $extensions == "" ]]; then
    outfile="gobuster-$input-$(echo $targ | sed 's/\//_/g' | sed 's/\:/_/g').txt"
    cmd="gobuster dir -w $wordlist -u $targ -s $statuscodes -e -t 20 -l -o $outfile -a \"$UA\" -k --timeout 30s"
else
    outfile="gobuster-ext_$(echo $extensions | sed 's/,/_/g')-$input-$(echo $targ | sed 's/\//_/g' | sed 's/\:/_/g').txt"
    cmd="gobuster dir -w $wordlist -u $targ -s $statuscodes -e -t 20 -l -o $outfile -a \"$UA\" -k --timeout 30s -x $extensions"
fi

if [[ $print -eq 1 ]]; then
    echo $cmd
else
    eval $cmd
fi

exit 0
