# RUN THIS IN MY MAC AFTER RETROPIE INSTALLATION

# Create a file called /boot/wpa_supplicant.conf using the following template. 
# This will be moved at boot to the /etc/wpa_supplicant directory.

touch /Volumes/boot/ssh.txt
wget https://raw.githubusercontent.com/fedekrum/Mini-Arcade/main/files/boot/config.txt -O /Volumes/boot/config.txt
wget https://raw.githubusercontent.com/fedekrum/Mini-Arcade/main/files/boot/wpa_supplicant.conf -O /Volumes/boot/wpa_supplicant.conf
nano /Volumes/boot/wpa_supplicant.conf
