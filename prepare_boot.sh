# RUN THIS IN MY MAC AFTER RETROPIE INSTALLATION

if [ ! -f /Volumes/boot/ssh.txt ]
then
    touch /Volumes/boot/ssh.txt
fi

if [ ! -f /Volumes/boot/config.txt.orig ]
then
    mv /Volumes/boot/config.txt /Volumes/boot/config.txt.orig
fi

if [ ! -f /Volumes/boot/ssh.txt ]
then
    touch /Volumes/boot/ssh.txt
fi

# Replaces the original 
wget https://raw.githubusercontent.com/fedekrum/Mini-Arcade/main/files/boot/config.txt -O /Volumes/boot/config.txt

# Creates a file called /boot/wpa_supplicant.conf using the following template. 
# This will be moved at boot to the /etc/wpa_supplicant directory.
wget https://raw.githubusercontent.com/fedekrum/Mini-Arcade/main/files/boot/wpa_supplicant.conf -O /Volumes/boot/wpa_supplicant.conf

# Edit your wifi settings
nano /Volumes/boot/wpa_supplicant.conf
