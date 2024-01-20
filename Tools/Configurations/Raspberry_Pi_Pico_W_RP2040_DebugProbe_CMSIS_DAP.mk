#
# Raspberry Pi Pico W RP2040 (DebugProbe CMSIS-DAP).mk
# Board configuration file
# ----------------------------------
# Developed with emCode
#
# Part of emCode
# Embedded computing with make
#
# Created by: Rei Vilo on 11 May 2023
# Copyright: (c) Rei Vilo, 2010-2024 https://emCode.weebly.com
# Licence: All rights reserved
#
# Last update: 11 May 2023 release 14.0.6

# Declare udev for Linux
# echo 'SUBSYSTEMS = = "usb", ATTRS{idVendor} = = "2e8a", ATTRS{idProduct} = = "0004", GROUP = "users", MODE = "0666"' | sudo tee -a /etc/udev/rules.d/98-DebugProbe.rules
# sudo udevadm control --reload

# Board identifier
# See Boards.txt for <tag>.name = Arduino Uno (16 MHz)
#
BOARD_TAG = rpipicow
# Program / File system
BOARD_TAG1 = rpipicow.menu.flash.2097152_0
# Speed nominal = 133
BOARD_TAG2 = rpipicow.menu.freq.125
# Debug port, requires TinyUSB
BOARD_TAG3 = rpipicow.menu.dbgport.Disabled
# BOARD_TAG3 = rpipicow.menu.dbgport.Serial
# Debug level
BOARD_TAG4 = rpipicow.menu.dbglvl.None
# USB stack, TinyUSB for Serial
# BOARD_TAG5 = rpipico.menu.usbstack.tinyusb
BOARD_TAG5 = rpipicow.menu.usbstack.picosdk
# Stack protect, default = disabled
BOARD_TAG6 = rpipicow.menu.stackprotect.Disabled
# Exception, default = disabled
BOARD_TAG7 = rpipicow.menu.exceptions.Disabled
# Upload method
BOARD_TAG8 = rpipicow.menu.uploadmethod.picoprobe_cmsis_dap

# Port (optional)
# most common are /dev/tty.usbserial*, /dev/tty.usbmodem* or /dev/tty.uart*
#
# BOARD_PORT = /dev/cu.usbmodem*
# BOARD_PORT = /dev/cu.SLAB_USBtoUART
BOARD_PORT = /dev/ttyACM0

# Define macros for build
# See Boards.txt for <tag>.build.mcu = <GCC_PREPROCESSOR_DEFINITIONS>
#
GCC_PREPROCESSOR_DEFINITIONS = ARDUINO

# Specify the full path and name of the application
# with /Contents/Java/** after
#
# HEADER_SEARCH_PATHS = $HOME/Library/Arduino15/packages/arduino/hardware/rp2040/**

# Maximum RAM size in bytes
# given by <tag>.upload.maximum_ram_size in boards.txt for Maple and Teensy
# given by <tag>.upload.maximum_data_size in boards.txt for Arduino 1.5.x
#
# MAX_RAM_SIZE = 65536

# Specific programmer options, no port
#
UPLOADER = debugprobe
# DELAY_BEFORE_UPLOAD = 5

# BOARD_VOLUME = /Volumes/FEATHERBOOT # macOS
# Linux
# BOARD_VOLUME = /media/$(USER)/RPI-RP2

# // MCU for AVRDUDE
# // If not specified, AVRDUDE_MCU = value from boards.txt
# # 
# AVRDUDE_MCU = atmega328
# 
# // Although compatible, the actual MCU may have a different speed.
# // If not specified, F_CPU = value from boards.txt
# # 
# //F_CPU = 16000000L
# 
# // Fuses for AVRDUDE
# // To by-pass fuses, set AVR_IGNORE_FUSES = 1 otherwise AVR_IGNORE_FUSES = 0
# //AVR_IGNORE_FUSES = 1
# 
# // Define fuses, only if different from default values
# //ISP_LOCK_FUSE_PRE ISP_LOCK_FUSE_POST ISP_HIGH_FUSE ISP_LOW_FUSE ISP_EXT_FUSE
# 
# MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME)

DELAY_BEFORE_SERIAL = 5

CONFIG_NAME = Raspberry Pi Pico W RP2040 (DebugProbe CMSIS-DAP)
