#
# Microsoft IoT DevKit (USB).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 15 Jun 2017
# Copyright: (c) Rei Vilo, 2010-2024 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 25 Sep 2018 release 10.0.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = MXCHIP_AZ3166

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
# Note: if /dev/tty.usbserial* doesn't work, try /dev/tty.usbmodem*
#
# BOARD_PORT = /dev/tty.usbserial*
# BOARD_PORT = /dev/tty.usbmodem* # macOS
# Linux
BOARD_PORT = /dev/ttyACM* 

# Warning: some users have reported /dev/cu.usb*

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ARDUINO_MXCHIP_AZ3166 ARDUINO MICROSOFT

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/AZ3166/hardware/stm32f4/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 98304

UPLOADER = openocd

CONFIG_NAME = Microsoft IoT DevKit (USB)
