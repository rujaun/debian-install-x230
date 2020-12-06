#!/bin/bash

# Install and configure sudo
apt -y install sudo

# Uncomment pam_wheel auth
# auth       required   pam_wheel.so
sed -i '/# auth       required   pam_wheel.so$/s/^# //g' /etc/pam.d/su

sudo addgroup --system wheel
sudo adduser rujaun wheel

# Add %wheel ALL=(ALL:ALL) ALL to sudoers
echo '%wheel ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo


# Add non free and backports repos
rm /etc/apt/sources.list
cp config/sources.list /etc/apt/sources.list

apt update && apt -y install -t buster-backports linux-image-amd64 linux-headers-amd64 firmware-linux firmware-linux-nonfree vim tmux htop neofetch firmware-iwlwifi

# Enable Trim support for SSDs
systemctl enable fstrim.trimer

# Install build essential for compilers
apt -y install build-essential

# Install Xorg
apt -y install xorg xinit xserver-xorg-video-intel xterm xbacklight

# Install some dependecies for i3block scripts
apt -y install cpufrequtils

# Install i3wm
/usr/lib/apt/apt-helper download-file http://dl.bintray.com/i3/i3-autobuild/pool/main/i/i3-autobuild-keyring/i3-autobuild-keyring_2016.10.01_all.deb keyring.deb SHA256:460e8c7f67a6ae7c3996cc8a5915548fe2fee9637b1653353ec62b954978d844
apt install ./keyring.deb
echo 'deb http://dl.bintray.com/i3/i3-autobuild sid main' | sudo tee /etc/apt/sources.list.d/i3-autobuild.list
echo 'Package: i3*' | sudo tee /etc/apt/preferences.d/00-i3-autobuild.pref
echo 'Pin: origin "dl.bintray.com"' | sudo tee -a /etc/apt/preferences.d/00-i3-autobuild.pref
echo 'Pin-Priority: 1001' | sudo tee -a /etc/apt/preferences.d/00-i3-autobuild.pref
apt update && apt -y install i3

apt -y install i3blocks
apt -y install rofi
apt -y install unclutter

# Install Network Manager to use nmcli for connnecting to wifi
apt -y install network-manager
systemctl enable NetworkManager.service

# Install thunar lxappearance arc-theme
apt -y install lxappearance thunar arc-theme

# Install GDM3 login manager
apt -y install gdm3

echo 'Reboot and then run install_2.sh :)'
