#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Last update: 02 Jan 2025 release 14.6.8
#

include $(MAKEFILE_PATH)/Step0.mk

# Functions
# ----------------------------------
#

# Function PARSE_BOARD data retrieval from boards.txt
# result = $(call PARSE_BOARD 'board tag','parameter')
# Implicit variable BOARDS_TXT
# Strict search with ending `=` on `^$(1).$(2)=`
#
PARSE_BOARD = $(shell if [ -f $(BOARDS_TXT) ] ; then grep ^$(1).$(2)= $(BOARDS_TXT) | cut -d = -f 2- ; fi ; )

# Function PARSE_FILE data retrieval from specified file
# result = $(call PARSE_FILE 'board tag','parameter','filename')
# Open search with no ending `=` on `^$(1).$(2)`
# Pass ending `=` on parameter `$(2)`
#
PARSE_FILE = $(shell if [ ! -z $(3) ] ; then if [ -f $(3) ] ; then grep ^$(1).$(2) $(3) | cut -d = -f 2- ; fi ; fi ;)

# Function PARSE_BOARD data retrieval from boards.txt
# result = $(call SEARCH_FOR,'list of board tags','parameter')
# Implicit variable BOARDS_TXT
# 
SEARCH_FOR = $(strip $(foreach t,$(1),$(call PARSE_BOARD,$(t),$(2))))

# Function VERSION version of library
# result = $(call VERSION,'list of board tags','parameter')
# $(foreach file,$(INFO_LOCAL_UNARCHIVES_LIST),$(info . $(file) release $(shell grep version $(CURRENT_DIR)/$(file)/library.properties | cut -d= -f2)))
# 
VERSION = $(shell work=$(2)/$(1)/library.properties ; test=$$(grep version $$work | cut -d= -f2) ; if [ $$test ] ; then echo $(1) release $$test ; else echo "$(1) release ?" ; fi ; )
# VERSION = $(shell work=$(2)/$(1)/library.properties ; echo $$work )
# VERSION = $(shell work=$(2)/$(1)/library.properties ; echo $$work ; test=$$(grep "version" $$work) ; echo $$test )

# define MESSAGE_ZENITY
#     $(info ERROR $(1))
#     $(shell zenity --width=240 --title "emCode" --text "$(1)" --$(2))
#     $(info .)
# endef

# GUI options
#
# Function MESSAGE_GUI with level option
# result = MESSAGE_GUI_ERROR(message) for error 
# result = MESSAGE_GUI_WARNING(message) for warning 
# result = MESSAGE_GUI_INFO(message) for information

# ZENITY Display a dialogue box with title emCode and message 
ifeq ($(GUI_OPTION),ZENITY)

    MESSAGE_GUI_ERROR = $(shell zenity --width=240 --title "emCode" --text "$(1)" --error)
    MESSAGE_GUI_WARNING = $(shell zenity --width=240 --title "emCode" --text "$(1)" --warning)
    MESSAGE_GUI_INFO = $(shell zenity --width=240 --title "emCode" --text "$(1)" --info)

# NOTIFY Display a notification with title emCode and message
else ifeq ($(GUI_OPTION),NOTIFY)

    MESSAGE_GUI_ERROR = $(shell notify-send "emCode" "$(1)" -u critical)
    MESSAGE_GUI_WARNING = $(shell notify-send "emCode" "$(1)" -u normal)
    MESSAGE_GUI_INFO = $(shell notify-send "emCode" "$(1)" -u low)

# OSASCRIPT Display a dialogue box with title emCode and message 
else ifeq ($(GUI_OPTION),OSASCRIPT)

    MESSAGE_GUI_ERROR = $(shell osascript -e 'tell application "System Events" to display dialog "$(1)" with title "emCode" buttons {"OK"} default button {"OK"} with icon 0')
    MESSAGE_GUI_WARNING = $(shell osascript -e 'tell application "System Events" to display dialog "$(1)" with title "emCode" buttons {"OK"} default button {"OK"} with icon 2')
    MESSAGE_GUI_INFO = $(shell osascript -e 'tell application "System Events" to display dialog "$(1)" with title "emCode" buttons {"OK"} default button {"OK"} with icon 1')

else
#     Nothing
endif # GUI_OPTION

# Sketch unicity test and extension
# ----------------------------------
#
# ifndef SKETCH_EXTENSION
#     ifeq ($(words $(wildcard *.pde) $(wildcard *.ino)), 0)
#         $(error No pde or ino sketch)
#     endif # wildcard

#     ifneq ($(words $(wildcard *.pde) $(wildcard *.ino)), 1)
#         $(error More than 1 pde or ino sketch)
#     endif # wildcard

#     ifneq ($(wildcard *.pde),)
#         SKETCH_EXTENSION := pde
#     else ifneq ($(wildcard *.ino),)
#         SKETCH_EXTENSION := ino
#     else
#         $(error Extension error)
#     endif # wildcard
# endif # SKETCH_EXTENSION

# C-compliant project name, empty and default = search
# 
ifneq ($(MULTI_INO),1)
ifeq ($(PROJECT_NAME_AS_IDENTIFIER),)
    PROJECT_LIST = $(wildcard *.ino)
    PROJECT_NAME_AS_IDENTIFIER = $(PROJECT_LIST:.ino=)
endif # PROJECT_NAME_AS_IDENTIFIER
endif # MULTI_INO

# Unicity check
# 
ifneq ($(MULTI_INO),1)
ifneq ($(SKETCH_EXTENSION),__main_cpp_only__)
    ifneq ($(SKETCH_EXTENSION),_main_cpp_only_)
        ifneq ($(SKETCH_EXTENSION),cpp)
            ifeq ($(words $(wildcard *.$(SKETCH_EXTENSION))), 0)
                $(info ERROR             No '.$(SKETCH_EXTENSION)'' sketch)
                $(info .)
                $(call MESSAGE_GUI_ERROR,No '.$(SKETCH_EXTENSION)' sketch)
                $(error Stop)
            endif # SKETCH_EXTENSION

            ifneq ($(words $(wildcard *.$(SKETCH_EXTENSION))), 1)
                $(info ERROR             More than one '.$(SKETCH_EXTENSION)' sketch)
                $(info .)
                $(call MESSAGE_GUI_ERROR,More than one '.$(SKETCH_EXTENSION)' sketch)
                $(error Stop)
            endif # SKETCH_EXTENSION
        endif # SKETCH_EXTENSION cpp
    endif # SKETCH_EXTENSION
endif # SKETCH_EXTENSION
endif # MULTI_INO

PREVIOUS_TAG := $(basename $(notdir $(strip $(wildcard $(BUILDS_PATH)/*.board))))
LIST := $(BOARD_TAG) $(BOARD_TAG) $(BOARD_TAG1) $(BOARD_TAG2)

ifeq ($(filter $(PREVIOUS_TAG),$(LIST)),)
    KEEP_MAIN := false
endif # PREVIOUS_TAG

# Check and provide alternative Builds folder
# ----------------------------------
#
ifeq ($(BUILDS_PATH),)
    BUILDS_PATH := $(CURRENT_PATH)/Builds
    BUILDS_PATH_SPACE := $(CURRENT_PATH_SPACE)/Builds
    $(info Builds path defined at $(BUILDS_PATH))
endif # BUILDS_PATH
$(shell mkdir -p $(BUILDS_PATH))

ifeq ($(MAKECMDGOALS),)
    $(info Syntax            make <target> SELECTED_BOARD=<board name>)
    $(info ERROR             <target> not defined)
    $(info .)
    $(call MESSAGE_GUI_ERROR,make <target> SELECTED_BOARD=<board name>\n<target> not defined)
    $(error Stop)
endif # MAKECMDGOALS

# Board selection
# ----------------------------------
# Board specifics defined in .xconfig file
# BOARD_TAG and AVRDUDE_PORT
#
BOOL_SELECT_BOARD := 0
ifneq ($(filter $(MAKECMDGOALS),all build core make fast debug archive unarchive upload serial bootloader),)
    BOOL_SELECT_BOARD := 1
endif # MAKECMDGOALS
BOOL_SELECT_SERIAL := 0
ifneq ($(filter $(MAKECMDGOALS),all fast debug upload serial),)
    BOOL_SELECT_SERIAL := 1
endif # MAKECMDGOALS

ifeq ($(BOOL_SELECT_BOARD),1)

    include $(CONFIGURATIONS_PATH)/$(SELECTED_BOARD).mk

    ifndef BOARD_TAG
        $(info Syntax            make <target> SELECTED_BOARD=<board name>)
        $(info ERROR             <board name> not defined)
        $(info .)
        $(call MESSAGE_GUI_ERROR,make <target> SELECTED_BOARD=<board name>\n<board name> not defined)
        $(error Stop)
    endif # BOARD_TAG

endif # BOOL_SELECT_BOARD

ifndef BOARD_PORT
    BOARD_PORT = /dev/tty.usb*
endif # BOARD_TAG

# Path to applications folder
#
# $(HOME) same as $(wildcard ~)
# $(USER_PATH)/Library same as $(USER_LIBRARY_DIR)
#
USER_PATH := $(HOME)
EMCODE_APP = $(USER_LIBRARY_DIR)/emCode
PARAMETERS_TXT = $(EMCODE_APP)/parameters.txt

ifeq ($(USER_LIBRARY_DIR),)
    USER_LIBRARY_DIR = /Users/$(shell echo $$USER)/Library
endif # USER_LIBRARY_DIR

# ifndef APPLICATIONS_PATH
ifneq ($(wildcard $(PARAMETERS_TXT)),)
    ap1 = $(shell grep ^applications.path '$(PARAMETERS_TXT)' | cut -d = -f 2-;)
    ifneq ($(ap1),)
        APPLICATIONS_PATH = $(ap1)
    endif # grep
endif # PARAMETERS_TXT
# endif

# ifndef APPLICATIONS_PATH
#     APPLICATIONS_PATH = /Applications
# endif # APPLICATIONS_PATH

include $(MAKEFILE_PATH)/About.mk
RELEASE_NOW = $(shell echo $(EMCODE_RELEASE) | sed 's/\./ /g' | xargs printf "%02i%02i%02i")

RELEASE_ARDUINO = $(shell echo $(ARDUINO_IDE_RELEASE) | sed 's/\./ /g' | xargs printf "%i%02i%02i")

# APPlications full paths
# ----------------------------------
#
# . Arduino
# Welcome unified 1.8.0 release for all Arduino.CC and Genuino, Arduino.ORG boards!
#
ifneq ($(wildcard $(APPLICATIONS_PATH)/arduino*),)
    ARDUINO_APP := $(APPLICATIONS_PATH)/arduino-$(ARDUINO_IDE_RELEASE)
    ARDUINO_PATH := $(ARDUINO_APP)/java

# $(HOME)/AppImage/arduino-1.8.13/lib/version.txt

# Check release is = ARDUINO_IDE_RELEASE
#
    ifeq ($(shell if [ -f '$(APPLICATIONS_PATH)/arduino-$(ARDUINO_IDE_RELEASE)/lib/version.txt' ]; then echo 1 ; else echo 0 ; fi),1)
        ifneq ($(shell grep -e '$(ARDUINO_IDE_RELEASE)' $(APPLICATIONS_PATH)/arduino-$(ARDUINO_IDE_RELEASE)/lib/version.txt),)
            ARDUINO_APP = $(APPLICATIONS_PATH)/arduino-$(ARDUINO_IDE_RELEASE)
# Additional boards for Arduino 1.8.0 Boards Manager
            ARDUINO_PATH := $(ARDUINO_APP)
        endif # end ARDUINO_IDE_RELEASE
    endif # if -f
else
#    ARDUINO_APP = $(APPLICATIONS_PATH)/Arduino.app
#    $(error Arduino IDE: Check version $(ARDUINO_IDE_RELEASE) and location $(ARDUINO_APP) )
endif # APPLICATIONS_PATH

ARDUINO_APP :=
# $(info >>> ARDUINO_APP $(ARDUINO_APP))

ifeq ($(ARDUINO_APP),)
    FLATPAK_APP := $(shell which flatpak)
    ifneq ($(FLATPAK_APP),)
#         TEST := $(shell /usr/bin/flatpak info cc.arduino.IDE2 | grep error)
        TEST := $(shell /usr/bin/flatpak list | grep cc.arduino.IDE2)
        ifneq ($(TEST),)
            ARDUINO_APP = arduino-flatpak
            ARDUINO_FLATPAK_RELEASE = $(strip $(shell /usr/bin/flatpak info cc.arduino.IDE2 | grep Version | cut -d: -f2))
        endif # TEST
    endif # FLATPAK_APP
endif # ARDUINO_APP

# # macOS with AppleScript
ifeq ($(OPERATING_SYSTEM),Darwin)
ifeq ($(ARDUINO_APP),)
    ARDUINO_APP = /Applications/Arduino\ IDE.app/Contents/Resources/app/lib/backend/resources/arduino-cli
    ARDUINO_CLI_RELEASE = $(strip $(shell $(ARDUINO_APP) version --format yaml | grep versionstring | cut -d: -f2))
    ARDUINO_APP = arduino-cli
endif # ARDUINO_APP
endif # OPERATING_SYSTEM

# ifeq ($(ARDUINO_APP),)
# #     TEST := $(shell find $(APPLICATION_PATH) -name arduino-cli)
#     TEST := $(which arduino-cli)

#     $(info 2)
# #     ARDUINO_APP = $(shell which arduino-cli)
# #     ARDUINO_APP := $(shell arduino-cli version)
#     ifneq ($(TEST),)
#         ARDUINO_APP = arduino-cli
#         ARDUINO_CLI_RELEASE = $(strip $(shell arduino-cli version --format yaml | grep versionstring | cut -d: -f2))
#     endif
# endif # ARDUINO_APP

# TEST := $(shell find $(APPLICATION_PATH) -name arduino-cli)
# TEST := $(shell /usr/bin/which arduino-cli)
ARDUINO_CLI_PATH := $(firstword $(shell find $(APPLICATION_PATH) -name arduino-cli))
ifneq ($(ARDUINO_CLI_PATH),)
    ifeq ($(ARDUINO_APP),)
        ARDUINO_APP = arduino-cli
    endif # ARDUINO_APP
    ARDUINO_CLI_RELEASE = $(strip $(shell $(ARDUINO_CLI_PATH) version --format json | grep VersionString | cut -d: -f2 | sed -E 's:("| |,)::g'))
endif # ARDUINO_CLI_PATH

ARDUINO_APPIMAGE_PATH = $(shell find ~/Applications/ -name arduino-ide_\*.AppImage)
ifneq ($(ARDUINO_APPIMAGE_PATH),)
    ifeq ($(ARDUINO_APP),)
        ARDUINO_APP = arduino-appimage
    endif # ARDUINO_APPIMAGE_PATH
    ARDUINO_APPIMAGE_RELEASE = $(strip $(shell echo $(ARDUINO_APPIMAGE_PATH)  | cut -d_ -f2))
endif # ARDUINO_CLI_PATH

# $(info 1 arduino-cli $(shell which arduino-cli))
# $(info 2 arduino-cli $(shell arduino-cli version))
# $(info 3 arduino-cli $(shell find $(APPLICATION_PATH) -name arduino-cli))
# $(info >>> ARDUINO_APP $(ARDUINO_APP))

# $(error sTOP)

ARDUINO_15_LIBRARY_PATH := $(HOME)/.arduino15
# macOS specifics
ifeq ($(OPERATING_SYSTEM),Darwin)
    ARDUINO_15_LIBRARY_PATH := $(HOME)/Library/Arduino15
endif # OPERATING_SYSTEM

ARDUINO_PACKAGES_PATH = $(ARDUINO_15_LIBRARY_PATH)/packages

ARDUINO_IDE_LIBRARY_PATH = $(HOME)/.arduinoIDE

# preferences.txt no longer used
# ARDUINO_PREFERENCES = $(ARDUINO_LIBRARY_PATH)/preferences.txt 
ARDUINO_YAML := $(ARDUINO_IDE_LIBRARY_PATH)/arduino-cli.yaml

# $(info === ARDUINO_15_LIBRARY_PATH $(ARDUINO_15_LIBRARY_PATH))
# $(info === ARDUINO_IDE_LIBRARY_PATH $(ARDUINO_IDE_LIBRARY_PATH))
# $(info === ARDUINO_PACKAGES_PATH $(ARDUINO_PACKAGES_PATH))
# $(info === ARDUINO_PREFERENCES $(ARDUINO_PREFERENCES))

# Sketchbook/Libraries path
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifeq ($(shell if [ -f '$(ARDUINO_YAML)' ]; then echo 1 ; fi ),1)
    SKETCHBOOK_DIR = $(shell grep 'user:' $(ARDUINO_YAML) | cut -d: -f2 | sed -e 's/ //g')
endif # SKETCHBOOK_DIR

# ifeq ($(ARDUINO_PREFERENCES),)
#     $(info ERROR             Run Arduino once and define the sketchbook path)
#     $(info .)
#     $(call MESSAGE_GUI_ERROR,Run Arduino once and define the sketchbook path)
#     $(error Stop)
# endif # ARDUINO_PREFERENCES

ifeq ($(SKETCHBOOK_DIR),)
ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),1)
    SKETCHBOOK_DIR = $(shell grep sketchbook.path $(ARDUINO_PREFERENCES) | cut -d = -f 2)
endif # SKETCHBOOK_DIR
endif # SKETCHBOOK_DIR

ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
    $(info ERROR             Sketchbook path not found)
    $(info .)
    $(call MESSAGE_GUI_ERROR,Sketchbook path not found)
    $(error Stop)
endif # SKETCHBOOK_DIR

USER_LIB_PATH ?= $(wildcard $(SKETCHBOOK_DIR)/?ibraries)

# . Energia
#
ENERGIA_APP = $(APPLICATIONS_PATH)/energia-$(ENERGIA_IDE_RELEASE)
# Additional boards for Energia 18 Boards Manager
ENERGIA_LIBRARY_PATH = $(HOME)/.energia15
ENERGIA_PACKAGES_PATH = $(ENERGIA_LIBRARY_PATH)/packages/energia
ENERGIA_PATH = $(ENERGIA_APP)

# . Other IDEs
#
WIRING_APP = $(APPLICATIONS_PATH)/Wiring.app
MAPLE_APP = $(APPLICATIONS_PATH)/MapleIDE.app
# ROBOTIS_APP = $(APPLICATIONS_PATH)/ROBOTIS_OpenCM.app

# # Other boards with IDEs or plug-ins
# # ----------------------------------
# #
# # . Teensyduino.app path
# #
# TEENSY_0 := $(APPLICATIONS_PATH)/teensyduino-$(TEENSYDUINO_IDE_TEENSY_RELEASE)
# ifneq ($(wildcard $(TEENSY_0)),)
#     TEENSY_APP = $(TEENSY_0)
# else
#     TEENSY_APP = $(ARDUINO_APP)
# endif # TEENSY_0

# . Microduino.app path
#
MICRODUINO_0 = $(APPLICATIONS_PATH)/Microduino.app

ifneq ($(wildcard $(MICRODUINO_0)),)
    MICRODUINO_APP = $(MICRODUINO_0)
else
    MICRODUINO_APP = $(ARDUINO_APP)
endif # MICRODUINO_0

# . LightBlueIDE.app path
#
LIGHTBLUE_0 = $(APPLICATIONS_PATH)/LightBlueIDE.app

ifneq ($(wildcard $(LIGHTBLUE_0)),)
    LIGHTBLUE_APP = $(LIGHTBLUE_0)
else
    LIGHTBLUE_APP = $(ARDUINO_APP)
endif # LIGHTBLUE_0

# IDE-less boards
# ----------------------------------
#
# . Particle is the new name for Spark
#
SPARK_APP = $(EMCODE_APP)/Particle
SPARK_PATH = $(SPARK_APP)
# . Edison Yocto and MCU
#
# EDISON_YOCTO_APP = $(EMCODE_APP)/EdisonYocto
# EDISON_MCU_APP = $(EMCODE_APP)/EdisonMCU
# # MBED_APP = $(EMCODE_APP)/mbed-$(MBED_SDK_RELEASE)
# # BEAGLE_DEBIAN_APP = $(EMCODE_APP)/BeagleBone

# Check at least one IDE installed
#
# ifeq ($(wildcard $(ARDUINO_APP)),)
ifeq ($(ARDUINO_APP),)
    $(info Message           Arduino CLI or IDE required)
    $(info ERROR             Arduino CLI or IDE not found)
    $(info .)
    $(call MESSAGE_GUI_ERROR,Arduino CLI or IDE not found)
    $(error Stop)
endif # ARDUINO_APP

# # Arduino-related nightmares
# # ----------------------------------
# #
# # Get Arduino release
# # Gone Arduino 1.0, 1.5 Java 6 and 1.5 Java 7 triple release nightmare
# #
# ifneq ($(wildcard $(ARDUINO_APP)),)
#    s103 = $(ARDUINO_APP)/Contents/Java/lib/version.txt
#    ARDUINO_RELEASE := $(shell cat $(s103) | sed -e "s/\.//g")
#    ARDUINO_MAJOR := $(shell echo $(ARDUINO_RELEASE) | cut -d. -f 1-2)
# else
#    ARDUINO_RELEASE := 0
#    ARDUINO_MAJOR := 0
# endif

# Miscellaneous
# ----------------------------------
# # Variables
# #
# USER_FLAG := false

# Builds directory
#
OBJDIR = $(BUILDS_PATH)

# ~
# Warnings flags
#
ifeq ($(WARNING_OPTIONS),)
    FLAGS_WARNING = -Wall -Wextra
else
    ifeq ($(WARNING_OPTIONS),0)
        FLAGS_WARNING = -w
    else
        FLAGS_WARNING = $(addprefix -W, $(WARNING_OPTIONS))
    endif # WARNING_OPTIONS 0
endif # WARNING_OPTIONS
# ~~

# Identification and switch
# ----------------------------------
# Look if BOARD_TAG is listed as a Arduino/Arduino board
# Look if BOARD_TAG is listed as a Arduino/arduino/avr board *1.5
# Look if BOARD_TAG is listed as a Arduino/arduino/sam board *1.5
# Look if BOARD_TAG is listed as a chipKIT/PIC32 board
# Look if BOARD_TAG is listed as a Wiring/Wiring board
# Look if BOARD_TAG is listed as a Energia/MPS430 board
# Look if BOARD_TAG is listed as a MapleIDE/LeafLabs board
# Look if BOARD_TAG is listed as a Teensy/Teensy board
# Look if BOARD_TAG is listed as a Microduino/Microduino board
# Look if BOARD_TAG is listed as a Digistump/Digistump board
# Look if BOARD_TAG is listed as a IntelGalileo/arduino/x86 board
# Look if BOARD_TAG is listed as a Adafruit/Arduino board
# Look if BOARD_TAG is listed as a LittleRobotFriends board
# Look if BOARD_TAG is listed as a mbed board
# Look if BOARD_TAG is listed as a RedBearLab/arduino/RBL_nRF51822 board
# Look if BOARD_TAG is listed as a Spark board
# Look if BOARD_TAG is listed as a LightBlueIDE/LightBlue-Bean board
# Look if BOARD_TAG is listed as a Robotis/robotis board
# Look if BOARD_TAG is listed as a RFduino/RFduino board
#
# Order matters!
#

# $(info >>> BOARD_TAG $(BOARD_TAG))
# $(info >>> MAKEFILE_PATH $(MAKEFILE_PATH))
# $(info >>> ARDUINO_PACKAGES_PATH $(ARDUINO_PACKAGES_PATH))
# $(info >>> ARDUINO_APP $(ARDUINO_APP))
# $(info >>> BOOL_SELECT_BOARD $(BOOL_SELECT_BOARD))

# Ignore if target is Boards or Clean
#
ifeq ($(BOOL_SELECT_BOARD),1)
# List of sub-paths to be excluded
#
    EXCLUDE_NAMES = Example example Examples examples Archive archive Archives archives
    EXCLUDE_NAMES += Documentation documentation Reference reference
    EXCLUDE_NAMES += ArduinoTestSuite tests test .git linux extra extras linux
    EXCLUDE_NAMES += $(EXCLUDE_LIBS)
#    EXCLUDE_LIST = $(addprefix %,$(EXCLUDE_NAMES))
    s101 = $(addprefix /,$(EXCLUDE_NAMES))
    EXCLUDE_PATHS = $(addsuffix /,$(s101))
    EXCLUDE_LIST = $(addprefix %,$(EXCLUDE_PATHS))
    ifneq ($(findstring RASPI,$(GCC_PREPROCESSOR_DEFINITIONS)),)
        -include $(MAKEFILE_PATH)/RasPiArduino.mk
    else
#         Arduino IDE and supported boards
        ifneq ($(ARDUINO_APP),)
#             . Arduino
            -include $(MAKEFILE_PATH)/ArduinoAVR_181.mk
            -include $(MAKEFILE_PATH)/ArduinoAVR.mk
            -include $(MAKEFILE_PATH)/ArduinoMegaAVR.mk
            -include $(MAKEFILE_PATH)/ArduinoNRF52.mk
            -include $(MAKEFILE_PATH)/ArduinoSAM.mk
            -include $(MAKEFILE_PATH)/ArduinoSAMD.mk
            -include $(MAKEFILE_PATH)/ArduinoMBED_giga.mk
            -include $(MAKEFILE_PATH)/ArduinoMBED_nano.mk
            -include $(MAKEFILE_PATH)/ArduinoESP32.mk
#            -include $(MAKEFILE_PATH)/ArduinoMBED_pico.mk

#             . Others boards for Arduino 1.8.0
#             Adafruit
            -include $(MAKEFILE_PATH)/AdafruitAVR.mk
            -include $(MAKEFILE_PATH)/AdafruitNRF52.mk
            -include $(MAKEFILE_PATH)/AdafruitSAMD.mk

#             ESP8266 and ESP32
            -include $(MAKEFILE_PATH)/ESP8266.mk
            -include $(MAKEFILE_PATH)/ESP32.mk

#             Intel
            -include $(MAKEFILE_PATH)/IntelCurie.mk

#             Microsoft
            -include $(MAKEFILE_PATH)/MicrosoftAZ3166.mk

#             Moteino
            -include $(MAKEFILE_PATH)/Moteino.mk

#             nRF1 boards
            -include $(MAKEFILE_PATH)/nRF51_Boards.mk

#             Raspberry Pi
            -include $(MAKEFILE_PATH)/RasPiPico.mk

#             Seeeduino
            -include $(MAKEFILE_PATH)/SeeeduinoAVR.mk
            -include $(MAKEFILE_PATH)/SeeeduinoSAMD.mk
            -include $(MAKEFILE_PATH)/SeeeduinoRTL.mk
            -include $(MAKEFILE_PATH)/SeeeduinoNRF52.mk
            -include $(MAKEFILE_PATH)/SeeeduinoMBED.mk

#             SiliconLabs
            -include $(MAKEFILE_PATH)/SiliconLabs.mk

#             STM32duino
            -include $(MAKEFILE_PATH)/STM32duino.mk

#             Teensy
            -include $(MAKEFILE_PATH)/Teensy.mk
        endif # ARDUINO_APP

#         Energia IDE and supported boards
        ifneq ($(ENERGIA_APP),)
            -include $(MAKEFILE_PATH)/EnergiaMSP430_12.mk
            -include $(MAKEFILE_PATH)/EnergiaMSP430ELF.mk
            -include $(MAKEFILE_PATH)/EnergiaMSP430_19.mk
            -include $(MAKEFILE_PATH)/EnergiaMSP430.mk
            -include $(MAKEFILE_PATH)/EnergiaMSP432_R_EMT.mk
#            -include $(MAKEFILE_PATH)/EnergiaMSP432EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaMSP432_E_EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaMSP432_P_EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaTIVAC.mk
            -include $(MAKEFILE_PATH)/EnergiaCC3200.mk
            -include $(MAKEFILE_PATH)/EnergiaCC3200EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaCC3200EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaCC3220EMT.mk
#            -include $(MAKEFILE_PATH)/EnergiaC2000.mk
            -include $(MAKEFILE_PATH)/EnergiaCC1300EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaCC13x2EMT.mk
            -include $(MAKEFILE_PATH)/EnergiaCC2600EMT.mk
        endif # ENERGIA_APP

    endif # GCC_PREPROCESSOR_DEFINITIONS

    ifeq ($(MAKEFILE_NAME),)
        ifneq ($(strip $(BOARD_TAG)),0)
            $(info ERROR             $(BOARD_TAG) board is not defined)
            $(info .)
            $(call MESSAGE_GUI_ERROR,$(BOARD_TAG) board is not defined)
            $(error Stop)
        else
            $(info ERROR             $(BOARD_TAG) board is unknown)
            $(info .)
            $(call MESSAGE_GUI_ERROR,$(BOARD_TAG) board is unknown)
            $(error Stop)
        endif # BOARD_TAG 0
    endif # MAKEFILE_NAME

# Information on makefile
#
    $(eval MAKEFILE_RELEASE = $(shell grep $(MAKEFILE_PATH)/$(MAKEFILE_NAME).mk -e '^# Last update' | xargs | rev | cut -d\  -f1-2 | rev ))
endif # BOOL_SELECT_BOARD

# Step 2
#
include $(MAKEFILE_PATH)/Step2.mk
