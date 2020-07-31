#!/bin/bash

targ=$1

gospider -s $targ -d 5 -r -u "$UA" --sitemap --robots |tee gospider-$(echo $targ | sed 's/:\/\//./g'|sed 's/\/$//g').txt
