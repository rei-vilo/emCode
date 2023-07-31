#
# STM32duino Nucleo F401RE (MSD).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 06 Jan 2020
# Copyright: (c) 2010-2023 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 06 Jan 2020 release 11.5.2

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
# BOARD_TAG = NANO
BOARD_TAG = Nucleo_64
BOARD_TAG1 = Nucleo_64.menu.pnum.NUCLEO_F401RE

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
# Note: if /dev/tty.usbserial* doesn't work, try /dev/tty.usbmodem*
#
# BOARD_PORT = /dev/cu.usbmodem*
BOARD_PORT = /dev/ttyACM0

# Warning: some users have reported /dev/cu.usb*

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = STM32DUINO ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/STM32/hardware/stm32/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# SRAM1 only, SRAM2 = 16384
# MAX_RAM_SIZE = 81920

UPLOADER = cp_hex
# BOARD_VOLUME = /Volumes/NUCLEO # macOS
BOARD_VOLUME = /media/reivilo/NUCLEO
# Linux

# MESSAGE_POST_RESET = 1
# DELAY_AFTER_UPLOAD = 5

CONFIG_NAME = STM32duino Nucleo F401RE (MSD)

