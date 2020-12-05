#!/bin/bash

# Install acpi-call-dkms, lm-sensors, read-edid, i2c-tools for tlp and thinkfan
apt -y install -t buster-backports acpi-call-dkms lm-sensors read-edid i2c-tools

yes "" | sudo sensors-detect

# Install tlp
apt -y install -t buster-backports tlp

# Uncomment BAT thresholds
sed -i '/#START_CHARGE_THRESH_BAT0=75$/s/^#//g' /etc/tlp.conf
sed -i '/#STOP_CHARGE_THRESH_BAT0=80$/s/^#//g' /etc/tlp.conf

# Enable and start tlp service
systemctl enable tlp.service
systemctl start tlp.service

# Install thinkfan
apt -y install -t buster-backports thinkfan

# Enable Thinkfan with experimental=1 in modprobe
echo 'options thinkpad_acpi fan_control=1 experimental=1' | sudo tee /etc/modprobe.d/thinkfan.conf

# Copy the Thinkfan config
rm /etc/thinkfan.conf
cp thinkfan.conf /etc/thinkfan.conf

sudo modprobe -rv thinkpad_acpi
sudo modprobe -v thinkpad_acpi

# Replace thinkfan service with service that includes -D switch
rm /lib/systemd/system/thinkfan.service
cp thinkfan.service /lib/systemd/system/thinkfan.service

# Enable thinkfan service
systemctl enable thinkfan

# Add backlight control and tear free sna intel driver options
sudo tee -a /usr/share/X11/xorg.conf.d/20-intel.conf <<EOF
Section "Device"
    Identifier      "Device0"
    Driver          "intel"
    Option          "Backlight"      "intel_backlight"
EndSection

Section "Monitor"
    Identifier      "Monitor0"
EndSection

Section "Screen"
    Identifier      "Screen0"
    Monitor         "Monitor0"
    Device          "Device0"
EndSection

Section "Device"
	Identifier		"Intel Graphics"
	Driver 			"intel"
  
	Option 			"AccelMethod"  		"sna"
	Option 			"TearFree" 			"true"
EndSection

EOF

# Disable touchpad while typing
sudo tee -a /usr/share/X11/xorg.conf.d/80-touchpad.conf <<EOF
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
 Option "DisableWhileTyping" "true"
EndSection

EOF

# Configure timezone
sudo dpkg-reconfigure tzdata

# Install python 3
apt -y install -t buster-backports python3 python3-pip python3-wheel python3-venv

# Install mesa
sudo dpkg --add-architecture i386

apt update && apt -y dist-upgrade
apt -y install -t buster-backports libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386


# Build picom
sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
git clone https://github.com/yshui/picom.git
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install

cd ..

# Install pulseaudio
apt -y install pulseaudio pulseaudio-utils

# Install Gnome keyring
apt -y install gnome-keyring libsecret seahorse

# Start gnome-keyring with pam
sed -i '37iauth optional pam_gnome_keyring.so' /etc/pam.d/login
sed -i '65isession optional pam_gnome_keyring.so auto_start' /etc/pam.d/login

# Start SSH and Secrets components of keyring daemon
cp /etc/xdg/autostart/{gnome-keyring-secrets.desktop,gnome-keyring-ssh.desktop} ~/.config/autostart/
sed -i '/^OnlyShowIn.*$/d' ~/.config/autostart/gnome-keyring-secrets.desktop
sed -i '/^OnlyShowIn.*$/d' ~/.config/autostart/gnome-keyring-ssh.desktop