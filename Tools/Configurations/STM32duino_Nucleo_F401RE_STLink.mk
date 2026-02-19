#
# STM32duino Nucleo F401RE (STLink).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 06 Jan 2020
# Copyright: (c) Rei Vilo, 2010-2026 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 28 Jun 2024 release 14.4.6

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
# BOARD_TAG = NANO
BOARD_TAG = Nucleo_64
BOARD_TAG1 = Nucleo_64.menu.pnum.NUCLEO_F401RE

BOARD_TAG2 = Nucleo_64.menu.xserial.generic

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

UPLOADER = stlink

# MESSAGE_POST_RESET = 1
# DELAY_AFTER_UPLOAD = 5

CONFIG_NAME = STM32duino Nucleo F401RE (STLink)

