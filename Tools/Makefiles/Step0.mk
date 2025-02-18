#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
#
# Created: 03 Jul 2023 release 14.1.4
#
# Last update: 10 Jan 2025 release 14.6.9
# 

# Set default values for parameters
# ----------------------------------
#
# C-compliant project extension, empty and default = ino
# 
SKETCH_EXTENSION ?= ino

# For building, hide summary, false or true, default = false
# For building, hide command line, false or true, default = true
# 
HIDE_NUMBER ?= false
HIDE_COMMAND ?= true
HIDE_INFO ?= false
HIDE_TOOLS ?= false
HIDE_ALL ?= false

ifeq ($(HIDE_ALL),true)
	HIDE_NUMBER := true
	HIDE_COMMAND := true
	HIDE_INFO := true
	HIDE_TOOLS := true
endif

# For building, keep main and tasks unchanged, false or true, default = false
#
KEEP_MAIN ?= false
KEEP_TASKS ?= false

# For building, use available archives, false or true, default = true
# 
USE_ARCHIVES ?= true

# For building, set optimisation 
# 
OPTIMISATION ?= -Os -g3

# Binary name, default = emcode
# 
BINARY_SPECIFIC_NAME ?= emcode

# emCode edition
# 
EMCODE_EDITION ?= emCode

# Path to Arduino and Energia
# 
APPLICATIONS_PATH ?= $(HOME)/Applications
SEGGER_PATH ?= /opt/SEGGER
STM32_CUBE_PATH ?= $(HOME)/Applications/STM32CubeProgrammer

# Explicit check
# 
ifeq ($(APPLICATION_PATH),)
APPLICATION_PATH = $(HOME)/Applications
endif # APPLICATION_PATH

# Serial console board rate
# 
SERIAL_BAUDRATE ?= 115200

# For Fast target, open serial console, false or true
# 
NO_SERIAL_CONSOLE = true

OPERATING_SYSTEM := $(shell uname -s)

# GUI option for messages
# ZENITY, NOTIFY, 0 = NONE
# GUI_OPTION ?= NOTIFY
GUI_OPTION = NOTIFY

ifeq ($(OPERATING_SYSTEM),Darwin)
	GUI_OPTION = OSASCRIPT
endif # OPERATING_SYSTEM
