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
cp sources.list /etc/apt/sources.list

apt update && apt -y install -t buster-backports linux-image-amd64 linux-headers-amd64 firmware-linux firmware-linux-nonfree vim htop neofetch

# Enable Trim support for SSDs
systemctl enable fstrim.trimer

# Install ly login manager
apt -y install build-essential libpam0g-dev libxcb-xkb-dev
git clone https://github.com/nullgemm/ly.git
cd ly
make github
make
make install
systemctl enable ly.service

cd ..

# Install Xorg
apt -y install xorg xinit xserver-xorg-video-intel xterm xbacklight

# Install i3wm
/usr/lib/apt/apt-helper download-file http://dl.bintray.com/i3/i3-autobuild/pool/main/i/i3-autobuild-keyring/i3-autobuild-keyring_2016.10.01_all.deb keyring.deb SHA256:460e8c7f67a6ae7c3996cc8a5915548fe2fee9637b1653353ec62b954978d844
apt install ./keyring.deb
echo 'deb http://dl.bintray.com/i3/i3-autobuild sid main' | sudo tee /etc/apt/sources.list.d/i3-autobuild.list
echo 'Package: i3*' | sudo tee /etc/apt/preferences.d/00-i3-autobuild.pref
echo 'Pin: origin "dl.bintray.com"' | sudo tee -a /etc/apt/preferences.d/00-i3-autobuild.pref
echo 'Pin-Priority: 1001' | sudo tee -a /etc/apt/preferences.d/00-i3-autobuild.pref
apt update && apt -y install i3 i3blocks rofi 

# Install Network Manager to use nmcli for connnecting to wifi
apt -y install network-manager
systemctl enable NetworkManager.service

# Install thunar lxappearance arc-theme
apt -y install lxappearance thunar arc-theme

# Remove unneeded kernel packages after backports upgrade and do full system upgrade
apt update && apt -y autoremove && apt -y dist-upgrade

echo 'Reboot! :)'
