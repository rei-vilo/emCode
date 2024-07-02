#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2024
# All rights reserved
#
# Last update: 29 Jan 2020 release 11.6.5
#

ifeq ($(MAKEFILE_NAME),)

ARDUINO_SAM_INITIAL = $(ARDUINO_PACKAGES_PATH)/arduino

ifneq ($(wildcard $(ARDUINO_SAM_INITIAL)/hardware/sam),)
    ARDUINO_SAM_APP = $(ARDUINO_SAM_INITIAL)
    ARDUINO_SAM_PATH = $(ARDUINO_SAM_APP)
    ARDUINO_SAM_BOARDS = $(ARDUINO_SAM_APP)/hardware/sam/$(ARDUINO_SAM_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_SAM_BOARDS)),)
MAKEFILE_NAME = ArduinoSAM
RELEASE_CORE = $(ARDUINO_SAM_RELEASE)

# ArduinoCC 1.6.5 SAM specifics
# ----------------------------------
#
PLATFORM := Arduino
BUILD_CORE := sam
SUB_PLATFORM := sam
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_SAM EMCODE=$(RELEASE_NOW) ARDUINO_$(BUILD_BOARD) $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS))
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := SAM $(ARDUINO_SAM_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ARDUINO_SAM_PATH)/hardware/sam/$(ARDUINO_SAM_RELEASE)
TOOL_CHAIN_PATH = $(ARDUINO_SAM_PATH)/tools/arm-none-eabi-gcc/$(ARDUINO_GCC_ARM_RELEASE)
OTHER_TOOLS_PATH = $(ARDUINO_SAM_PATH)/tools

# New GCC for ARM tool-suite
#
APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin

CORE_LIB_PATH := $(HARDWARE_PATH)/cores/arduino
APP_LIB_PATH := $(HARDWARE_PATH)/libraries
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt
BUILD_BOARD = $(call PARSE_BOARD,$(BOARD_TAG),build.board)

FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name \*.S.o)
# FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name variant.cpp.o)
# FIRST_O_IN_A = $(filter %/variant.cpp.o,$(BUILD_CORE_OBJS))

VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)
VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp) # $(VARIANT_PATH)/*/*.cpp
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
# VARIANT_OBJS = $(patsubst $(VARIANT_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

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

#
# Uploader bossac tested by Mike Roberts
# Uploader openocd tested by Peter
#
ifeq ($(UPLOADER),openocd)
# openocd -f interface/cmsis-dap.cfg -f target/at91sam3ax_8x.cfg -c "program $(BINARY_SPECIFIC_NAME).bin verify srst_only 0x00080000; shutdown" -d2
    UPLOADER = openocd
#    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/openocd/$(ARDUINO_OPENOCD_RELEASE)
#    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    UPLOADER_EXEC = openocd
    UPLOADER_OPTS = -d2
#    UPLOADER_PATH = -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f interface/cmsis-dap.cfg -f target/at91sam3ax_8x.cfg
    UPLOADER_COMMAND = program {$(TARGET_BIN)}} verify srst_only 0x00080000; shutdown
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "$(UPLOADER_COMMAND)"

else ifeq ($(UPLOADER),jlink)
    UPLOADER = jlink
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    UPLOADER_OPTS = -device ATSAM3X8E -if swd -speed 4000 -commanderscript $(BUILDS_PATH)/upload.jlink

# Prepare the .jlink scripts
    COMMAND_PRE_UPLOAD = printf 'r\nloadfile \"$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex\"\ng\nexit\n' > '$(BUILDS_PATH)/upload.jlink'
    COMMAND_PRE_UPLOAD += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

#    JLINK_POWER = 1
    JLINK_POWER ?= 0
    ifeq ($(JLINK_POWER),1)
        COMMAND_POWER = $(UPLOADER_EXEC) $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/power.jlink'
    endif

    DEBUG_SERVER_PATH = $(SEGGER_PATH)/JLink
    DEBUG_SERVER_EXEC = $(DEBUG_SERVER_PATH)/JLinkGDBServer
# J-Link port 3333 for compatibility with OpenOCD
    DEBUG_SERVER_OPTS = -device ATSAM3X8E -if swd -speed 4000 -port 3333

else ifeq ($(UPLOADER),ozone)
    UPLOADER = ozone

# Ozone no longer seems to upload the executable
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    SHARED_OPTS = -device ATSAM3X8E -if swd -speed 4000
    UPLOADER_OPTS = $(SHARED_OPTS) -commanderscript $(BUILDS_PATH)/upload.jlink

    COMMAND_PRE_UPLOAD = printf 'r\nloadfile \"$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex\"\ng\nexit\n' > $(BUILDS_PATH)/upload.jlink

    DEBUGGER_PATH = $(SEGGER_PATH)/Ozone
    DEBUGGER_EXEC = open $(DEBUGGER_PATH)/Ozone.app
    DEBUGGER_OPTS = --args $(BUILDS_PATH)/ozone.jdebug

else
    UPLOADER = bossac
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/bossac/$(ARDUINO_BOSSAC_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bossac
    UPLOADER_PORT = $(subst /dev/,,$(AVRDUDE_PORT))
    UPLOADER_OPTS = -i --port=$(UPLOADER_PORT) -U $(call PARSE_BOARD,$(BOARD_TAG),upload.native_usb) -e -w -v -b
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_BIN) -R
endif

# Tool-chain names
#
CC = $(APP_TOOLS_PATH)/arm-none-eabi-gcc
CXX = $(APP_TOOLS_PATH)/arm-none-eabi-g++
AR = $(APP_TOOLS_PATH)/arm-none-eabi-ar
OBJDUMP = $(APP_TOOLS_PATH)/arm-none-eabi-objdump
OBJCOPY = $(APP_TOOLS_PATH)/arm-none-eabi-objcopy
SIZE = $(APP_TOOLS_PATH)/arm-none-eabi-size
NM = $(APP_TOOLS_PATH)/arm-none-eabi-nm
GDB = $(APP_TOOLS_PATH)/arm-none-eabi-gdb

# Specific AVRDUDE location and options
#
AVRDUDE_COM_OPTS = -D -p$(MCU) -C$(AVRDUDE_CONF)

BOARD = $(call PARSE_BOARD,$(BOARD_TAG),board)
LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)

SYSTEM_LIB = $(call PARSE_BOARD,$(BOARD_TAG),build.variant_system_lib)
SYSTEM_PATH = $(VARIANT_PATH)
SYSTEM_OBJS = $(SYSTEM_PATH)/$(SYSTEM_LIB)

# Two locations for Arduino libraries
#
APP_LIB_PATH = $(HARDWARE_PATH)/libraries

sam165_00 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
sam165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
sam165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
sam165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
sam165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
sam165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

APP_LIB_CPP_SRC = $(foreach dir,$(sam165_00),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(sam165_00),$(wildcard $(dir)/*.c))
APP_LIB_H_SRC = $(foreach dir,$(sam165_00),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(sam165_00),$(wildcard $(dir)/*.hpp))

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIB_PATH = $(APPLICATION_PATH)/libraries

sam165_10 = $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
sam165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
sam165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
sam165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
sam165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
sam165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

BUILD_APP_LIB_CPP_SRC = $(foreach dir,$(sam165_10),$(wildcard $(dir)/*.cpp))
BUILD_APP_LIB_C_SRC = $(foreach dir,$(sam165_10),$(wildcard $(dir)/*.c))
BUILD_APP_LIB_H_SRC = $(foreach dir,$(sam165_10),$(wildcard $(dir)/*.h))
BUILD_APP_LIB_H_SRC += $(foreach dir,$(sam165_10),$(wildcard $(dir)/*.hpp))

BUILD_APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(BUILD_APP_LIB_CPP_SRC))
BUILD_APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(BUILD_APP_LIB_C_SRC))

APP_LIBS_LOCK = 1

CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)

# # sam165_20 = $(filter-out %main.cpp, $(wildcard $(CORE_LIB_PATH)/*.cpp $(CORE_LIB_PATH)/*/*.cpp $(CORE_LIB_PATH)/*/*/*.cpp $(CORE_LIB_PATH)/*/*/*/*.cpp))
sam165_20 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(sam165_20))

CORE_AS_SRCS = $(wildcard $(CORE_LIB_PATH)/*.S)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS_SRCS)))
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %s, $(CORE_AS_SRCS)))

CORE_OBJ_FILES += $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
#    CORE_OBJS += $(patsubst $(CORE_LIB_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
# CORE_OBJS += $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
CORE_OBJS += $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

# MCU options
#
MCU_FLAG_NAME = mcpu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)

# Arduino Due USB PID VID
#
USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)

USB_FLAGS = -DUSB_VID=$(USB_VID)
USB_FLAGS += -DUSB_PID=$(USB_PID)
USB_FLAGS += -DUSBCON
USB_FLAGS += -DUSB_MANUFACTURER=\"$(USB_VENDOR)\"
USB_FLAGS += -DUSB_PRODUCT=\"$(USB_PRODUCT)\"

ifeq ($(UPLOADER),jlink)

else
# Adafruit Feather serial 1200 reset
#
    USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)
    USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
endif

ifeq ($(MAKECMDGOALS),debug)
	OPTIMISATION ?= -Os -g
#    OPTIMISATION ?= -Os -g
else
    OPTIMISATION ?= -Os -g3
endif

INCLUDE_PATH = $(CORE_LIB_PATH) $(APP_LIB_PATH) $(VARIANT_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))
INCLUDE_PATH += $(HARDWARE_PATH)/system
INCLUDE_PATH += $(HARDWARE_PATH)/system/libsam
# INCLUDE_PATH += $(HARDWARE_PATH)/system/libsam/include
INCLUDE_PATH += $(HARDWARE_PATH)/system/CMSIS/CMSIS/Include/
INCLUDE_PATH += $(HARDWARE_PATH)/system/CMSIS/Device/ATMEL/

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
FLAGS_ALL += -ffunction-sections -fdata-sections -nostdlib -mthumb
FLAGS_ALL += --param max-inline-insns-single=500
# FLAGS_ALL += $(addprefix -D, printf=iprintf $(PLATFORM_TAG))
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG))
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
FLAGS_C = -std=gnu11

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = -fno-rtti -fno-exceptions -fno-threadsafe-statics -std=gnu++11

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU)
FLAGS_LD += -T $(VARIANT_PATH)/$(LDSCRIPT) -mthumb
FLAGS_LD += -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map
FLAGS_LD += -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections
FLAGS_LD += -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align
FLAGS_LD += -Wl,--entry=Reset_Handler -Wl,--gc-sections
# FLAGS_LD += -lm -Wl,--gc-sections,-u,main

UFLAGS = -u _sbrk -u link -u _close -u _fstat -u _isatty -u _lseek -u _read -u _write -u _exit -u kill -u _getpid

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -v -Obinary

# Commands
# ----------------------------------
# Link command
#
FIRST_O_IN_LD = $$(find $(BUILDS_PATH) -name syscalls_sam3.c.o)
COMMAND_LINK = $(CC) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) -Wl,--start-group $(UFLAGS) $(FIRST_O_IN_LD) $(SYSTEM_OBJS) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) -Wl,--end-group -lm -lgcc

# Upload command
#
# COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_BIN) -R

# Target
#
TARGET_HEXBIN = $(TARGET_BIN)
TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex

endif

endif # MAKEFILE_NAME

