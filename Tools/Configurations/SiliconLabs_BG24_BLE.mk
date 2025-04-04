#
# SiliconLabs_BG24_BLE.mk
# Board config file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 11 Jan 2024
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 02 Aug 2024 release 14.4.10

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = xg24explorerkit
BOARD_TAG1 = xg24explorerkit.menu.protocol_stack.ble_silabs

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
BOARD_PORT = /dev/ttyACM*

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS =

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/SiliconLabs/hardware/silabs/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 24576

UPLOADER = jlink

CONFIG_NAME = SiliconLabs BG24 BLE
