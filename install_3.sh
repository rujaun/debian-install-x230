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

# Install zotero
wget -qO- https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
apt -y update
apt -y install zotero

# Install compression tools
apt -y install bzip2 gzip lzip xz-utils p7zip unrar zip unzip

# Install ntfs and exfat support
apt -y install ntfs-3g exfat-utils

# Install openssh
apt -y install openssh

# Install a few apps
apt -y install firefox-esr chromium krita persepolis transmission

# Install libreoffice
apt -y install -t buster-backports libreoffice

# Install a few math applications
apt -y install -t buster-backports geogebra kmplot cantor kalgebra labplot

# Compile foliate ebook reader
apt -y install gjs gir1.2-webkit2-4.0 meson gettext iso-codes libhandy
git clone https://github.com/johnfactotum/foliate.git --branch 2.5.0 --single-branch
cd foliate
meson build --prefix=/usr
ninja -C build
sudo ninja -C build install
cd ..

# Compile and install alacritty
apt -y install cmake curl pkg-config libfreetype6-dev libfontconfig libfontconfig1-dev libxcb-xfixes0-dev python3
curl https://sh.rustup.rs -sSd | sh
rustup override set stable
rustup update stable

git clone https://github.com/alacritty/alacritty.git --branch v0.6.0 --single-branch
cd alacritty
cargo build --release
cp target/release/alacritty /usr/local/bin
cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
mkdir -p ~/.bash_completion
cp extra/completions/alacritty.bash ~/.bash_completion/alacritty
#echo "source ~/.bash_completion/alacritty" >> ~/.bashrc
cd ..

# Install spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update && apt -y install spotify-client