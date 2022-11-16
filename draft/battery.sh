#!/bin/bash
i2cset -y 1 0x62 0x0A 0x00
humanize=""
getopts "huvcm" options
case "${options}" in
        h)
                humanize=" -h "
                ;;
esac
echo "$humanize"
# ------------- FUNCTIONS -------------
charge_percentage () {
        charge="$((`i2cget -y 1 0x62 0x4 b`))"
        decimal="$((`i2cget -y 1 0x62 0x5 b`))"
        decimal=$(echo "ibase=10; obase=2; $decimal" | bc)
        decimal=$(($decimal/256))
        if [ "$1" = "-h" ]; then
                echo "Charge: ${charge}.${decimal}%   "
        else
                echo $charge
        fi
}

voltage () {
raw=$(($((`i2cget -y 1 0x62 0x02 b`))*256+$((`i2cget -y 1 0x62 0x03 b`))))
#voltage=$(($raw*305/1000))
voltage=$(echo "scale=4; $raw*305/1000000" | bc)
        if [ "$1" = "-h" ]; then
                echo "Voltage: ${voltage} mV "
        else
                echo $voltage
        fi
}

USB_connected () {
        usb="$((`i2cget -y 1 0x62 0x2`))"
        usb=$(echo "ibase=10; obase=2; $usb" | bc)
        usb="${usb: -3}"
        if [ "$1" = "-h" ]; then
                if [ "$usb" = "101" ]; then
                        echo "USB: connected   "
                else
                        echo "USB: disconnected"
                fi
        else
                if [ "$usb" = "101" ]; then
                        echo "1"
                else
                        echo "0"
                fi
        fi
}

deOtro () {

# batt_voltage
raw=$(($((`i2cget -y 1 0x62 0x02 b`))*256+$((`i2cget -y 1 0x62 0x03 b`))))
fine=$(($raw*305/1000))
echo voltage of battery :$fine mv

#Calculated battery fill rate
perc_batt=`i2cget -y 1 0x62 0x4 b`
perc_batt_dec=$(($perc_batt))
echo fill rate of battery calculated by ic $(($perc_batt_dec*100/256))%

#version
version=$((`i2cget -y 1 0x62 0x00 b`))
echo version of the hat: $version

#get alert - if voltage of batt drops under set variabel then alert bit 7 - or most significant bit - will be set
alert_raw=`i2cget -y 1 0x62 0x6 b`
alert_dec=$(($alert_raw))
if [ "127" -lt "$alert_dec" ] ; then    echo alert alert alert. sudo shutdown pi and sink the stash; alert=$(($alert_dec-128)) else echo no alert.;fi

mins_remain=$(($((`i2cget -y 1 0x62 0x7 b`)) +$((256*alert_dec))))

echo calculated minutes remaining by cw2015 ic: $mins_remain
}

# ---------------- PROGRAM --------------
while [ True ]; do

if [ "$1" = "-c" -o "$2" = "-c" ]; then
        charge_percentage ${humanize}
        exit 0
elif [ "$1" = "-u" -o "$2" = "-u" ]; then
        USB_connected ${humanize}
        exit 0
elif [ "$1" = "-v" -o "$2" = "-v" ]; then
        voltage ${humanize}
        exit 0
elif [ "$1" = "-m" -o "$2" = "-m" ]; then
        echo "Monitor"
                clear
                while [ True ]; do
                        echo -ne "\033[0;0H"
                        echo "Monitor"
                        i2cdump -y 1 0x62 | grep -v "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
                        charge_percentage -h
                        voltage -h
                        USB_connected -h
                        deOtro
                        sleep 1
                done
        exit 0
else
    break
fi
done

exit 0