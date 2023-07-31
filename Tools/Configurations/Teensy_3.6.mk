#
# Teensy 3.6.mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 04 Sep 2016
# Copyright: (c) 2010-2023 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 19 Nov 2022 release 12.1.16

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = teensy36

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/tty.usbmodem* # macOS
BOARD_PORT = /dev/ttyACM*
# Linux

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = __MK66FX1M0__ TEENSYDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# # APPLICATIONS_PATH = /Applications
# # HEADER_SEARCH_PATHS = $(APPLICATIONS_PATH)/Teensyduino.app/Contents/Java/hardware/teensy/avr/*

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
#
# MAX_RAM_SIZE = 

MESSAGE_RESET = 1

CONFIG_NAME = Teensy 3.6
