#
# ESP32C3 DevKit.mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 11 Mar 2020
# Copyright: (c) Rei Vilo, 2010-2026 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 15 Feb 2022 release 12.0.8

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = esp32c3

# BOARD_TAG1 is for Flash size
BOARD_TAG1 = esp32c3.menu.FlashSize.4M

# BOARD_TAG2 is for Flash frequency
BOARD_TAG2 = esp32c3.menu.FlashFreq.40
# Although defined as QIO, DIO is forced on Arduino as only DIO works.
BOARD_TAG8 = esp32c3.menu.FlashMode.dio

# BOARD_TAG3 is for partition scheme
BOARD_TAG3 = esp32c3.menu.PartitionScheme.default
# BARD_TAG3 = esp32c3.menu.PartitionScheme.min_spiffs
# BOARD_TAG3 = esp32c3.menu.PartitionScheme.no_ota
# See https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/partition-tables.html

# BOARD_TAG4 is for debug level
BOARD_TAG4 = esp32c3.menu.DebugLevel.none

# Even more options
BOARD_TAG5 = esp32c3.menu.LoopCore.1
BOARD_TAG6 = esp32c3.menu.EventsCore.1
BOARD_TAG7 = esp32c3.menu.CDCOnBoot.default

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# macOS
# BOARD_PORT = /dev/cu.SLAB_USBtoUART
# Linux
BOARD_PORT = /dev/ttyUSB0

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ESP32 ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/esp32c3/hardware/

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 2048

CONFIG_NAME = ESP32C3 DevKitC
