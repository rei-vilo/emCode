#
# SiliconLabs_BG24_NoStack.mk
# Board config file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 17 Mar 2025
# Copyright: (c) Rei Vilo, 2010-2026 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 17 Mar 2025 release 14.7.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = xg24explorerkit
BOARD_TAG1 = xg24explorerkit.menu.protocol_stack.none

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

CONFIG_NAME = SiliconLabs BG24 no stack
