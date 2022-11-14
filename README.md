# Mini-Arcade

### What do you need

- RPi Zero W 2
- RPi Power Pack Hat Pro V1.1
- 2.4-2.8inch RPi Display MPI2418
- BT game controller

### 1) Install Retropie

Do it with the Raspberry Pi Imager app

### 2) Make these steps on the SD card

- a) Connect to wifi

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

- b) Enable ssh

  Create an empty file in /boot/ssh.txt

- c) reboot

### 3) Connect to the RPi and execute this script

```
\# BKP
mkdir /home/pi/bkp
sudo cp -r /boot /home/pi/bkp/boot
sudo cp -r /etc/rc.local /home/pi/bkp/rc.local

\# Install aditional software
sudo apt update
sudo apt install -y mc git cmake i2c-tools

\# Change pi password
sudo passwd

\# Edit raspi-config and enable i2c
sudo raspi-config

\# Copy you ssh public key to have faster and secured access
ssh-copy-id -i .ssh/id_rsa.pub pi@retropie.local

exit 0
```

3 Interface Options Configure connections to peripherals

P5 I2C Enable/disable automatic loading of I2C kernel module

Yes

### 4) Run retropie_setup

```
sudo /home/pi/RetroPie-Setup/retropie_setup.sh
```

Choose "Update"
Confirm all

-

C Configuration / tools

199 bluetooth - Configure Bluetooth Devices
Pair the BT controllers

206 emulationstation - EmulationStation - Frontend used by RetroPie
3 Swap A/B Buttons in ES (Currently: Default)

207 esthemes - Install themes for Emulation Station
78 Update or Uninstall pacdude/minijawn

226 samba - Configure Samba ROM Shares
1 Install RetroPie Samba shares
You will be able to get as GUEST

### Install aditional Software

```
apt install i2c-tools -y
```

### Copy ROMS and BIOS

cd /home/pi/Mini-Arcade/share
cp roms /home/pi/Retropie
git clone https://github.com/fedekrum/Mini-Arcade.git

### install gpionext

### install bluetooth. ????

### instal driver for display

https://bytesnbits.co.uk/retropie-raspberry-pi-0-spi-lcd/

sudo apt-get install cmake
cd ~
git clone https://github.com/juj/fbcp-ili9341.git
cd fbcp-ili9341
mkdir build
cd /home/pi/fbcp-ili9341/build

rm -r /home/pi/fbcp-ili9341/build/\*
cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=22 -DGPIO_TFT_RESET_PIN=27 -DSPI_BUS_CLOCK_DIVISOR=6 ..
make -j
sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341

cd /home/pi/fbcp-ili9341/build
rm -r /home/pi/fbcp-ili9341/build/\*
cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=22 -DGPIO_TFT_RESET_PIN=27 -DSPI_BUS_CLOCK_DIVISOR=6 -DSTATISTICS=0 ..
make -j
sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341

sudo nano /boot/config.txt

```
# sudo nano /etc/rc.local
# sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341 &
sudo sed -i 's/exit 0/sudo \/home\/pi\/fbcp-ili9341\/build\/fbcp-ili9341 \&\nexit 0/' /etc/rc.local
```

https://github.com/Drewsif/PiShrink

Battery icon on top right
https://github.com/d-rez/gbz_overlay/blob/master/overlay.py
