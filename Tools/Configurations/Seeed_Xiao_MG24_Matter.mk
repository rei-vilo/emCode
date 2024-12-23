#
# Seeed_Xiao_MG24_Matter.mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 14 Dec 2024
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 16 Dec 2024 release 14.6.5

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = xiao_mg24
BOARD_TAG1 = xiao_mg24.menu.protocol_stack.matter

# For Arduino 1.5.x, if different from Arduino 1.0.x
#
# BOARD_TAG1 = nano
# BOARD_TAG2 = nano.menu.cpu.atmega168

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/tty.usbmodem* # macOS
BOARD_PORT = /dev/ttyACM*
# Linux

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# APPLICATIONS_PATH = /Applications
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/megaavr/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 1024
UPLOADER = openocd

# MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME).

CONFIG_NAME = Seeed Xiao MG24 Matter
