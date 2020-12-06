#!/bin/bash

cp BCM20702A1-0a5c-21e6.hcd /lib/firmware/brcm/
sudo modprobe -r btusb
sudo modprobe btusb
sudo system systemctl restart bluetooth

sudo apt -y install bluetooth pulseaudio-module-bluetooth blueman bluez-firmware bluewho