#
# Arduino M0 Pro (Native USB Port).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 10 Apr 2015
# Copyright: (c) Rei Vilo, 2010-2026 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 25 Sep 2018 release 10.0.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
# BOARD_TAG = arduino_zero_pro_bl
BOARD_TAG = mzero_pro_bl

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
BOARD_PORT = /dev/cu.usbmodem*

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = __SAMD21G18A__ ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/samd/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
MAX_RAM_SIZE = 32768

# Select programmer
#
UPLOADER = avrdude

# MCU for AVRDUDE
#
AVRDUDE_MCU = atmega2560

CONFIG_NAME = Arduino M0 Pro (Native USB Port)
