# Set up Kali linux on RPi 3 B+

After fork and adjust files we can run two commands:

1. `./RUN_LCD`
2. `./RUN_HDMI`

And we know everything will be working on `RPi 3 B+` and `kali-linux-2021.3`.

> Instructions below are related to the [original project](https://github.com/lcdwiki/LCD-show-kali).

## How to set up LCD 3.5" MPI3508

Used system `kali-linux-2021.3-rpi4-nexmon-arm64.img.xz`

1. Install kali on sd card using `balenaEtcher`
2. Create backup of config.txt file `sudo cp /boot/config.txt /boot/config.txt.bk`
3. Run kali (l: kali, p: kali) and connect with the Internet
4. Clone repo `git clone https://github.com/lcdwiki/LCD-show-kali`
5. Run command `cd LCD-show-kali && sudo ./LCD35-show`
- now RPi will reboot and show kernel error
1. Open SD card on the different computer and copy and replace code from `config.txt.bk` to `/boot/config.txt` without last section, which should be like this:

```
... rest of code from config.txt ...

# If you would like to enable USB booting on your Pi, uncomment the following line.
# Boot from microsd card with it, then reboot.
# Don't forget to comment this back out after using, especially if you plan to use
# sdcard with multiple machines!
# NOTE: This ONLY works with the Raspberry Pi 3+
#program_usb_boot_mode=1
hdmi_force_hotplug=1
dtparam=i2c_arm=on
dtparam=spi=on
enable_uart=1
dtoverlay=tft35a:rotate=270
```

7. Update packages `apt update`
- now rpi should works with TFT LCD 3.5
8. Instalal package for calibration `apt-get install xinput-calibrator`.
9.  Edit file `sudo nano /etc/X11/xorg.conf.d/99-calibration.conf` with configuration:

```
Section "InputClass"
    Identifier      "calibration"
    MatchProduct    "ADS7846 Touchscreen"
    Option  "Calibration"   "160 3723 3896 181"
	Option  "SwapAxes"	"1"
	Option	"TransformationMatrix"  "1 0 0 0 -1 1 0 0 1"
EndSection
```

10. Reboot system by: `reboot` command and be happy with your kali linux on LCD.

- To calibrate touch screen run command `xinput-calibrator`

- If you want back to HDMI connection run script `cd LCD-show-kali && sudo ./LCD35-show`

### Help

[LCD drivers for kali](https://github.com/lcdwiki/LCD-show-kali)

[LCD wiki](http://www.lcdwiki.com/3.5inch_RPi_Display)

[LCD manual](https://www.cedelettronica.com/documents/e2a2d148-c375-428b-8967-e431a3b949a6)
