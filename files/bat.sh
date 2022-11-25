#!/bin/bash

# Copy this script at '/home/pi/bat.sh'
# Start this script at /etc/rc.local with 'sudo bash /home/pi/bat.sh &'
# You can 'tail -f /home/pi/bat.csv' to see the log

# Configuration --------------------
shutdown_percentage="4"
wait=60     # time between loop cycles

alarm1=20
alarm2=10
alarm3=5

log=false

sleep 60    # to wait internet clock sync ???

# ----------------------------------

charge_percentage () {
        charge="$((`i2cget -y 1 0x62 0x4 b`))"
        decimal="$((`i2cget -y 1 0x62 0x5 b`))"
        decimal=$(echo "ibase=10; obase=2; $decimal" | bc)
        decimal=$(($decimal/256))
        echo $charge
}

voltage () {
        raw=$(($((`i2cget -y 1 0x62 0x02 b`))*256+$((`i2cget -y 1 0x62 0x03 b`))))
        volt=$(($raw*305/1000))
        echo $volt
}

USB_connected () {
        usb="$((`i2cget -y 1 0x62 0x2`))"
        usb=$(echo "ibase=10; obase=2; $usb" | bc)
        usb="${usb: -3}"
        if [ "$usb" = "101" ]; then
                echo "1"
        else
                echo "0"
        fi
}

i2cset -y 1 0x62 0x0A 0x00

while [ True ]; do
        dump=`i2cdump -y 1 0x62 b| grep "00: " | awk -F'[ ]' -v OFS="," '{$1=$1; print $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17}'`
        if [ "$log" = true ] ; then
                echo "`date +"%y-%m-%d_%T"`,`charge_percentage`,`USB_connected`,`voltage`,$dump" >> /home/pi/bat.csv
        fi
        if [ $(("`charge_percentage`")) -le $(("$shutdown_percentage")) ]; then
                echo APAGAR !!!
                sudo /usr/sbin/shutdown -h now
                while [ True ]; do
                        sleep 5
                done
        fi
sleep $wait
done
exit 0
