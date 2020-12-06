#!/bin/bash

sudo cp -r config/fonts/.local.conf /etc/fonts/.local.conf
sudo cp -r config/fonts/.fonts.conf ~/.fonts.conf

sudo mkdir /usr/share/fonts/CoreFonts
sudo cp ./core-fonts/* /usr/share/fonts/CoreFonts/
sudo chmod 644 /usr/share/fonts/CoreFonts/*
fc-cache -f -v