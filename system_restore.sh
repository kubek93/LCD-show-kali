#!/bin/bash
#Just finished the system, no need to restore
if [ ! -d "./.system_backup" ]; then
echo "The system is the original version and does not need to be restored"
exit
fi

if [ -d /etc/X11/xorg.conf.d ]; then
sudo rm -rf /etc/X11/xorg.conf.d
fi
if [ -d ./.system_backup/xorg.conf.d ]; then
sudo cp -rf ./.system_backup/xorg.conf.d /etc/X11
if [ -f ./.system_backup/99-calibration.conf ]; then
sudo cp -rf ./.system_backup/99-calibration.conf /etc/X11/xorg.conf.d
fi
if [ -f ./.system_backup/40-libinput.conf ]; then
sudo cp -rf ./.system_backup/40-libinput.conf /etc/X11/xorg.conf.d
fi
fi

result=`grep -rn "^dtoverlay=" /boot/config.txt | grep ":rotate=" | tail -n 1`
if [ $? -eq 0 ]; then
str=`echo -n $result | awk -F: '{printf $2}' | awk -F= '{printf $NF}'`
sudo rm -rf /boot/overlays/$str-overlay.dtb
sudo rm -rf /boot/overlays/$str.dtbo
fi
ls -al ./.system_backup/*.dtb > /dev/null 2>&1 && sudo cp -rf ./.system_backup/*.dtb  /boot/overlays/
ls -al ./.system_backup/*.dtbo > /dev/null 2>&1 && sudo cp -rf ./.system_backup/*.dtbo  /boot/overlays/

#sudo cp -rf ./.system_backup/99-fbturbo.conf /usr/share/X11/xorg.conf.d
sudo cp -rf ./.system_backup/cmdline.txt /boot/
sudo cp -rf ./.system_backup/config.txt /boot/
#sudo cp -rf ./.system_backup/inittab /etc/

if [ -f /usr/share/X11/xorg.conf.d/99-fbturbo.conf ]; then
sudo rm -rf /usr/share/X11/xorg.conf.d/99-fbturbo.conf
fi
if [ -f ./.system_backup/99-fbturbo.conf ]; then
sudo cp -rf ./.system_backup/99-fbturbo.conf  /usr/share/X11/xorg.conf.d
fi

if [ -f /etc/rc.local ]; then
sudo rm -rf /etc/rc.local
fi
if [ -f ./.system_backup/rc.local ]; then
sudo cp -rf ./.system_backup/rc.local  /etc
fi

type fbcp > /dev/null 2>&1
if [ $? -eq 0 ]; then
sudo rm -rf /usr/local/bin/fbcp
fi
if [ -f ./.system_backup/have_fbcp ]; then
sudo install ./rpi-fbcp/build/fbcp /usr/local/bin/fbcp
fi

if [ -f /usr/share/X11/xorg.conf.d/45-evdev.conf ]; then
sudo rm -rf /usr/share/X11/xorg.conf.d/45-evdev.conf
fi
if [ -f ./.system_backup/45-evdev.conf ]; then
sudo cp -rf ./.system_backup/45-evdev.conf /usr/share/X11/xorg.conf.d
fi

if [ -f ./.have_installed ]; then
sudo rm -rf ./.have_installed
fi
if [ -f ./.system_backup/.have_installed ]; then
sudo cp -rf ./.system_backup/.have_installed ./
fi

sudo sync
sudo sync

echo "The system has been restored"
echo "now reboot"
sleep 1

sudo reboot
