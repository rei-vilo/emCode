#
# ESP32_Pico_Kit_v4_ESP-Prog.mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 23 Jan 2020
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 13 Mar 2020 release 11.7.0

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = pico32

# BOARD_TAG1 is for Flash size
# pico32 has no options
# BOARD_TAG1 = pico32

# BOARD_TAG2 is for Flash frequency
# pico32 has no options
# BOARD_TAG2 = pico32

# BOARD_TAG3 is for partition scheme
BOARD_TAG3 = pico32.menu.PartitionScheme.default
# BOARD_TAG3 = esp32.menu.PartitionScheme.no_ota
# See https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/partition-tables.html

# BOARD_TAG4 is for debug level
BOARD_TAG4 = pico32.menu.DebugLevel.none

# Even more options
BOARD_TAG5 = pico32.menu.LoopCore.1
BOARD_TAG6 = pico32.menu.EventsCore.1

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
BOARD_PORT = /dev/tty.usbserial-*1

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

UPLOADER = openocd-esp32

CONFIG_NAME = ESP32 Pico-Kit v4 (ESP-Prog)
