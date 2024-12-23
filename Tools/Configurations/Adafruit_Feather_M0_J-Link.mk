#
# Adafruit Feather M0 (J-Link).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 19 Aug 2016
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 25 Sep 2018 release 10.0.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = adafruit_feather_m0

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/tty.usbmodem* # macOS
BOARD_PORT = /dev/ttyACM*
# Linux

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = __SAMD21G18A__ ARDUINO ADAFRUIT

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/adafruit/hardware/samd/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
#
MAX_RAM_SIZE = 32768

# Specific programmer options, no port
#
UPLOADER = jlink
# MESSAGE_RESET = 1

# DELAY_BEFORE_SERIAL = 5
AVRDUDE_NO_SERIAL_PORT = 1

# JLINK_POWER = 1

CONFIG_NAME = Adafruit Feather M0 (J-Link)
