"""Add MD5 checksum to gcode file"""

import sys
from hashlib import md5
from shutil import copy
from tempfile import mkstemp

if len(sys.argv) < 2:
    print("Usage: addMD5.py <file>")
    exit(1)
else:
    print(f"Adding MD5 to {sys.argv[1]}")

try:
    with open(sys.argv[1], "rb") as fp:
        data = fp.read(-1)
except IOError:
    print(f"file not found: {sys.argv[1]}")
    exit(1)

checksum = md5(data).hexdigest().encode("ascii")
prefix = b"; MD5:" + checksum + b"\n"

tempfile = tmpfd, tmpname = mkstemp()
with open(tmpfd, "wb") as fp:
    fp.write(prefix + data)

copy(tmpname, sys.argv[1])
