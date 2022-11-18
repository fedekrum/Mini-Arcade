#!/bin/bash

cd /run/shm/
mkdir web_battery
cp /home/pi/
cd web_battery
touch index.html
python -m SimpleHTTPServer 9980 &
exit 0