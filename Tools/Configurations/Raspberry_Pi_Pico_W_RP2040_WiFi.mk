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
# Copyright: (c) 2010-2023 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 03 Aug 2023 release 14.1.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = rpipicow

# Program / File system
BOARD_TAG1 = rpipicow.menu.flash.2097152_1048576
# Speed nominal = 133
BOARD_TAG2 = rpipicow.menu.freq.125
# Debug port, requires TinyUSB
BOARD_TAG3 = rpipicow.menu.dbgport.Disabled
# BOARD_TAG3 = rpipicow.menu.dbgport.Serial
# Debug level
BOARD_TAG4 = rpipicow.menu.dbglvl.None
# USB stack, TinyUSB for Serial
# BOARD_TAG5 = rpipicow.menu.usbstack.tinyusb
BOARD_TAG5 = rpipicow.menu.usbstack.picosdk
# Stack protect, default = disabled
BOARD_TAG6 = rpipicow.menu.stackprotect.Disabled
# Exception, default = disabled
BOARD_TAG7 = rpipicow.menu.exceptions.Disabled
# Upload method
BOARD_TAG8 = rpipicow.menu.uploadmethod.default

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
