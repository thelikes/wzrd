#!/bin/bash

targ=$1

echo "[!] Ensure smbclient is up to snuff"
sleep 1

enum4linux -a $targ 2>&1 | tee enum4linux-$targ.txt

exit 0
