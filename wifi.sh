#!/bin/bash
# Wifi.sh Version 0.1
# 04/09/2023 - https://github.com/pocketvince/OckelSirius-A_Linux/
# Test made on Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-82-generic x86_64)
wget "https://github.com/pocketvince/OckelSirius-A_Linux/blob/main/brcmfmac43455-sdio.txt"
sudo cp brcmfmac43455-sdio.txt /lib/firmware/brcm/
echo Please Restart
sleep 10
sudo reboot
