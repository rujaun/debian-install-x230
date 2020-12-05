#!/bin/bash

mkdir -p ~/.config/i3/
mkdir -p ~/.config/picom/
mkdir -p ~/.config/displays/

cp -r config/i3/* ~/.config/i3/
cp -r config/picom/* ~/.config/picom/
cp -r config/displays/* ~/.config/displays/

cp -r config/vim/.vimrc ~/.vimrc
cp -r config/.bashrc ~/.bashrc
cp -r config/.profile ~/.profile
sudo cp -r config/fonts/.local.conf /etc/fonts/.local.conf
sudo cp -r config/fonts/.fonts.conf ~/.fonts.conf

# Git
git config --global user.name "Rujaun Fourie"
git config --global user.email rujaun@gmail.com
git config --global pull.rebase false

sudo mkdir /usr/share/fonts/CoreFonts
sudo cp ./core-fonts/* /usr/share/fonts/CoreFonts/
sudo chmod 644 /usr/share/fonts/CoreFonts/*
fc-cache -f -v

sudo mkdir /usr/share/fonts/WinFonts
sudo cp ./WinFonts/* /usr/share/fonts/WinFonts/
sudo chmod 644 /usr/share/fonts/WinFonts/*
fc-cache -f -v