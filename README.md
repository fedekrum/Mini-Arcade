# Mini-Arcade

RPi Zero W 2
RPi Power Pack Hat Pro V1.1
2.4-2.8inch RPi Display MPI2418

#### 1) Install Retropie

#### 2) Connect to wifi
Create a file called wpa_supplicant.conf in the boot partition using the following template. (This will be moved at boot to the /etc/wpa_supplicant directory).
```
country=ES
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1


# RETROPIE CONFIG START
network={
    ssid="your_real_2.4_wifi_ssid"
    psk="your_real_password"
}
# RETROPIE CONFIG END
```

#### 3) Enable ssh
```
Create empty file in /boot/ssh.txt
```

#### 4) Update Retropie
```
sudo /home/pi/RetroPie-Setup/retropie_setup.sh
```

Choose "Update"
Confirm all

#### Install aditional Software
```
sudo apt-get install cmake
```


#### install gpionext



#### install bluetooth. ????

apt install mc cmake i2c-tools




#### instal driver for display
https://bytesnbits.co.uk/retropie-raspberry-pi-0-spi-lcd/

sudo apt-get install cmake
cd ~
git clone https://github.com/juj/fbcp-ili9341.git
cd fbcp-ili9341
mkdir build
cd /home/pi/fbcp-ili9341/build

rm -r /home/pi/fbcp-ili9341/build/*
cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=22 -DGPIO_TFT_RESET_PIN=27 -DSPI_BUS_CLOCK_DIVISOR=6   ..
make -j
sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341

cd /home/pi/fbcp-ili9341/build
rm -r /home/pi/fbcp-ili9341/build/*
cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=22 -DGPIO_TFT_RESET_PIN=27 -DSPI_BUS_CLOCK_DIVISOR=6 -DSTATISTICS=0  ..
make -j
sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341


sudo nano /boot/config.txt
sudo nano /etc/rc.local






https://github.com/Drewsif/PiShrink
