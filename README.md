# wzrd

WZRD is a repository of scripts designed to ease the execution of common tools
with optimized commands while only requiring the basic input parameters. 

## Capabilities
* wzrd-ffuf.sh - Execute fuff and save output
* wzrd-gau-wordlist.sh - Execute getallurls, save output, and generate
  a wordlist
* wzrd-gobuster.sh - Execute gobuster and save output
* wzrd-wfuzz.sh - Execute wfuzz and save output

## Examples

### gobuster

```
targ=https://target.com
list=/opt/SecLists/Discovery/Web-Content/raft-small-files.txt
wzrd-gobuster.sh -u $targ -w $list

# the command actually run
gobuster dir -w /opt/SecLists/Discovery/Web-Content/raft-small-files.txt -u https://target.com -s 200,204,301,302,307,403,500,502 -e -t 10 -l -o gobuster-raft-small-files.txt-https___target.com.txt -a "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36" -k --timeout 30s
```

### getallurls wordlist generation

```
targ=https://target.com
wzrd-gau-wordlist.sh -t $targ

# command actually run
echo $targ|getallurls|tee $gauou | grep -Evi '\.png|\.jpg|\.jpeg|\.gif|\.pdf|\.doc|\.xls|\.css|\.eot|\.woff|\.svg|\.ttf|\.ppt|\.mp3|\.dot'|unfurl paths|sort -u |tee /tmp/paths && { cat /tmp/paths ; cat /tmp/paths | tok; } | sed 's/^\///g' | sort -u | tee $wlout
```

