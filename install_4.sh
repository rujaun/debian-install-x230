#!/bin/bash

mkdir -p ~/.config/i3/
mkdir -p ~/.config/picom/
mkdir -p ~/.config/displays/

cp -r config/i3/* ~/.config/i3/
cp -r config/picom/* ~/.config/picom/
cp -r config/displays/* ~/.config/displays/

cp -r config/vim/.vimrc ~/.vimrc
cp -r config/tmux/.tmux.conf ~/.tmux.conf

cp -r config/.bashrc ~/.bashrc
cp -r config/.profile ~/.profile
sudo cp -r config/fonts/.local.conf /etc/fonts/.local.conf
sudo cp -r config/fonts/.fonts.conf ~/.fonts.conf

cp config/alacritty/.alacritty.yml ~/.alacritty.yml

# Git
git config --global user.name "Rujaun Fourie"
git config --global user.email rujaun@gmail.com
git config --global pull.rebase false

sudo mkdir /usr/share/fonts/CoreFonts
sudo cp ./core-fonts/* /usr/share/fonts/CoreFonts/
sudo chmod 644 /usr/share/fonts/CoreFonts/*
fc-cache -f -v