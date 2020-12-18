#!/bin/bash

mkdir -p ~/.config/i3/
mkdir -p ~/.config/picom/
mkdir -p ~/.config/displays/
mkdir -p ~/.config/i3blocks/
mkdir -p ~/.config/i3blocks-modules/
mkdir -p ~/.config/rofi/
mkdir -p ~/.config/dpms/

cp -r config/i3/* ~/.config/i3/
cp -r config/i3blocks/* ~/.config/i3blocks/
cp -r config/i3blocks-modules/* ~/.config/i3blocks-modules/
cp -r config/rofi/* ~/.config/rofi/
cp -r config/picom/* ~/.config/picom/
cp -r config/displays/* ~/.config/displays/
cp -r config/dpms/* ~/.config/dpms/
cp -r config/vim/.vimrc ~/.vimrc
cp -r config/tmux/.tmux.conf ~/.tmux.conf
cp -r config/.bashrc ~/.bashrc
cp -r config/.profile ~/.profile
cp config/alacritty/.alacritty.yml ~/.alacritty.yml
cp config/starship.toml ~/.config/.starship.toml


# Git
git config --global user.name "Rujaun Fourie"
git config --global user.email rujaun@gmail.com
git config --global pull.rebase false

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install TPM for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

wget https://starship.rs/install.sh
./install.sh

git clone https://github.com/geany/geany-themes.git
cd geany-themes
./install.sh

cd ..

git clone https://github.com/Betelgeuse1/NordThemeGeany.git
cd NordThemeGeany
./nord

python3 -m pip install i3blocks-spotify-persist
