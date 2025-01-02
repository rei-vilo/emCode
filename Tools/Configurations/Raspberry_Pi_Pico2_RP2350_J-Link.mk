#
# Raspberry Pi Pico2 RP2350 (J-Link).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo 
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Created: 26 Aug 2024 release 14.5.0
# 
# Last update: 03 Oct 2024 release 14.5.5
# 

# Declare udev for Linux
# echo 'SUBSYSTEMS = = "usb", ATTRS{idVendor} = = "2e8a", ATTRS{idProduct} = = "0004", GROUP = "users", MODE = "0666"' | sudo tee -a /etc/udev/rules.d/98-DebugProbe.rules
# sudo udevadm control --reload

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = rpipico2
# Program / File system
BOARD_TAG1 = rpipico2.menu.flash.4194304_0
# Speed nominal = 133
BOARD_TAG2 = rpipico2.menu.freq.150
# Debug port, requires TinyUSB
BOARD_TAG3 = rpipico2.menu.dbgport.Disabled
# BOARD_TAG3 = rpipico2.menu.dbgport.Serial
# Debug level
BOARD_TAG4 = rpipico2.menu.dbglvl.None
# USB stack, TinyUSB for Serial
# BOARD_TAG5 = rpipico2.menu.usbstack.tinyusb
BOARD_TAG5 = rpipico2.menu.usbstack.picosdk
# Stack protect, default = disabled
BOARD_TAG6 = rpipico2.menu.stackprotect.Disabled
# Exception, default = disabled
BOARD_TAG7 = rpipico2.menu.exceptions.Disabled
# Upload method
BOARD_TAG8 = rpipico2.menu.uploadmethod.picotool
# Country for WiFi
BOARD_TAG9 = rpipicow2.menu.wificountry.worldwide
# WiFi and BLE
# rpipicow.menu.ipbtstack.ipv4only 			WiFi IPv4 
# rpipicow.menu.ipbtstack.ipv4ipv6			WiFi IPv4 + IPv6
# rpipicow.menu.ipbtstack.ipv4btcble		WiFi IPv4 + BLE
# rpipicow.menu.ipbtstack.ipv4ipv6btcble	WiFi IPv4 + IPv6 + BLE
BOARD_TAG10 = rpipico2.menu.ipbtstack.ipv4only

# For RP2350, selection of ARM or RiscV
BOARD_TAG11 = rpipico2.menu.arch.arm

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/cu.usbmodem*
# BOARD_PORT = /dev/cu.SLAB_USBtoUART
BOARD_PORT = /dev/ttyACM0

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/rp2040/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 65536

# Specific programmer options, no port
#
UPLOADER = jlink
# DELAY_BEFORE_UPLOAD = 5

# BOARD_VOLUME = /Volumes/FEATHERBOOT # macOS
# Linux
# BOARD_VOLUME = /media/$(USER)/RPI-RP2

# # MCU for AVRDUDE
# # If not specified, AVRDUDE_MCU = value from boards.txt
# # 
# AVRDUDE_MCU = atmega328
# 
# # Although compatible, the actual MCU may have a different speed.
# # If not specified, F_CPU = value from boards.txt
# # 
# # F_CPU = 16000000L
# 
# # Fuses for AVRDUDE
# # To by-pass fuses, set AVR_IGNORE_FUSES = 1 otherwise AVR_IGNORE_FUSES = 0
# # AVR_IGNORE_FUSES = 1
# 
# # Define fuses, only if different from default values
# # ISP_LOCK_FUSE_PRE ISP_LOCK_FUSE_POST ISP_HIGH_FUSE ISP_LOW_FUSE ISP_EXT_FUSE
# 
# MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME)

DELAY_BEFORE_SERIAL = 5

CONFIG_NAME = Raspberry Pi Pico2 RP2350 (J-Link)
