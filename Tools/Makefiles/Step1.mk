#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2023
# All rights reserved
#
# Last update: 12 Jan 2023 release 12.1.21
#

include $(MAKEFILE_PATH)/Step0.mk

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

ifneq ($(MULTI_INO),1)
ifneq ($(SKETCH_EXTENSION),__main_cpp_only__)
    ifneq ($(SKETCH_EXTENSION),_main_cpp_only_)
        ifneq ($(SKETCH_EXTENSION),cpp)
            ifeq ($(words $(wildcard *.$(SKETCH_EXTENSION))), 0)
                $(error No $(SKETCH_EXTENSION) sketch)
            endif # SKETCH_EXTENSION

            ifneq ($(words $(wildcard *.$(SKETCH_EXTENSION))), 1)
                $(error More than one $(SKETCH_EXTENSION) sketch)
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

# Board selection
# ----------------------------------
# Board specifics defined in .xconfig file
# BOARD_TAG and AVRDUDE_PORT
#
BOOL_SELECT_BOARD := 0
ifneq ($(filter $(MAKECMDGOALS),all build make fast debug archive unarchive upload serial),)
    BOOL_SELECT_BOARD := 1
endif # MAKECMDGOALS
BOOL_SELECT_SERIAL := 0
ifneq ($(filter $(MAKECMDGOALS),all fast debug upload serial),)
    BOOL_SELECT_SERIAL := 1
endif # MAKECMDGOALS

ifeq ($(BOOL_SELECT_BOARD),1)

    include $(CONFIGURATIONS_PATH)/$(SELECTED_BOARD).mk

    ifndef BOARD_TAG
        $(error BOARD_TAG not defined)
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

ifeq ($(ARDUINO_APP),)
    # ARDUINO_APP = $(shell which arduino-cli)
    # ARDUINO_APP := $(shell arduino-cli version)
    ARDUINO_APP = arduino-cli

endif # ARDUINO_APP

# $(info arduino-cli $(shell which arduino-cli))
# $(info arduino-cli $(shell arduino-cli version))
# $(info arduino-cli $(shell find $(APPLICATION_PATH) -name arduino-cli))
# $(info arduino-cli find $(APPLICATION_PATH) -name arduino-cli)
# $(info >>> ARDUINO_APP $(ARDUINO_APP))

# $(error sTOP)

ARDUINO_LIBRARY_PATH = $(HOME)/.arduino15
ARDUINO_PACKAGES_PATH = $(ARDUINO_LIBRARY_PATH)/packages
ARDUINO_PREFERENCES = $(ARDUINO_LIBRARY_PATH)/preferences.txt 
ARDUINO_YAML := $(ARDUINO_LIBRARY_PATH)/arduino-cli.yaml

# Sketchbook/Libraries path
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifeq ($(shell if [ -f '$(ARDUINO_YAML)' ]; then echo 1 ; fi ),1)
    SKETCHBOOK_DIR = $(shell grep 'user:' $(ARDUINO_YAML) | cut -d: -f2 | sed -e 's/ //g')
endif # SKETCHBOOK_DIR

ifeq ($(ARDUINO_PREFERENCES),)
    $(error Error: run Arduino once and define the sketchbook path)
endif # ARDUINO_LIBRARY_PATH

ifeq ($(SKETCHBOOK_DIR),)
ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),1)
    SKETCHBOOK_DIR = $(shell grep sketchbook.path $(ARDUINO_PREFERENCES) | cut -d = -f 2)
endif # SKETCHBOOK_DIR
endif # SKETCHBOOK_DIR

ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
   $(error Error: sketchbook path not found)
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
ifeq ($(wildcard $(ARDUINO_APP)),)
ifeq ($(wildcard $(ESP8266_APP)),)
ifeq ($(wildcard $(LINKIT_ARM_APP)),)
ifeq ($(wildcard $(WIRING_APP)),)
    ifeq ($(wildcard $(ENERGIA_APP)),)
    ifeq ($(wildcard $(MAPLE_APP)),)
#    ifeq ($(wildcard $(TEENSY_APP)),)
#    ifeq ($(wildcard $(GLOWDECK_APP)),)
        ifeq ($(wildcard $(DIGISTUMP_APP)),)
        ifeq ($(wildcard $(MICRODUINO_APP)),)
        ifeq ($(wildcard $(LIGHTBLUE_APP)),)
        ifeq ($(wildcard $(INTEL_APP)),)
#            ifeq ($(wildcard $(ROBOTIS_APP)),)
            ifeq ($(wildcard $(RFDUINO_APP)),)
            ifeq ($(wildcard $(REDBEARLAB_APP)),)
#            ifeq ($(wildcard $(LITTLEROBOTFRIENDS_APP)),)
                ifeq ($(wildcard $(PANSTAMP_AVR_APP)),)
                ifeq ($(wildcard $(MBED_APP)/*),)
#                ifeq ($(wildcard $(EDISON_YOCTO_APP)/*),)
#                ifeq ($(wildcard $(EDISON_MCU_APP)/*),)
                    ifeq ($(wildcard $(SPARK_APP)/*),)
                    ifeq ($(wildcard $(ADAFRUIT_AVR_APP)),)
                        $(error Error: no application found)
                    endif # ADAFRUIT_AVR_APP
                    endif # SPARK_APP
#                endif # EDISON_MCU_APP
#                endif # EDISON_YOCTO_APP
                endif # MBED_APP
                endif # PANSTAMP_AVR_APP
#            endif # LITTLEROBOTFRIENDS_APP
            endif # REDBEARLAB_APP
            endif # RFDUINO_APP
#            endif # ROBOTIS_APP
        endif # INTEL_APP
        endif # LIGHTBLUE_APP
        endif # MICRODUINO_APP
        endif # DIGISTUMP_APP
#    endif # GLOWDECK_APP
#    endif # TEENSY_APP
    endif # MAPLE_APP   
    endif # ENERGIA_APP
endif # WIRING_APP  
endif # LINKIT_ARM_APP
endif # ESP8266_APP
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
# $(info >>> ARDUINO_APP $(ARDUINO_APP))

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
        # Arduino IDE and supported boards
        ifneq ($(ARDUINO_APP),)
            # . Arduino
            -include $(MAKEFILE_PATH)/ArduinoAVR_181.mk
            -include $(MAKEFILE_PATH)/ArduinoAVR.mk
            -include $(MAKEFILE_PATH)/ArduinoMegaAVR.mk
            -include $(MAKEFILE_PATH)/ArduinoNRF52.mk
            -include $(MAKEFILE_PATH)/ArduinoSAM.mk
            -include $(MAKEFILE_PATH)/ArduinoSAMD.mk
            -include $(MAKEFILE_PATH)/ArduinoMBED_giga.mk
            -include $(MAKEFILE_PATH)/ArduinoMBED_nano.mk
#            -include $(MAKEFILE_PATH)/ArduinoMBED_pico.mk

            # . Others boards for Arduino 1.8.0
            # Adafruit
            -include $(MAKEFILE_PATH)/AdafruitAVR.mk
            -include $(MAKEFILE_PATH)/AdafruitNRF52.mk
            -include $(MAKEFILE_PATH)/AdafruitSAMD.mk

            # ESP8266 and ESP32
            -include $(MAKEFILE_PATH)/ESP8266.mk
            -include $(MAKEFILE_PATH)/ESP32.mk

            # Intel
            -include $(MAKEFILE_PATH)/IntelCurie.mk

            # Microsoft
            -include $(MAKEFILE_PATH)/MicrosoftAZ3166.mk

            # Moteino
            -include $(MAKEFILE_PATH)/Moteino.mk

            # nRF1 boards
            -include $(MAKEFILE_PATH)/nRF51_Boards.mk

            # Raspberry Pi
            -include $(MAKEFILE_PATH)/RasPiPico.mk

            # Seeeduino
            -include $(MAKEFILE_PATH)/SeeeduinoAVR.mk
            -include $(MAKEFILE_PATH)/SeeeduinoSAMD.mk
            -include $(MAKEFILE_PATH)/SeeeduinoRTL.mk
            -include $(MAKEFILE_PATH)/SeeeduinoNRF52.mk
            -include $(MAKEFILE_PATH)/SeeeduinoMBED.mk

            # STM32duino
            -include $(MAKEFILE_PATH)/STM32duino.mk

            # Teensy
            -include $(MAKEFILE_PATH)/Teensy.mk
        endif # ARDUINO_APP

        # Energia IDE and supported boards
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
            $(error $(BOARD_TAG) board is unknown)
        else
            $(error $(BOARD_TAG) board is unknown)
        endif # BOARD_TAG 0
    endif # MAKEFILE_NAME

# Information on makefile
#
    $(eval MAKEFILE_RELEASE = $(shell grep $(MAKEFILE_PATH)/$(MAKEFILE_NAME).mk -e '^# Last update' | xargs | rev | cut -d\  -f1-2 | rev ))

endif # BOOL_SELECT_BOARD

# Step 2
#
include $(MAKEFILE_PATH)/Step2.mk
