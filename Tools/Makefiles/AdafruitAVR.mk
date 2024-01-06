#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2024
# All rights reserved
#
# Last update: 16 Feb 2019 release 10.5.6
#

ifeq ($(MAKEFILE_NAME),)

ADAFRUIT_AVR_INITIAL = $(ARDUINO_PACKAGES_PATH)/adafruit

ifneq ($(wildcard $(ADAFRUIT_AVR_INITIAL)/hardware/avr),)
    ADAFRUIT_AVR_APP = $(ADAFRUIT_AVR_INITIAL)
    ADAFRUIT_AVR_PATH = $(ADAFRUIT_AVR_APP)
    ADAFRUIT_AVR_BOARDS = $(ADAFRUIT_AVR_APP)/hardware/avr/$(ADAFRUIT_AVR_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ADAFRUIT_AVR_BOARDS)),)
MAKEFILE_NAME = AdafruitAVR
RELEASE_CORE = $(ADAFRUIT_AVR_RELEASE)

# Adafruit AVR specifics
# ----------------------------------
#
PLATFORM := Adafruit AVR
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ADAFRUIT EMCODE=$(RELEASE_NOW)
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := AVR $(ADAFRUIT_AVR_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ADAFRUIT_AVR_PATH)/hardware/avr/$(ADAFRUIT_AVR_RELEASE)

# With ArduinoCC 1.6.6, AVR 1.6.9 used to be under ~/Library
TOOL_CHAIN_PATH = $(ARDUINO_AVR_PATH)/tools/avr-gcc/$(ARDUINO_GCC_AVR_RELEASE)
OTHER_TOOLS_PATH = $(ARDUINO_AVR_PATH)/tools/avrdude/$(ARDUINO_AVRDUDE_RELEASE)

# With ArduinoCC 1.6.7, AVR 1.6.9 is back under Arduino.app
ifeq ($(wildcard $(TOOL_CHAIN_PATH)),)
    TOOL_CHAIN_PATH = $(ARDUINO_PATH)/hardware/tools/avr
endif
ifeq ($(wildcard $(OTHER_TOOLS_PATH)),)
    OTHER_TOOLS_PATH = $(ARDUINO_PATH)/hardware/tools/avr
endif

BUILD_CORE = avr
SUB_PLATFORM = avr
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt

APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(APPLICATION_PATH)/hardware/arduino/$(BUILD_CORE)/cores/arduino

BUILD_CORE_LIB_PATH = $(HARDWARE_PATH)/cores
BUILD_CORE_LIBS_LIST = $(subst .h,,$(subst $(BUILD_CORE_LIB_PATH)/,,$(wildcard $(BUILD_CORE_LIB_PATH)/*.h)))
BUILD_CORE_LIBS_LIST += $(subst .hpp,,$(subst $(BUILD_CORE_LIB_PATH)/,,$(wildcard $(BUILD_CORE_LIB_PATH)/*.hpp)))
BUILD_CORE_C_SRCS = $(wildcard $(BUILD_CORE_LIB_PATH)/*.c)

BUILD_CORE_CPP_SRCS = $(filter-out %program.cpp %main.cpp,$(wildcard $(BUILD_CORE_LIB_PATH)/*.cpp))

BUILD_CORE_OBJ_FILES = $(BUILD_CORE_C_SRCS:.c=.c.o) $(BUILD_CORE_CPP_SRCS:.cpp=.cpp.o)
BUILD_CORE_OBJS = $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(BUILD_CORE_OBJ_FILES))

# Generate main.cpp
# ----------------------------------
#
ifneq ($(strip $(KEEP_MAIN)),true)
$(shell echo "// " > ./main.cpp)
$(shell echo "// main.cpp generated by emCode" >> ./main.cpp)
$(shell echo "// from $(CORE_LIB_PATH)" >> ./main.cpp)
$(shell echo "// at $$(date +'%d %b %Y %T')" >> ./main.cpp)
$(shell echo "// ----------------------------------" >> ./main.cpp)
$(shell echo "// DO NOT EDIT THIS FILE." >> ./main.cpp)
$(shell echo "// ----------------------------------" >> ./main.cpp)
$(shell echo "#if defined(EMCODE)" >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
$(shell cat $(CORE_LIB_PATH)/main.cpp >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
$(shell echo "#include \"$(PROJECT_NAME_AS_IDENTIFIER).$(SKETCH_EXTENSION)\"" >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
$(shell echo "#endif // EMCODE" >> ./main.cpp)
endif

# Two locations for Adafruit libraries
#
APP_LIB_PATH = $(APPLICATION_PATH)/libraries
APP_LIB_PATH += $(APPLICATION_PATH)/hardware/arduino/$(BUILD_CORE)/libraries

a1000 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))
a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

APP_LIB_CPP_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.c))
APP_LIB_S_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.S))
APP_LIB_H_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(a1000),$(wildcard $(dir)/*.hpp))

APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIBS_LIST = $(subst $(APP_LIB_PATH)/, ,$(APP_LIB_CPP_SRC))

APP_LIBS_LOCK = 1

a1300 = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT = $(patsubst arduino:%,%,$(a1300))

ifneq ($(wildcard $(APPLICATION_PATH)/hardware/arduino/avr/variants/$(VARIANT)),)
    VARIANT_PATH = $(APPLICATION_PATH)/hardware/arduino/avr/variants/$(VARIANT)
else
    VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)
endif

# Tool-chain names
#
CC = $(APP_TOOLS_PATH)/avr-gcc
CXX = $(APP_TOOLS_PATH)/avr-g++
AR = $(APP_TOOLS_PATH)/avr-ar
OBJDUMP = $(APP_TOOLS_PATH)/avr-objdump
OBJCOPY = $(APP_TOOLS_PATH)/avr-objcopy
SIZE = $(APP_TOOLS_PATH)/avr-size
NM = $(APP_TOOLS_PATH)/avr-nm

MCU_FLAG_NAME = mmcu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)
OPTIMISATION ?= -Os

# Adafruit Feather AVR USB PID VID
#
USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

ifneq ($(USB_VID),)
    USB_FLAGS = -DUSB_VID=$(USB_VID)
    USB_FLAGS += -DUSB_PID=$(USB_PID)
    USB_FLAGS += -DUSBCON
    USB_FLAGS += -DUSB_MANUFACTURER='$(USB_VENDOR)'
    USB_FLAGS += -DUSB_PRODUCT='$(USB_PRODUCT)'
endif

INCLUDE_PATH = $(CORE_LIB_PATH) $(APP_LIB_PATH) $(VARIANT_PATH) $(HARDWARE_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC)))
INCLUDE_PATH += $(OBJDIR)

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = -g $(OPTIMISATION) $(FLAGS_WARNING) # -w
FLAGS_ALL += -ffunction-sections -fdata-sections -MMD
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG))
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
FLAGS_C =

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = -fno-exceptions -fno-threadsafe-statics -std=gnu++11

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
FLAGS_LD = -w $(OPTIMISATION)
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU) -lm
FLAGS_LD += -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common
# FLAGS_LD += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.cpu)
# FLAGS_LD += $(OPTIMISATION) $(call PARSE_BOARD,$(BOARD_TAG),build.flags.ldspecs)
# FLAGS_LD += $(call PARSE_BOARD,$(BOARD_TAG),build.flags.libs) --verbose
FLAGS_LD += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -O ihex -R .eeprom

# Target
#
TARGET_HEXBIN = $(TARGET_HEX)
#-O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0
TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).eep

# Commands
# ----------------------------------
# Link command
#
COMMAND_LINK = $(CC) $(OUT_PREPOSITION)$@ $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) -LBuilds $(FLAGS_LD)

# Upload command
#
# COMMAND_UPLOAD = $(AVRDUDE_EXEC) -p$(AVRDUDE_MCU) -D -c$(AVRDUDE_PROGRAMMER) -C$(AVRDUDE_CONF) -Uflash:w:$(TARGET_HEX):i

endif

endif # MAKEFILE_NAME

