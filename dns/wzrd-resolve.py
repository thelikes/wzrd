#! /usr/bin/python3

import subprocess
import sys
from multiprocessing.dummy import Pool as ThreadPool
import time

def resolveDomain(domain):
    # run `getent hosts` on each url
    cmd_string=f"getent ahostsv4 {domain}"
    cmd = subprocess.Popen(cmd_string, shell=True, stdout=subprocess.PIPE)

    ip_list = []
    formatted_ip_list=''

    for line in cmd.stdout:
        # grab the address from the output
        ip_list += [line.split()[0]]
        
    # remove duplicate addresses
    unique_ip_list = list(set(ip_list))
    formatted_ip_list=''

    # format the list with commas
    for i,val in enumerate(unique_ip_list):

        if i < len(unique_ip_list)-1:
            formatted_ip_list += str(val,"utf-8")
            formatted_ip_list += ","
        else:
            formatted_ip_list += str(val,"utf-8")

    print(f"{domain}:{formatted_ip_list}")
    

# main
input_list = sys.argv[1]

# read file lines 
with open(input_list) as f:
    content = f.readlines()

# remove new line char
content = [x.strip() for x in content] 

# debug
start_time = time.time()

threads= 15
# Make the Pool of workers
pool = ThreadPool(threads)
# resolve IP(s)
pool.map(resolveDomain,content)
pool.close()
pool.join()

# debug
duration = time.time() - start_time
#print(f"{threads} Pool: {duration} seconds")
