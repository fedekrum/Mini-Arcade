#!/bin/bash
sound=$(cat "/home/pi/police_s.wav"| base64)
for i in {0..10..1}
do
  echo "$sound" | base64 -d| aplay -t wav
done
