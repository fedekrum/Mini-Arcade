# Mini-Arcade

This is for my private use on my "REAL Retro Arcade Machine" project.

## What do I need

- RPi Zero W 2
- RPi Power Pack Hat Pro V1.1
- 2.4-2.8inch RPi Display MPI2418
- BT game controller

## 1) Install Retropie

Do it with the Raspberry Pi Imager app

## 2) Prepare your SD

```
cd
rm ./prepare_boot.sh
wget https://raw.githubusercontent.com/fedekrum/Mini-Arcade/main/prepare_boot.sh | bash
bash ./prepare_boot.sh
rm ./prepare_boot.sh

```

### c) Eject the SD and Boot your RPi with it.

Wait till file system expansion

Probably you must do the following on your Mac to connect .

```
cd
ssh-keygen -R retropie.local
ssh-copy-id -i .ssh/id_rsa.pub pi@retropie.local
ssh retropie.local -lpi
```

Change pi's password

```
sudo passwd pi
```

## 3) Connect to the RPi and execute the following lines

```
# BKP
mkdir /home/pi/bkp
sudo cp -r /boot /home/pi/bkp/boot
sudo cp -r /etc/rc.local /home/pi/bkp/rc.local

# Install additional software
sudo apt update
sudo apt install -y mc git cmake i2c-tools bc logrotate php-cli

# Run raspi-config
# - Enable i2c
# - Change ALL localizations
# - Select keyboard
sudo raspi-config
```

## 4) Run retropie_setup

```
sudo /home/pi/RetroPie-Setup/retropie_setup.sh
```

### Choose "Update". Confirm all

### C Configuration / tools

- 199 bluetooth - Configure Bluetooth Devices
  - Pair the BT controllers
- 206 emulationstation - EmulationStation - Frontend used by RetroPie
  - 3 Swap A/B Buttons in ES (Currently: Default)
- 207 esthemes - Install themes for Emulation Station
  - 78 Update or Uninstall pacdude/minijawn

## 5) Copy ROMS and BIOS

While updating, you can open a second console an do the following

(Make sure to make repo public or it will not work.)

```
cd /home/pi/
git clone https://github.com/fedekrum/Mini-Arcade.git
cd /home/pi/Mini-Arcade/share
cp -r roms /home/pi/RetroPie
```

## 6) Install driver for display

https://bytesnbits.co.uk/retropie-raspberry-pi-0-spi-lcd/

```
cd ~
git clone https://github.com/juj/fbcp-ili9341.git
cd fbcp-ili9341
mkdir build

cd /home/pi/fbcp-ili9341/build
rm -r /home/pi/fbcp-ili9341/build/*
cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=22 -DGPIO_TFT_RESET_PIN=27 -DSPI_BUS_CLOCK_DIVISOR=6 ..
make -j
sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341

cd /home/pi/fbcp-ili9341/build
rm -r /home/pi/fbcp-ili9341/build/*
cmake -DILI9341=ON -DGPIO_TFT_DATA_CONTROL=22 -DGPIO_TFT_RESET_PIN=27 -DSPI_BUS_CLOCK_DIVISOR=6 -DSTATISTICS=0 ..
make -j
sudo /home/pi/fbcp-ili9341/build/fbcp-ili9341
```

Start display driver at /etc/rc.local

```
sudo sed -i 's/exit 0$/sudo \/home\/pi\/fbcp-ili9341\/build\/fbcp-ili9341 \&\nexit 0/' /etc/rc.local
```

Copy config.txt (needs to be improved as example above)

```
cd /home/pi/Mini-Arcade/
sudo cp /boot/config.txt /home/pi/bkp/config.txt.previous
sudo su -c 'sudo cat config.txt > /boot/config.txt'

```

## 7) Install gpionext

https://github.com/mholgatem/GPIOnext

DO NOT execute the setup after install
Make sure GPIO pins for Joystick are connected

```
cd ~
git clone https://github.com/mholgatem/GPIOnext.git
bash GPIOnext/install.sh
gpionext set pins 7,12,16,18,35,36,37,38,40
gpionext config

```

You can enable/disable GPIOnext by doing

```
gpionext stop
gpionext start
```

GPIOnext Flags

```
gpionext set combo_delay [#] - the delay in milliseconds to allow for combos to be pressed

default: gpionext set combo_delay 50
gpionext set pins [#,#,#|default] - the pins that gpionext will configure and watch

default: gpionext set pins default
example: gpionext set pins 3,5,38,40
gpionext set debounce [#] - the delay in milliseconds to allow for button debounce

default: gpionext set debounce 1
gpionext set pulldown [true|false] - set gpio pulldown resistors instead of pullup

default: gpionext set pulldown false
gpionext set debug [true|false] - write output to /home/pi/gpionext/logFile.txt

default: gpionext set debug false
gpionext set dev [true|false] - write output to console

default: gpionext set dev false
```

## 8) Install battery software

#### Check I2C on Rasbperry pi

check if there is a I2C device；

```
sudo i2cdetect -y 1
i2cdump -y 1 0x62
```

0x62 is device address.

You can see：0x0A address register default value is 0xC0

```
i2cset -y 1 0x62 0x0A 0x00
```

Wake-up the device I2C function;

MODE register address 0x0A set to 0x00

```
i2cdump -y 1 0x62;
```

VCELL(cell voltage) address：0x02 - 0x03

PS: 0x62 is the device address of I2C device

(CW2015 power monitoring chip）

#### How to read the voltage values that saved by chip register?

```
sudo i2cget -y 1 0x62 0x02 w
```

get the value 0xf82f; swap high and low byte to get 0x2ff8;

0x2ff8 converted to decimal number is 12280;

12280 \* 305 = 3745400 uV

3745400/1000000 = 3.7454V

PS: 305 is a fixed value (Fix factor value);

#### How to read the remaining capacity (percentage) estimated by the chip?

1. Read the integer part of the battery percentage;

```
sudo i2cget -y 1 0x62 0x4 b
```

the resulting value is 0x11;

Converted to 10 decimalism is 17, then the remaining capacity is 17%;

2. Read the fractional part of the battery percentage

```
sudo i2cget -y 1 0x62 0x5 b
```

the resulting value is 0x95;

Converted to decimalism is 149;

Then the fractional part is 149/256 = 0.58;

So the chip estimated remaining capacity (percentage) is 17.58%.

## 9) Install bluetooth audio ????

## other) References

https://stackedit.io/app#

https://github.com/Drewsif/PiShrink

Battery icon on top right

https://github.com/d-rez/gbz_overlay/blob/master/overlay.py
