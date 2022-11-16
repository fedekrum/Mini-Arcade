#!/bin/bash

cd /run/shm/
mkdir web_battery
cd web_battery
touch index.html
python -m SimpleHTTPServer 9980 &
exit 0