#!/bin/python3

import sys
import subprocess
import json
from io import StringIO

eww_files_var = "file_list"

# get "file_list" from eww
r = subprocess.run(['eww', 'get', eww_files_var], stdout=subprocess.PIPE)
io = StringIO(r.stdout.decode('utf-8'))

# try loading file_list as json or initialize a new empty list
try:
    file_list = json.load(io)
except json.decoder.JSONDecodeError:
    file_list = []

# if the file_list is full, pop one file from it
if len(file_list) >= 3:
    file_list.pop(0)
    
# add the new file to the end of the list
new_file = sys.argv[1]
file_list.append(new_file)

# update eww's file_list
r = subprocess.run(['eww', 'update', eww_files_var+ '=' + json.dumps(file_list)])
