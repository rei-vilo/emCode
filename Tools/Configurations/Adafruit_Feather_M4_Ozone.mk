#
# Adafruit Feather M4 (Ozone).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 28 Jan 2020
# Copyright: (c) Rei Vilo, 2010-2024 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 28 Jan 2020 release 11.6.4

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = adafruit_feather_m4
BOARD_TAG1 = adafruit_feather_m4.menu.cache.on
BOARD_TAG2 = adafruit_feather_m4.menu.speed.120
BOARD_TAG3 = adafruit_feather_m4.menu.maxspi.24
BOARD_TAG4 = adafruit_feather_m4.menu.maxqspi.50

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
BOARD_PORT = /dev/cu.usbmodem*

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = __SAMD51J19A__ ARDUINO ADAFRUIT

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/adafruit/hardware/samd/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
#
MAX_RAM_SIZE = 196608

# Specific programmer options, no port
#
UPLOADER = ozone
# MESSAGE_RESET = 1

# DELAY_BEFORE_SERIAL = 5
AVRDUDE_NO_SERIAL_PORT = 1

# JLINK_POWER = 1

CONFIG_NAME = Adafruit Feather M4 (Ozone)
