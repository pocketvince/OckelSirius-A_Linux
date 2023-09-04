#!/bin/bash
# calibrate_touch_screen.sh Version 0.1
# 04/09/2023 - https://github.com/pocketvince/OckelSirius-A_Linux/
# Test made on Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-82-generic x86_64)
#
# Note:
# The script will try to detect  the position, and change the parameters.
# This first version contains a log, and must be added to the crontab (because after each rotation, it forgets the parameter).
# Also, the password lock has been removed, as it can't keep calibration when the screen is locked
# So this version of the script needs to be improved.

# Installation
# sudo apt-get update -y ; sudo apt-get upgrade -y
# sudo apt-get install xinput xinput-calibrator

#Unactive Lock
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'

#Loop
for ((i=1; i<=30; i++)); do

#Screen
username=$(who | awk -v vt="$DISPLAY" '$0 ~ vt {print $1}')
xauthority_path="/home/$username/.Xauthority"
export DISPLAY=:0
export XAUTHORITY=$xauthority_path

#Settings
previous_orientation=$(cat tmp_calibrate_touch_screen.txt)
device_id1=$(xinput list | awk -F= '/Goodix Capacitive TouchScreen/ {print $2}' | awk '{print $1}' | sed 's/id=//' | head -1)
device_id2=$(xinput list | awk -F= '/Goodix Capacitive TouchScreen/ {++count; if (count == 2) print $2}' | awk '{print $1}' | sed 's/id=//')
current_orientation=$(timeout 1 monitor-sensor | awk -F': ' '/=== Has accelerometer \(orientation:/ {print $2}' | sed 's/)//')

#Little Break
sleep 1

#Check if orientation change
#if [ "$current_orientation" == "$previous_orientation" ]; then
#    exit 0
#fi

#Update config
if [ "$current_orientation" == "right-up" ]; then
    xinput set-prop $device_id1 "Coordinate Transformation Matrix" 0, -1, 1, -1, 0, 1, 0, 0, 1
    xinput set-prop $device_id2 "Coordinate Transformation Matrix" 0, -1, 1, -1, 0, 1, 0, 0, 1
elif [ "$current_orientation" == "normal" ]; then
    xinput set-prop $device_id1 "Coordinate Transformation Matrix" 1, 0, 0, 0, -1, 1, 0, 0, 1
    xinput set-prop $device_id2 "Coordinate Transformation Matrix" 1, 0, 0, 0, -1, 1, 0, 0, 1
elif [ "$current_orientation" == "bottom-up" ]; then
    xinput set-prop $device_id1 "Coordinate Transformation Matrix" -1, 0, 1, 0, 1, 0, 0, 0, 1
    xinput set-prop $device_id2 "Coordinate Transformation Matrix" -1, 0, 1, 0, 1, 0, 0, 0, 1
elif [ "$current_orientation" == "left-up" ]; then
    xinput set-prop $device_id1 "Coordinate Transformation Matrix" 0, 1, 0, 1, 0, 0, 0, 0, 1
    xinput set-prop $device_id2 "Coordinate Transformation Matrix" 0, 1, 0, 1, 0, 0, 0, 0, 1
else
    echo "Orientation inconnue: $current_orientation"
    exit 1
fi

#Save Orientation
echo "$current_orientation" > tmp_calibrate_touch_screen.txt
date=$(date)
echo $date >> log.txt
done
