#
# Raspberry Pi Pico W RP2040 (WiFi).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 03 Aug 2023
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 14 Mar 2025 release 14.7.4

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = rpipicow

# Program / File system
BOARD_TAG1 = rpipicow.menu.flash.2097152_1048576
# Speed nominal = 133
BOARD_TAG2 = rpipicow.menu.freq.200
# Debug port, requires TinyUSB
BOARD_TAG3 = rpipicow.menu.dbgport.Disabled
# BOARD_TAG3 = rpipicow.menu.dbgport.Serial
# Debug level
BOARD_TAG4 = rpipicow.menu.dbglvl.None
# USB stack, TinyUSB for Serial
# BOARD_TAG5 = rpipicow.menu.usbstack.tinyusb
BOARD_TAG5 = rpipicow.menu.usbstack.picosdk
# Stack protect, default = disabled
BOARD_TAG6 = rpipicow.menu.stackprotect.Disabled
# Exception, default = disabled
BOARD_TAG7 = rpipicow.menu.exceptions.Disabled
# Upload method
BOARD_TAG8 = rpipicow.menu.uploadmethod.picoprobe_cmsis_dap
# Country for WiFi
BOARD_TAG9 = rpipicow.menu.wificountry.worldwide
# WiFi and BLE
# rpipicow.menu.ipbtstack.ipv4only 			WiFi IPv4
# rpipicow.menu.ipbtstack.ipv4ipv6			WiFi IPv4 + IPv6
# rpipicow.menu.ipbtstack.ipv4btcble		WiFi IPv4 + BLE
# rpipicow.menu.ipbtstack.ipv4ipv6btcble	WiFi IPv4 + IPv6 + BLE
BOARD_TAG10 = rpipicow.menu.ipbtstack.ipv4btcble

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/cu.usbmodem*
# BOARD_PORT = /dev/cu.SLAB_USBtoUART
# Linux
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
UPLOADER = espota
# DELAY_BEFORE_UPLOAD = 5

# BOARD_VOLUME = /Volumes/FEATHERBOOT # macOS
# Linux
# BOARD_VOLUME = /media/$(USER)/RPI-RP2

# DELAY_BEFORE_SERIAL = 5

CONFIG_NAME = Raspberry Pi Pico W RP2040 (WiFi)
