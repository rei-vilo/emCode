#
# Adafruit Huzzah ESP32 (USB).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 06 Mar 2018
# Copyright: (c) Rei Vilo, 2010-2024 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 15 Feb 2021 release 12.0.8

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = featheresp32

# BOARD_TAG1 is for Flash size, hard-coded for Feather ESP32
# featheresp32.build.flash_size = 4MB
# BOARD_TAG1 = generic.menu.FlashSize.512K
# BOARD_TAG1 = featheresp32.menu.Flash_Size.4M

# BOARD_TAG2 is for Flash frequency
BOARD_TAG2 = featheresp32.menu.FlashFreq.40

# BOARD_TAG3 is for partition scheme
BOARD_TAG3 = featheresp32.menu.PartitionScheme.default
# BOARD_TAG3 = featheresp32.menu.PartitionScheme.no_ota
# See https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/partition-tables.html

# BOARD_TAG4 is for debug level
BOARD_TAG4 = esp32.menu.DebugLevel.none

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/cu.SLAB_USBtoUART
BOARD_PORT = /dev/ttyUSB0

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ESP32 ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/esp32/hardware/

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 2048

CONFIG_NAME = Adafruit Huzzah ESP32 (USB)
