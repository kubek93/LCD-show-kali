# Set up Kali linux on RPi 3 B+

> Instructions below are related with the [original project](https://github.com/lcdwiki/LCD-show-kali).

After fork and adjust files we can run two commands:

1. `./RUN_LCD`
2. `./RUN_HDMI`

And we know everything will be working on RPi 3 B+ and kali-linux-2021.3

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

### FILES

[LCD drivers for kali](https://github.com/lcdwiki/LCD-show-kali)

[LCD wiki](http://www.lcdwiki.com/3.5inch_RPi_Display)

[LCD manual](https://www.cedelettronica.com/documents/e2a2d148-c375-428b-8967-e431a3b949a6)

### Default config.txt kali linux file for RPi 3 B+

```
# For more options and information see
# http://rpf.io/configtxt
# Some settings may impact device functionality. See link above for details

# uncomment if you get no picture on HDMI for a default "safe" mode
#hdmi_safe=1

# uncomment this if your display has a black border of unused pixels visible
# and your display can output without overscan
#disable_overscan=1

# uncomment the following to adjust overscan. Use positive numbers if console
# goes off screen, and negative if there is too much border
#overscan_left=16
#overscan_right=16
#overscan_top=16
#overscan_bottom=16

# uncomment to force a console size. By default it will be display's size minus
# overscan.
#framebuffer_width=1280
#framebuffer_height=720

# uncomment if hdmi display is not detected and composite is being output
#hdmi_force_hotplug=1

# uncomment to force a specific HDMI mode (this will force VGA)
#hdmi_group=1
#hdmi_mode=1

# uncomment to force a HDMI mode rather than DVI. This can make audio work in
# DMT (computer monitor) modes
#hdmi_drive=2

# uncomment to increase signal to HDMI, if you have interference, blanking, or
# no display
#config_hdmi_boost=4

# uncomment for composite PAL
#sdtv_mode=2

#uncomment to overclock the arm. 700 MHz is the default.
#arm_freq=800

# Uncomment some or all of these to enable the optional hardware interfaces
#dtparam=i2c_arm=on
#dtparam=i2s=on
#dtparam=spi=on

# Uncomment this to enable infrared communication.
#dtoverlay=gpio-ir,gpio_pin=17
#dtoverlay=gpio-ir-tx,gpio_pin=18

# Additional overlays and parameters are documented /boot/overlays/README

# Enable audio (loads snd_bcm2835)
dtparam=audio=on

# USB mass storage boot is available on Raspberry Pi 2B v1.2, 3A+, 3B, and 3B+ only.
#program_usb_boot_mode=1

[pi2]
# Pi2 is 64bit only on v1.2+
# 64bit kernel for Raspberry Pi 2 is called kernel8 (armv8a)
kernel=kernel8-alt.img
[pi3]
# 64bit kernel for Raspberry Pi 3 is called kernel8 (armv8a)
kernel=kernel8-alt.img
[pi4]
# Enable DRM VC4 V3D driver on top of the dispmanx display stack
#dtoverlay=vc4-fkms-v3d
#max_framebuffers=2
# 64bit kernel for Raspberry Pi 4 is called kernel8l (armv8a)
kernel=kernel8l-alt.img
[all]
#dtoverlay=vc4-fkms-v3d
# Tell firmware to go 64bit mode.
arm_64bit=1
```
