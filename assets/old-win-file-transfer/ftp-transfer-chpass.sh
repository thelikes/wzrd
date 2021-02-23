#!/bin/bash

echo "[*] checking last modify"
ls -l /etc/pure-ftpd/pureftpd.passwd

echo "[*] reseting pw"
pure-pw passwd offsec
pure-pw mkdb

echo "[*] verifying change"
ls -l /etc/pure-ftpd/pureftpd.passwd

echo "[*] restarting"
/etc/init.d/pure-ftpd start

exit 0
