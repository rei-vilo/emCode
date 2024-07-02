#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2024
# All rights reserved
#
# Last update: 19 Jul 2023 release 14.1.5
#

# Teensy 3.x and 4.x specifics
# ----------------------------------
#
BUILD_CORE := arm

HARDWARE_PATH = $(TEENSY_PATH)/hardware/avr/$(TEENSY_RELEASE)

TOOL_CHAIN_PATH := $(TEENSY_PATH)/tools/teensy-compile/$(TEENSY_GCC_ARM_RELEASE)/arm
APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(HARDWARE_PATH)/cores/$(BUILD_SUBCORE)
TEENSY_TOOLS_PATH = $(TEENSY_PATH)/tools/teensy-tools/$(TEENSY_TOOLS_RELEASE)
# APP_LIB_PATH := $(APPLICATION_PATH)/hardware/teensy/avr/libraries

# See https://koromix.dev/tytools
ifeq ($(UPLOADER),tytools)

    UPLOADER_PATH = $(shell which tycmd)
    UPLOADER_EXEC = $(UPLOADER_PATH)

    COMMAND_UPLOAD = $(UPLOADER_EXEC) upload $(TARGET_HEX)
    DELAY_AFTER_UPLOAD ?= 2

    COMMAND_SERIAL = $(UPLOADER_EXEC) monitor

else # General case

t400 = $(call PARSE_BOARD,$(BOARD_TAG),upload.tool)
# upload.tool gives teensyloader instead of teensy_flash
ifeq ($(t400),teensyloader)
    UPLOADER = teensy_flash

    UPLOADER_PATH = $(TEENSY_TOOLS_PATH)
    UPLOADER_EXEC = $(UPLOADER_PATH)/teensy_post_compile
#    TEENSY_REBOOT = $(UPLOADER_PATH)/teensy_reboot
#    COMMAND_PRE_UPLOAD = $(UPLOADER_EXEC) -file=$(basename $(notdir $(TARGET_HEX))) -path="$(BUILDS_PATH)" -tools=$(abspath $(UPLOADER_PATH)) -board=$(call PARSE_BOARD,$(BOARD_TAG),build.board)
#    COMMAND_PRE_UPLOAD = cp $(TARGET_HEX) . ; $(UPLOADER_EXEC) -file=$(basename $(notdir $(TARGET_HEX))) -path=$(CURRENT_DIR) -tools=$(abspath $(UPLOADER_PATH)) -board=$(call PARSE_BOARD,$(BOARD_TAG),build.board) ; rm $(CURRENT_DIR)/*.hex
#    DELAY_BEFORE_UPLOAD ?= 2
#    COMMAND_UPLOAD = $(TEENSY_REBOOT)
    t410 = $(shell $(UPLOADER_PATH)/teensy_ports -L | cut -d' ' -f 1 | sed 's:.*/usb:usb:')

    ifneq ($(t410),)
        TEENSY_UPLOAD_OPTION = -port=$(t410)
    endif # TEENSY_UPLOAD_PORT
    COMMAND_UPLOAD = $(UPLOADER_EXEC) -file=$(basename $(notdir $(TARGET_HEX))) -path=$(BUILDS_PATH) -tools=$(abspath $(UPLOADER_PATH)) -board=$(call PARSE_BOARD,$(BOARD_TAG),build.board) $(TEENSY_UPLOAD_OPTION) -reboot 
    DELAY_AFTER_UPLOAD ?= 4
    COMMAND_CONCLUDE = $(UPLOADER_PATH)/teensy_reboot ; sleep 2 ; killall teensy
endif

endif # UPLOADER

# Generate main.cpp
# ----------------------------------
#
ifneq ($(strip $(KEEP_MAIN)),true)
$(shell echo "// " > ./main.cpp)
$(shell echo "// main.cpp generated by emCode" >> ./main.cpp)
ifneq ($(BUILD_SUBCORE),teensy4)
    $(shell echo "// from $(CORE_LIB_PATH)" >> ./main.cpp)
else
    $(shell echo "// No main.cpp for $(BUILD_SUBCORE)" >> ./main.cpp)
endif
$(shell echo "// at $$(date +'%d %b %Y %T')" >> ./main.cpp)
$(shell echo "// ----------------------------------" >> ./main.cpp)
$(shell echo "// DO NOT EDIT THIS FILE." >> ./main.cpp)
$(shell echo "// ----------------------------------" >> ./main.cpp)
$(shell echo "#if defined(EMCODE)" >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
ifneq ($(BUILD_SUBCORE),teensy4)
$(shell cat $(CORE_LIB_PATH)/main.cpp >> ./main.cpp)
endif
$(shell echo " " >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
$(shell echo "#include \"$(PROJECT_NAME_AS_IDENTIFIER).$(SKETCH_EXTENSION)\"" >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
$(shell echo "#endif // EMCODE" >> ./main.cpp)
endif

# Add .S files required by Teensyduino 1.21
#
CORE_AS_SRCS = $(filter-out %main.cpp, $(wildcard $(CORE_LIB_PATH)/*.S))
t001 = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS_SRCS)))
FIRST_O_IN_CORE_A = $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(t001))

BUILD_CORE_LIB_PATH = $(APPLICATION_PATH)/hardware/teensy/avr/cores/$(BUILD_SUBCORE)
BUILD_CORE_LIBS_LIST = $(subst .h,,$(subst $(BUILD_CORE_LIB_PATH)/,,$(wildcard $(BUILD_CORE_LIB_PATH)/*/*.h)))
BUILD_CORE_LIBS_LIST += $(subst .hpp,,$(subst $(BUILD_CORE_LIB_PATH)/,,$(wildcard $(BUILD_CORE_LIB_PATH)/*.hpp)))
BUILD_CORE_C_SRCS = $(wildcard $(BUILD_CORE_LIB_PATH)/*.c)

BUILD_CORE_CPP_SRCS = $(filter-out %program.cpp %main.cpp,$(wildcard $(BUILD_CORE_LIB_PATH)/*.cpp))

BUILD_CORE_OBJ_FILES = $(BUILD_CORE_C_SRCS:.c=.c.o) $(BUILD_CORE_CPP_SRCS:.cpp=.cpp.o)
BUILD_CORE_OBJS = $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(BUILD_CORE_OBJ_FILES))

# Sketchbook/Libraries path
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifeq ($(ARDUINO_PREFERENCES),)
    $(error Error: run Teensy once and define the sketchbook path)
endif

ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
    SKETCHBOOK_DIR = $(shell grep sketchbook.path $(ARDUINO_PREFERENCES) | cut -d = -f 2)
endif

ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
    $(error Error: sketchbook path not found)
endif

USER_LIB_PATH ?= $(wildcard $(SKETCHBOOK_DIR)/?ibraries)

# Tool-chain names
#
CC = $(APP_TOOLS_PATH)/arm-none-eabi-gcc
CXX = $(APP_TOOLS_PATH)/arm-none-eabi-g++
AR = $(APP_TOOLS_PATH)/arm-none-eabi-gcc-ar
OBJDUMP = $(APP_TOOLS_PATH)/arm-none-eabi-objdump
OBJCOPY = $(APP_TOOLS_PATH)/arm-none-eabi-objcopy
SIZE = $(APP_TOOLS_PATH)/arm-none-eabi-size
NM = $(APP_TOOLS_PATH)/arm-none-eabi-nm

LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),build.linkscript)
MCU_FLAG_NAME = mpcu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)

ifndef TEENSY_F_CPU
    ifeq ($(BOARD_TAG),teensyLC)
        TEENSY_F_CPU = 48000000
    else ifeq ($(BOARD_TAG),teensy36)
        TEENSY_F_CPU = 180000000
    else ifeq ($(BOARD_TAG),teensy35)
        TEENSY_F_CPU = 120000000
    else ifeq ($(BOARD_TAG),teensy40)
        TEENSY_F_CPU = 600000000
    else
        TEENSY_F_CPU = 96000000
    endif
endif
F_CPU = $(TEENSY_F_CPU)

ifndef TEENSY_OPTIMISATION
	TEENSY_OPTIMISATION = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flags.optimize)
endif

OPTIMISATION = $(TEENSY_OPTIMISATION)

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING) -MMD
FLAGS_ALL += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.cpu) -DF_CPU=$(F_CPU)
FLAGS_ALL += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.defs)
FLAGS_ALL += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.common)
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) $(FLAGS_D)
FLAGS_ALL += -I$(CORE_LIB_PATH) -I$(VARIANT_PATH) -I$(OBJDIR)

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
FLAGS_C = $(call PARSE_BOARD,$(BOARD_TAG),build.flags.c)

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = $(call PARSE_BOARD,$(BOARD_TAG),build.flags.cpp)

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = $(call PARSE_BOARD,$(BOARD_TAG),build.flags.S)

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
t401 = $(call PARSE_BOARD,$(BOARD_TAG),build.flags.ld)
t402 = $(subst {build.core.path},$(CORE_LIB_PATH),$(t401))
t403 = $(subst {extra.time.local},$(shell date +%s),$(t402))
FLAGS_LD = $(subst ", ,$(t403))
FLAGS_LD += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.cpu)
# FLAGS_LD += $(OPTIMISATION) $(call PARSE_BOARD,$(BOARD_TAG),build.flags.ldspecs)
FLAGS_LD += $(OPTIMISATION) # --specs=nano.specs
FLAGS_LD += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.libs)

TARGET_SYM = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).sym
TARGET_LST = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).lst
COMMAND_POST_COPY = $(TEENSY_TOOLS_PATH)/stdout_redirect $(TARGET_SYM) $(OBJDUMP) -t -C $(TARGET_ELF) ; $(TEENSY_TOOLS_PATH)/stdout_redirect $(TARGET_LST) $(OBJDUMP) -d -S -C $(TARGET_ELF)

# COMMAND_SIZE_FLASH
#
COMMAND_SIZE_FLASH = $(SIZE) --target=ihex --totals $(TARGET_ELF) | grep TOTALS | awk '{t=$$3 + $$2} END {print t}'

# COMMAND_SIZE_RAM
#
COMMAND_SIZE_RAM = $(SIZE) -A $(TARGET_ELF) | grep -e ^'\.text.itcm\|\.bss\|\.text.itcm.padding\|\.data\|\.data'\s | grep -v '^\.bss\.' | awk -F' ' '{s+=$$2}END{print s}'
