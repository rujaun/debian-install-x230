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
apt -y install hsetroot

# Install Network Manager to use nmcli for connnecting to wifi
apt -y install network-manager
systemctl enable NetworkManager.service

# Make systemd ignore lid suspend if power is on AC
echo 'HandleLidSwitchExternalPower=ignore' | sudo tee /etc/systemd/logind.conf

# Disable all methods of sleep with systemd auto sleep
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Install thunar kvantum lxappearance arc-theme
apt -y install qt5-style-kvantum qt5-style-kvantum-themes lxappearance thunar arc-theme arandr playerctl breeze qt5ct acpi

# Install solaar for logitech mouse
apt -y install -t buster-backports solaar

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

# Install Papirus icons
apt -y install dirmngr
echo "deb http://ppa.launchpad.net/papirus/papirus/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/papirus-ppa.list
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com E58A9D36647CAE7F
apt update && apt -y install papirus-icon-theme

# Install pulseaudio
apt -y install pulseaudio pulseaudio-utils

# Install Gnome keyring
apt -y install gnome-keyring libsecret-1-0 seahorse

# Enable keyring for pam/gdm3
echo "password optional pam_gnome_keyring.so" | sudo tee -a /etc/pam.d/passwd

# Cleanup
apt -y autoremove

# Install sqlitebrowser
apt -y install -t buster-backports sqlitebrowser

# Install dbeaver-ce
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
apt -y update && apt -y install dbeaver-ce

# Install vscodium
# wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
# echo 'deb [signed-by=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
# apt -y update
# apt -y install codium

# Install Sublime Text
# wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
# apt -y install apt-transport-https
# echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
# apt update
# apt -y install sublime-text

# Install Geany
apt -y install -t buster-backports geany

# Install zotero
wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
apt -y update
apt -y install zotero

# Install compression tools
apt -y install bzip2 gzip lzip xz-utils p7zip unrar zip unzip

# Install ntfs and exfat support
apt -y install ntfs-3g exfat-utils

# Install a few apps
apt -y install firefox-esr chromium krita persepolis transmission

# Install libreoffice
apt -y install -t buster-backports libreoffice libreoffice-gtk3

# Install a few math applications
apt -y install -t buster-backports geogebra kmplot cantor kalgebra labplot

# Install spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update && apt -y install spotify-client
ln -s /usr/share/spotify/spotify.desktop /usr/share/applications/

# Install 1Password
sudo apt-key --keyring /usr/share/keyrings/1password.gpg adv --keyserver keyserver.ubuntu.com --recv-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password.gpg] https://downloads.1password.com/linux/debian edge main' | sudo tee /etc/apt/sources.list.d/1password.list
apt update && apt -y install 1password

# Install GDM3 login manager
apt -y install gdm3

sudo cp -r config/fonts/.local.conf /etc/fonts/.local.conf
sudo cp -r config/fonts/.fonts.conf /home/rujaun/.fonts.conf

sudo mkdir /usr/share/fonts/CoreFonts
sudo cp ./core-fonts/* /usr/share/fonts/CoreFonts/
sudo chmod 644 /usr/share/fonts/CoreFonts/*
fc-cache -f -v

# Install xscreensaver
apt -y install xscreensaver xscreensaver-gl-extra xscreensaver-data-extra xscreensaver-screensaver-bsod

# Install timetracking for harvest
wget https://github.com/frenkel/timer-for-harvest/releases/download/v0.3.3/debian-10-timer-for-harvest_0.3.3_amd64.deb
sudo dpkg -i ./debian-10-timer-for-harvest_0.3.3_amd64.deb

# Install the latest rust compiler
apt -y install cmake curl pkg-config libfreetype6-dev libfontconfig libfontconfig1-dev libxcb-xfixes0-dev python3
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
rustup override set stable
rustup update stable

## Custom Compiled Apps:
cd /home/rujaun/
mkdir Compiled
cd Compiled/

# Build picom
cd /home/rujaun/Compiled/
apt -y install cmake libev-dev libpcre++-dev meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev  libpcre2-dev  libevdev-dev uthash-dev libev-dev libx11-xcb-dev
git clone https://github.com/yshui/picom.git
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
sudo ninja -C build install

# Compile and install alacritty
cd /home/rujaun/Compiled/
git clone https://github.com/alacritty/alacritty.git --branch v0.6.0 --single-branch
cd alacritty
cargo build --release
cp target/release/alacritty /usr/local/bin
cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
# mkdir -p /home/rujaun/.bash_completion/
# cp extra/completions/alacritty.bash /home/rujaun/.bash_completion/alacritty
# echo "source ~/.bash_completion/alacritty" >> ~/.bashrc

# Compile foliate ebook reader
cd /home/rujaun/Compiled/
apt -y install -t buster-backports gir1.2-handy-0.0
apt -y install gjs gir1.2-webkit2-4.0 meson gettext iso-codes appstream-util libglib2.0-dev 
git clone https://github.com/johnfactotum/foliate.git --branch 2.5.0 --single-branch
cd foliate
meson build --prefix=/usr
ninja -C build
sudo ninja -C build install

# Install Tela Icons:
cd /home/rujaun/Compiled/
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
./install.sh

# Install Zafiro-icons:
cd /home/rujaun/Compiled/
git clone https://github.com/zayronxio/Zafiro-icons.git
sudo cp -R Zafiro-icons/ /usr/share/icons/Zafiro-icons

echo 'Run install_non_root.sh outside of root and reboot :)'
