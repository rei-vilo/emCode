#
# Arduino Leonardo.mk 
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 29 Aug 2012
# Copyright: (c) Rei Vilo, 2010-2024 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 22 Jun 2020 release 11.8.7

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = leonardo

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# /dev/tty.usbmodem1* replaced by /dev/tty.usbmodem* for 
# Upload port /dev/tty.usbmodem14101
# HID port: /dev/tty.usbmodemHIDPC1
#
# BOARD_PORT = /dev/tty.usbmodem* # macOS
BOARD_PORT = /dev/ttyACM*
# Linux

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = __AVR_ATmega32U4__ ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# APPLICATIONS_PATH = /Applications
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/avr/** $(APPLICATIONS_PATH)/Arduino.app/Contents/Java/hardware/arduino/avr/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
MAX_RAM_SIZE = 2560

DELAY_BEFORE_UPLOAD = 1

CONFIG_NAME = Arduino Leonardo
