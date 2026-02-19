#
# Arduino_Nano_ESP32_Arduino.mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 18 Dec 2024
# Copyright: (c) Rei Vilo, 2010-2026 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 18 Dec 2024 release 14.6.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = nano_nora

BOARD_TAG1 = nano_nora.menu.PinNumbers.byGPIONumber
# BOARD_TAG1 = nano_nora.menu.PinNumbers.default
BOARD_TAG2 = nano_nora.menu.USBMode.default

# BOARD_TAG1 is for Flash size
# BOARD_TAG1 = nano_nora.build.flash_size

# BOARD_TAG2 is for Flash frequency
# BOARD_TAG2 = esp32.build.flash_freq

# BOARD_TAG3 is for partition scheme
# BOARD_TAG3 = esp32.build.partitions
# BOARD_TAG3 = esp32.menu.PartitionScheme.no_ota
# See https://docs.espressif.com/projects/esp-idf/en/latest/api-guides/partition-tables.html

# BOARD_TAG4 is for debug level
# BOARD_TAG4 = esp32.menu.DebugLevel.none

# Even more options
# BOARD_TAG5 = esp32.build.loop_core
# BOARD_TAG6 = esp32.build.event_core

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/tty.usbmodem* # macOS
# Linux
BOARD_PORT = /dev/ttyACM*

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ESP32 ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# APPLICATIONS_PATH = /Applications
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/mbed/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 32768

UPLOADER = esptool

# MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME).

CONFIG_NAME = Arduino Nano ESP32 Arduino
