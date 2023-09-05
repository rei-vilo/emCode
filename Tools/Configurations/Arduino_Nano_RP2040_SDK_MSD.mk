#
# Arduino Nano RP2040 SDK MSD.mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 20 Jul 2021
# Copyright: (c) 2010-2023 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 28 Apr 2021 release 11.14.4

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = pico
# Program / File system
BOARD_TAG1 = arduino_nano_connect.menu.flash.16777216_0
# Speed nominal = 133
BOARD_TAG2 = arduino_nano_connect.menu.freq.125
# Serial port, requires TinyUSB
BOARD_TAG3 = arduino_nano_connect.menu.dbgport.Disabled
# BOARD_TAG3 = arduino_nano_connect.menu.dbgport.Serial
# Debug level
BOARD_TAG4 = arduino_nano_connect.menu.dbglvl.None
# USB stack, TinyUSB for Serial
# BOARD_TAG5 = arduino_nano_connect.menu.usbstack.tinyusb
BOARD_TAG5 = arduino_nano_connect.menu.usbstack.picosdk

# For Arduino 1.5.x, if different from Arduino 1.0.x
#
# BOARD_TAG1 = nano
# BOARD_TAG2 = nano.menu.cpu.atmega168

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
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/mbed/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 65536

# Specific programmer options, no port
#
UPLOADER = cp_uf2
DELAY_BEFORE_UPLOAD = 5

# BOARD_VOLUME = /Volumes/FEATHERBOOT # macOS
# Linux
BOARD_VOLUME = /media/reivilo/RPI-RP2

MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME).

DELAY_BEFORE_SERIAL = 5

CONFIG_NAME = Arduino Nano RP2040 SDK MSD
