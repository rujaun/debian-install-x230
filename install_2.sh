#!/bin/bash

# Remove unneeded kernel packages after backports upgrade and do full system upgrade
apt update && apt -y autoremove && apt -y dist-upgrade

# Install acpi-call-dkms, lm-sensors, read-edid, i2c-tools for tlp and thinkfan
apt -y install -t buster-backports acpi-call-dkms lm-sensors read-edid i2c-tools openssh-client

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
cp config/thinkfan.conf /etc/thinkfan.conf

sudo modprobe -rv thinkpad_acpi
sudo modprobe -v thinkpad_acpi

# Replace thinkfan service with service that includes -D switch
rm /lib/systemd/system/thinkfan.service
cp config/thinkfan.service /lib/systemd/system/thinkfan.service

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
  Identifier  "Intel Graphics"
  Driver  "intel"
  
  Option  "AccelMethod""sna"
  Option  "TearFree""true"
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
# sudo dpkg-reconfigure tzdata

# Install python 3
apt -y install -t buster-backports python3 python3-pip python3-wheel python3-venv

# Install mesa
sudo dpkg --add-architecture i386

apt update && apt -y dist-upgrade
apt -y install -t buster-backports libgl1-mesa-dri:i386 mesa-vulkan-drivers mesa-vulkan-drivers:i386


# Build picom
apt -y install cmake libev-dev libpcre++-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
git clone https://github.com/yshui/picom.git
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install

cd ..

# Install pulseaudio
apt -y install pulseaudio pulseaudio-utils

# Install Gnome keyring
apt -y install gnome-keyring libsecret-1-0 seahorse

# Enable keyring for pam/gdm3
echo "password optional pam_gnome_keyring.so" | sudo tee -a /etc/pam.d/passwd

# Install Tela Icons:
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
./install.sh

# Install Zafiro-icons:
cd ..
git clone https://github.com/zayronxio/Zafiro-icons.git
sudo cp -R Zafiro-icons/ /usr/share/icons/Zafiro-icons

# Install Papirus icons
apt -y install dirmngr
echo "deb http://ppa.launchpad.net/papirus/papirus/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/papirus-ppa.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com E58A9D36647CAE7F
apt update && apt -y install papirus-icon-theme

# Cleanup
apt -y autoremove

echo 'Reboot and then run install_3.sh :)'
