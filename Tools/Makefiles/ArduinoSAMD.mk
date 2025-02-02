#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Last update: 02 Jul 2024 release 14.4.7
#

ifeq ($(MAKEFILE_NAME),)

ARDUINO_SAMD_INITIAL = $(ARDUINO_PACKAGES_PATH)/arduino

ifneq ($(wildcard $(ARDUINO_SAMD_INITIAL)/hardware/samd),)
    ARDUINO_SAMD_APP = $(ARDUINO_SAMD_INITIAL)
    ARDUINO_SAMD_PATH = $(ARDUINO_SAMD_APP)
    ARDUINO_SAMD_BOARDS = $(ARDUINO_SAMD_APP)/hardware/samd/$(ARDUINO_SAMD_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_SAMD_BOARDS)),)
MAKEFILE_NAME = ArduinoSAMD
RELEASE_CORE = $(ARDUINO_SAMD_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# # Release check
# # ----------------------------------
# #
# REQUIRED_ARDUINO_SAMD_RELEASE = 1.8.11
# ifeq ($(shell if [[ '$(ARDUINO_SAMD_RELEASE)' > '$(REQUIRED_ARDUINO_SAMD_RELEASE)' ]] || [[ '$(ARDUINO_SAMD_RELEASE)' = '$(REQUIRED_ARDUINO_SAMD_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
# $(error Arduino SAMD release $(REQUIRED_ARDUINO_SAMD_RELEASE) or later required, release $(ARDUINO_SAMD_RELEASE) installed)
# endif

# Arduino 1.8.0 SAMD specifics
# ----------------------------------
#
PLATFORM := Arduino
BUILD_CORE := samd
SUB_PLATFORM := samd
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_SAMD EMCODE=$(RELEASE_NOW) ARDUINO_$(BUILD_BOARD) $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS))
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := SAMD $(ARDUINO_SAMD_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ARDUINO_SAMD_PATH)/hardware/samd/$(ARDUINO_SAMD_RELEASE)
TOOL_CHAIN_PATH = $(ARDUINO_SAMD_PATH)/tools/arm-none-eabi-gcc/$(ARDUINO_GCC_ARM_RELEASE)
CMSIS_PATH = $(ARDUINO_SAMD_PATH)/tools/CMSIS/$(ARDUINO_CMSIS_RELEASE)
CMSIS_ATMEL_PATH = $(ARDUINO_SAMD_PATH)/tools/CMSIS-Atmel/$(ARDUINO_CMSIS_ATMEL_RELEASE)/CMSIS
OTHER_TOOLS_PATH = $(ARDUINO_SAMD_PATH)/tools

# New GCC for ARM tool-suite
APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin

CORE_LIB_PATH := $(HARDWARE_PATH)/cores/arduino
APP_LIB_PATH := $(HARDWARE_PATH)/libraries
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt
BUILD_BOARD = $(call PARSE_BOARD,$(BOARD_TAG),build.board)

# FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name variant.cpp.o)

VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)
VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp) # $(VARIANT_PATH)/*/*.cpp
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
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

# Uploader openocd or avrdude
# UPLOADER defined in .mk
#
ifeq ($(BOARD_PORT),ssh)
    UPLOADER = ssh
else
    ifeq ($(UPLOADER),avrdude)
        UPLOADER = avrdude
        USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
        AVRDUDE_COM_OPTS = -p$(AVRDUDE_MCU) -C$(AVRDUDE_CONF)
        AVRDUDE_OPTS = -c$(AVRDUDE_PROGRAMMER) -b$(AVRDUDE_BAUDRATE)

# Regression test for M0 Pro (Native USB Port) / AVRdude
        ifeq ($(BOARD_TAG),mzero_pro_bl)
            M0_SERIAL_PORT = /dev/tty.usbmodem0041
            COMMAND_UPLOAD = $(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -P$(M0_SERIAL_PORT) -Uflash:w:$(TARGET_HEX):i
        endif
    else ifeq ($(UPLOADER),bossac)
        USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
        UPLOADER = bossac
        UPLOADER_PATH = $(OTHER_TOOLS_PATH)/bossac/$(ARDUINO_BOSSAC_RELEASE)
        UPLOADER_EXEC = $(UPLOADER_PATH)/bossac
        UPLOADER_PORT = $(subst /dev/,,$(AVRDUDE_PORT))
        UPLOADER_OPTS = -i -d --port=$(UPLOADER_PORT) -U $(call PARSE_BOARD,$(BOARD_TAG),upload.native_usb) -i -e -w -v
        DELAY_BEFORE_UPLOAD = 2
        DELAY_BEFORE_SERIAL = 2
    else ifeq ($(UPLOADER),jlink)

        UPLOADER = jlink

# Prepare the .jlink scripts
        COMMAND_PRE_UPLOAD = printf 'r\nloadfile "$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex"\ng\nexit\n' > '$(BUILDS_PATH)/upload.jlink' ;
        COMMAND_PRE_UPLOAD += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

        UPLOADER_PATH := /usr/bin
        UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
        UPLOADER_OPTS += -device ATSAMD21G18A -if swd -speed 2000 
        COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -commanderscript $(BUILDS_PATH)/upload.jlink

    else # UPLOADER

        UPLOADER = openocd
        UPLOADER_PATH := $(OTHER_TOOLS_PATH)/openocd/$(ARDUINO_SAMD_OPENOCD_RELEASE)
        UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
# UPLOADER_OPTS = -d3
        UPLOADER_OPTS = -s $(UPLOADER_PATH)/share/openocd/scripts/
        UPLOADER_OPTS += -f $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.openocdscript)

# boards.txt no longer sets bootloader.size on SAMD 1.6.16
# platform.txt now sets tools.openocd.upload.pattern with verify reset 0x2000
        BOOTLOADER_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),bootloader.size)
        ifeq ($(BOOTLOADER_SIZE),)
            BOOTLOADER_SIZE = 0x2000
        endif
        UPLOADER_COMMAND = telnet_port disabled; program {$(TARGET_BIN)} verify reset $(BOOTLOADER_SIZE); shutdown
#       UPLOADER_COMMAND = verify reset $(call PARSE_BOARD,$(BOARD_TAG),build.section.start) exit
        COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "$(UPLOADER_COMMAND)"

    endif # UPLOADER
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
BOARD = $(call PARSE_BOARD,$(BOARD_TAG),board)
LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)

SYSTEM_LIB = $(call PARSE_BOARD,$(BOARD_TAG),build.variant_system_lib)
SYSTEM_PATH = $(VARIANT_PATH)
SYSTEM_OBJS = $(SYSTEM_PATH)/$(SYSTEM_LIB)

# Two locations for application libraries
#
APP_LIB_PATH = $(HARDWARE_PATH)/libraries

samd165_00 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
samd165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
samd165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
samd165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
samd165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
samd165_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

APP_LIB_CPP_SRC = $(foreach dir,$(samd165_00),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(samd165_00),$(wildcard $(dir)/*.c))
APP_LIB_H_SRC = $(foreach dir,$(samd165_00),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(samd165_00),$(wildcard $(dir)/*.hpp))

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIB_PATH = $(APPLICATION_PATH)/libraries

samd165_10 = $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
samd165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
samd165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
samd165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
samd165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
samd165_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

BUILD_APP_LIB_CPP_SRC = $(foreach dir,$(samd165_10),$(wildcard $(dir)/*.cpp))
BUILD_APP_LIB_C_SRC = $(foreach dir,$(samd165_10),$(wildcard $(dir)/*.c))
BUILD_APP_LIB_H_SRC = $(foreach dir,$(samd165_10),$(wildcard $(dir)/*.h))
BUILD_APP_LIB_H_SRC += $(foreach dir,$(samd165_10),$(wildcard $(dir)/*.hpp))

BUILD_APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(BUILD_APP_LIB_CPP_SRC))
BUILD_APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(BUILD_APP_LIB_C_SRC))

APP_LIBS_LOCK = 1

# One location for core libraries
#
CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)

# # samd165_20 = $(filter-out %main.cpp, $(wildcard $(CORE_LIB_PATH)/*.cpp $(CORE_LIB_PATH)/*/*.cpp $(CORE_LIB_PATH)/*/*/*.cpp $(CORE_LIB_PATH)/*/*/*/*.cpp))
samd165_20 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(samd165_20))

CORE_AS_SRCS = $(wildcard $(CORE_LIB_PATH)/*.S)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS_SRCS)))
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %s, $(CORE_AS_SRCS)))

CORE_OBJ_FILES += $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
# CORE_OBJS += $(patsubst $(CORE_LIB_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
# CORE_OBJS += $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
CORE_OBJS += $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

# MCU options
#
MCU_FLAG_NAME = mcpu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)

# Arduino Zero Pro USB PID VID
#
USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

ifeq ($(USB_VENDOR),)
    USB_VENDOR = "Arduino"
endif

USB_FLAGS = -DUSB_VID=$(USB_VID)
USB_FLAGS += -DUSB_PID=$(USB_PID)
USB_FLAGS += -DUSBCON
USB_FLAGS += -DUSB_MANUFACTURER='$(USB_VENDOR)'
USB_FLAGS += -DUSB_PRODUCT='$(USB_PRODUCT)'

# Arduino Due serial 1200 reset
#
USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)
# USB_RESET = python $(UTILITIES_PATH)/reset_1200.py

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION ?= -ggdb -g3
else
    OPTIMISATION ?= -Os -g3
endif

# INCLUDE_PATH = $(APPLICATION_PATH)/hardware/arduino/samd/system/libsam
# INCLUDE_PATH += $(APPLICATION_PATH)/hardware/arduino/samd/system/libsam/include
# INCLUDE_PATH += $(APPLICATION_PATH)/hardware/tools/CMSIS/CMSIS/Include/
# INCLUDE_PATH += $(APPLICATION_PATH)/hardware/tools/CMSIS/Device/ATMEL/
INCLUDE_PATH += $(CMSIS_PATH)/CMSIS/Include
INCLUDE_PATH += $(CMSIS_ATMEL_PATH)/Device/ATMEL
INCLUDE_PATH += $(CORE_LIB_PATH) $(VARIANT_PATH)
INCLUDE_PATH += $(CORE_LIB_PATH)/api/deprecated
INCLUDE_PATH += $(CORE_LIB_PATH)/api/deprecated-avr-comp
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))

samd1000a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
FLAGS_MORE = $(filter-out {build.usb_flags}, $(samd1000a))

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
FLAGS_ALL += -ffunction-sections -fdata-sections -nostdlib
FLAGS_ALL += --param max-inline-insns-single=500
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) # printf=iprintf
FLAGS_ALL += $(FLAGS_MORE) -MMD
FLAGS_ALL += -mthumb $(USB_FLAGS)
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
FLAGS_C = -std=gnu11

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = -std=gnu++11 -fno-rtti -fno-exceptions -fno-threadsafe-statics

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING) -Wl,--gc-sections -save-temps
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU) --specs=nano.specs --specs=nosys.specs
FLAGS_LD += -T $(VARIANT_PATH)/$(LDSCRIPT) -mthumb
FLAGS_LD += -Wl,--cref -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map # Output a cross reference table.
FLAGS_LD += -Wl,--check-sections -Wl,--gc-sections
FLAGS_LD += -Wl,--unresolved-symbols=report-all
FLAGS_LD += -Wl,--warn-common -Wl,--warn-section-align
# FLAGS_LD += -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handl er
# FLAGS_LD += -Wl,--unresolved-symbols=report-all
# FLAGS_LD += -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols
# FLAGS_LD += -Wl,--section-start=.text=$(call PARSE_BOARD,$(BOARD_TAG),build.section.start)

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -v -Obinary

FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name pulse_asm.S.o)

# Commands
# ----------------------------------
# Link command
#
# FIRST_O_IN_LD = $$(find $(BUILDS_PATH) -name syscalls.c.o)
# FIRST_O_IN_LD = $(shell find . -name syscalls.c.o)

COMMAND_LINK = $(CC) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--start-group -L$(CMSIS_PATH)/CMSIS/Lib/GCC/ -larm_cortexM0l_math -lm $(TARGET_CORE_A) $(TARGET_A) -Wl,--end-group

# Target
#
TARGET_HEXBIN = $(TARGET_BIN)
TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex

endif

endif # MAKEFILE_NAME

