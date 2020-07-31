#!/bin/bash

targ=$1

if [ $# -lt 1 ]; then
  echo "./run-nikto.sh <target>"
  exit 0
fi

echo TARGET = $targ

if echo $targ | grep -i https; then
  nikto -h "${targ}" -ssl -output nikto-$(echo $targ | sed 's/\//_/g' | sed 's/\:/_/g').txt
else
  nikto -h "${targ}" -output nikto-$(echo $targ | sed 's/\//_/g' | sed 's/\:/_/g').txt
fi
