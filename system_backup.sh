#!/bin/bash
if [ ! -d "./.system_backup" ]; then
sudo mkdir ./.system_backup
fi

sudo rm -rf ./.system_backup/*

if [ -f /etc/X11/xorg.conf.d/99-calibration.conf ]; then
sudo cp -rf /etc/X11/xorg.conf.d/99-calibration.conf ./.system_backup
sudo rm -rf /etc/X11/xorg.conf.d/99-calibration.conf
fi

if [ -f /etc/X11/xorg.conf.d/40-libinput.conf ]; then
sudo cp -rf /etc/X11/xorg.conf.d/40-libinput.conf ./.system_backup
sudo rm -rf /etc/X11/xorg.conf.d/40-libinput.conf
fi

if [ -d /etc/X11/xorg.conf.d ]; then
sudo mkdir -p ./.system_backup/xorg.conf.d
sudo rm -rf /etc/X11/xorg.conf.d
fi

result=`grep -rn "^dtoverlay=" /boot/config.txt | grep ":rotate=" | tail -n 1`
if [ $? -eq 0 ]; then
str=`echo -n $result | awk -F: '{printf $2}' | awk -F= '{printf $NF}'`
if [ -f /boot/overlays/$str-overlay.dtb ]; then
sudo cp -rf /boot/overlays/$str-overlay.dtb ./.system_backup
sudo rm -rf /boot/overlays/$str-overlay.dtb
fi
if [ -f /boot/overlays/$str.dtbo ]; then
sudo cp -rf /boot/overlays/$str.dtbo ./.system_backup
sudo rm -rf /boot/overlays/$str.dtbo
fi
fi

sudo cp -rf /boot/config.txt ./.system_backup
sudo cp -rf ./boot/config-default.txt /boot/config.txt
sudo cp -rf /boot/cmdline.txt ./.system_backup/
sudo cp -rf ./usr/cmdline.txt-original /boot/cmdline.txt

if [ -f /usr/share/X11/xorg.conf.d/99-fbturbo.conf ]; then
sudo cp -rf /usr/share/X11/xorg.conf.d/99-fbturbo.conf ./.system_backup
sudo rm -rf /usr/share/X11/xorg.conf.d/99-fbturbo.conf
fi

if [ -f /etc/rc.local ]; then
sudo cp -rf /etc/rc.local ./.system_backup
sudo rm -rf /etc/rc.local
fi

type fbcp > /dev/null 2>&1
if [ $? -eq 0 ]; then
sudo touch ./.system_backup/have_fbcp
sudo rm -rf /usr/local/bin/fbcp
fi

if [ -f /usr/share/X11/xorg.conf.d/10-evdev.conf ]; then
sudo cp -rf /usr/share/X11/xorg.conf.d/10-evdev.conf ./.system_backup
fi

if [ -f /usr/share/X11/xorg.conf.d/45-evdev.conf ]; then
sudo cp -rf /usr/share/X11/xorg.conf.d/45-evdev.conf ./.system_backup
sudo rm -rf /usr/share/X11/xorg.conf.d/45-evdev.conf
fi

if [ -f ./.have_installed ]; then
sudo cp -rf ./.have_installed ./.system_backup
sudo rm -rf ./.have_installed
fi
