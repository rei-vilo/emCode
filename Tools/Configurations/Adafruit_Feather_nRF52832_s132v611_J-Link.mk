#
# Adafruit Feather nRF52832 s132v611 (J-Link).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 28 Mar 2017
# Copyright: (c) Rei Vilo, 2010-2025 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 09 Dec 2019 release 11.4.2

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = feather52832
BOARD_TAG1 = feather52832.menu.softdevice.s132v6
BOARD_TAG2 = feather52832.menu.debug_output.serial

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/cu.SLAB_USBtoUART
BOARD_PORT = /dev/ttyUSB0

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = __NRF52__ ARDUINO ADAFRUIT

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/adafruit/hardware/nrf52/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
#
# MAX_RAM_SIZE = 65536

# Specific programmer options, no port
#
# AVRDUDE_PROGRAMMER = usbtiny
# AVRDUDE_OTHER_OPTIONS = -v
# AVRDUDE_NO_SERIAL_PORT = 1
# MESSAGE_RESET = 1
UPLOADER = jlink
# MESSAGE_RESET = 1

# MCU for AVRDUDE
# If not specified, AVRDUDE_MCU = value from boards.txt
# #
# AVRDUDE_MCU = atmega328
#
# Although compatible, the actual MCU may have a different speed.
# If not specified, F_CPU = value from boards.txt
# #
# F_CPU = 16000000L
#
# Fuses for AVRDUDE
# To by-pass fuses, set AVR_IGNORE_FUSES = 1 otherwise AVR_IGNORE_FUSES = 0
# AVR_IGNORE_FUSES = 1
#
# Define fuses, only if different from default values
# ISP_LOCK_FUSE_PRE ISP_LOCK_FUSE_POST ISP_HIGH_FUSE ISP_LOW_FUSE ISP_EXT_FUSE
#

DELAY_BEFORE_SERIAL = 5

CONFIG_NAME = Adafruit Feather nRF52832 s132v611 (J-Link)
