#!/bin/bash

# Install sqlitebrowser
apt -y install -t buster-backports sqlitebrowser

# Install dbeaver-ce
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
apt -y update && apt -y install dbeaver-ce

# Install vscodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/vscodium-archive-keyring.gpg] https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
apt -y update
apt -y install codium

# Install Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
apt -y install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt update
apt -y install sublime-text

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

# Compile foliate ebook reader
apt -y install -t buster-backports gir1.2-handy-0.0
apt -y install gjs gir1.2-webkit2-4.0 meson gettext iso-codes appstream-util libglib2.0-dev 
git clone https://github.com/johnfactotum/foliate.git --branch 2.5.0 --single-branch
cd foliate
meson build --prefix=/usr
ninja -C build
sudo ninja -C build install
cd ..

# Install the latest rust compiler
apt -y install cmake curl pkg-config libfreetype6-dev libfontconfig libfontconfig1-dev libxcb-xfixes0-dev python3
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
rustup override set stable
rustup update stable

# Compile and install alacritty
git clone https://github.com/alacritty/alacritty.git --branch v0.6.0 --single-branch
cd alacritty
cargo build --release
cp target/release/alacritty /usr/local/bin
cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
mkdir -p /home/rujaun/.bash_completion/
cp extra/completions/alacritty.bash /home/rujaun/.bash_completion/alacritty
#echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
cd ..

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

echo 'Reboot and then run install_4.sh :)'
