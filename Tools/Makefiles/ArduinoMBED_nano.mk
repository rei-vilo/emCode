#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2026
# All rights reserved
#
# Created: 10 Apr 2021 release 11.14.0
#
# Last update: 06 Aug 2025 release 14.7.17
#

ifeq ($(MAKEFILE_NAME),)

ARDUINO_MBED_INITIAL = $(ARDUINO_PACKAGES_PATH)/arduino

ifneq ($(wildcard $(ARDUINO_MBED_INITIAL)/hardware/mbed_nano),)
    ARDUINO_MBED_NANO_APP = $(ARDUINO_MBED_INITIAL)
    ARDUINO_MBED_NANO_PATH = $(ARDUINO_MBED_NANO_APP)
    ARDUINO_MBED_NANO_BOARDS = $(ARDUINO_MBED_NANO_APP)/hardware/mbed_nano/$(ARDUINO_MBED_NANO_RELEASE)/boards.txt
endif

# $(info === ARDUINO_MBED_NANO_BOARDS $(ARDUINO_MBED_NANO_BOARDS))
# $(info === BOARD_TAG $(BOARD_TAG))

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_MBED_NANO_BOARDS)),)
MAKEFILE_NAME = ArduinoMBED_nano
RELEASE_CORE = $(ARDUINO_MBED_NANO_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# # Release check
# # ----------------------------------
# #
# REQUIRED_ARDUINO_MBED_NANO_RELEASE = 1.9.8
# ifeq ($(shell if [[ '$(ARDUINO_MBED_NANO_RELEASE)' > '$(REQUIRED_ARDUINO_MBED_NANO_RELEASE)' ]] || [[ '$(ARDUINO_MBED_NANO_RELEASE)' = '$(REQUIRED_ARDUINO_MBED_NANO_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
# $(error Arduino MBED release $(REQUIRED_ARDUINO_MBED_NANO_RELEASE) or later required, release $(ARDUINO_MBED_NANO_RELEASE) installed)
# endif

# Arduino Mbed specifics
# ----------------------------------
#
PLATFORM := Arduino Mbed-OS
BUILD_CORE := mbed
SUB_PLATFORM := mbed
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_MBED ARDUINO_ARCH_MBED_NANO EMCODE=$(RELEASE_NOW) ARDUINO_$(BUILD_BOARD) $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS))
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := Nano $(ARDUINO_MBED_NANO_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ARDUINO_MBED_NANO_PATH)/hardware/mbed_nano/$(ARDUINO_MBED_NANO_RELEASE)
TOOL_CHAIN_PATH = $(ARDUINO_MBED_NANO_PATH)/tools/arm-none-eabi-gcc/$(ARDUINO_GCC_ARM_RELEASE)
OTHER_TOOLS_PATH = $(ARDUINO_MBED_NANO_PATH)/tools

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
MAIN_LOCK = false

# Uploader openocd or bossac
# UPLOADER defined in .mk
#
ifeq ($(UPLOADER),cp_uf2)
    USB_RESET = stty -F
    UPLOADER = cp_uf2
    TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
    COMMAND_PRE_UPLOAD = $(OTHER_TOOLS_PATH)/rp2040tools/$(ARDUINO_PICO_TOOLS_RELEASE)/elf2uf2 $(TARGET_ELF) $(TARGET_BIN_CP)
#     USED_VOLUME_PORT = $(shell ls -d $(BOARD_VOLUME))
    USED_VOLUME_PORT = $(strip $(BOARD_VOLUME))

else ifeq ($(UPLOADER),bossac)
    USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
    UPLOADER = bossac
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/bossac/$(ARDUINO_MBED_BOSSAC_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bossac
    UPLOADER_PORT = $(subst /dev/,,$(AVRDUDE_PORT))
    UPLOADER_OPTS = -d --port=$(UPLOADER_PORT) -U -i -e -w
    DELAY_BEFORE_UPLOAD = 2
    # unused DELAY_BEFORE_SERIAL = 2

else ifeq ($(UPLOADER),dfu-util)
# tools.dfu-util.upload.pattern="{path}/{cmd}" --device {upload.vid}:{upload.pid} -D "{build.path}/{build.project_name}.bin" -a{upload.interface} --dfuse-address={upload.address}:leave

    UPLOADER = dfu-util
    USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/dfu-util/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/dfu-util
    UPLOADER_OPTS = $(UPLOADER_PATH)
    UPLOADER_OPTS += --device $(call PARSE_BOARD,$(BOARD_TAG),upload.vid):$(call PARSE_BOARD,$(BOARD_TAG),upload.pid)
    UPLOADER_OPTS += -a$(call PARSE_BOARD,$(BOARD_TAG),upload.interface)
    UPLOADER_OPTS += -dfuse-address=$(call PARSE_BOARD,$(BOARD_TAG),upload.address):leave
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -D $(TARGET_BIN)

else # UPLOADER

# tools.openocd.upload.pattern="{path}/{cmd}" {upload.verbose} -s "{path}/share/openocd/scripts/" {bootloader.programmer} {upload.transport} {bootloader.config} -c "telnet_port disabled; init; reset init; halt; adapter speed 10000; program {{build.path}/{build.project_name}.elf}; reset run; shutdown"
    UPLOADER = openocd
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/openocd/$(ARDUINO_MBED_OPENOCD_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
# UPLOADER_OPTS = -d3
    UPLOADER_OPTS = -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.openocdscript)

# nano33ble.bootloader.extra_action.preflash=nrf5 mass_erase
# nano33ble.bootloader.config=-f target/nrf52.cfg
# nano33ble.bootloader.programmer=-f interface/cmsis-dap.cfg
# nano33ble.bootloader.file=nano33ble/bootloader.hex
# boards.txt no longer sets bootloader.size on SAMD 1.6.16
# platform.txt now sets tools.openocd.upload.pattern with verify reset 0x2000
#        BOOTLOADER_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),bootloader.size)
#        ifeq ($(BOOTLOADER_SIZE),)
#            BOOTLOADER_SIZE = 0x2000
#        endif

endif # UPLOADER

# Tool-chain names
#
COMPILER_PREFIX = arm-none-eabi
COMPILER_LOCK = false

# Now defined at Step2.mk
# CC = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-gcc
# CXX = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-g++
# AR = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-ar
# OBJDUMP = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-objdump
# OBJCOPY = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-objcopy
# SIZE = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-size
# NM = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-nm
# GDB = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-gdb


# Specific AVRDUDE location and options
#
# unused BOARD= $(call PARSE_BOARD,$(BOARD_TAG),board)
LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)

SYSTEM_LIB = $(call PARSE_BOARD,$(BOARD_TAG),build.variant_system_lib)
SYSTEM_PATH = $(VARIANT_PATH)
SYSTEM_OBJS = $(SYSTEM_PATH)/$(SYSTEM_LIB)

# Two locations for application libraries
#
APP_LIB_PATH = $(HARDWARE_PATH)/libraries

WORK_0 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

APP_LIB_CPP_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.c))
APP_LIB_H_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.hpp))

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIB_PATH = $(APPLICATION_PATH)/libraries

WORK_1 = $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
WORK_1 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
WORK_1 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
WORK_1 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
WORK_1 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
WORK_1 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

BUILD_APP_LIB_CPP_SRC = $(foreach dir,$(WORK_1),$(wildcard $(dir)/*.cpp))
BUILD_APP_LIB_C_SRC = $(foreach dir,$(WORK_1),$(wildcard $(dir)/*.c))
BUILD_APP_LIB_H_SRC = $(foreach dir,$(WORK_1),$(wildcard $(dir)/*.h))
BUILD_APP_LIB_H_SRC += $(foreach dir,$(WORK_1),$(wildcard $(dir)/*.hpp))

BUILD_APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(BUILD_APP_LIB_CPP_SRC))
BUILD_APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(BUILD_APP_LIB_C_SRC))

APP_LIBS_LOCK = 1

# One location for core libraries
#
CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)

# # WORK_2 = $(filter-out %main.cpp, $(wildcard $(CORE_LIB_PATH)/*.cpp $(CORE_LIB_PATH)/*/*.cpp $(CORE_LIB_PATH)/*/*/*.cpp $(CORE_LIB_PATH)/*/*/*/*.cpp))
WORK_2 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(WORK_2))

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

# Arduino Nano 33 BLE USB PID VID
#
USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),vid.0)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),pid.0)
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

INCLUDE_PATH = $(CORE_LIB_PATH) $(VARIANT_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))
INCLUDE_PATH += $(CORE_LIB_PATH)/api/deprecated
INCLUDE_PATH += $(CORE_LIB_PATH)/api/deprecated-avr-comp

mbed1000a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
FLAGS_MORE = $(filter-out {build.usb_flags}, $(mbed1000a))
FLAGS_MORE    += $(call PARSE_BOARD,$(BOARD_TAG),build.float-abi)
FLAGS_MORE    += $(call PARSE_BOARD,$(BOARD_TAG),build.fpu)

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) # -DF_CPU=$(F_CPU)
FLAGS_ALL += -nostdlib
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) # printf=iprintf

FLAGS_ALL += @$(VARIANT_PATH)/defines.txt
FLAGS_ALL += -iprefix$(CORE_LIB_PATH)
FLAGS_ALL += @$(VARIANT_PATH)/includes.txt

FLAGS_ALL += $(FLAGS_D)
FLAGS_ALL += $(FLAGS_MORE) -MMD
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
# FLAGS_C = -std=gnu11
FLAGS_C = @$(VARIANT_PATH)/cflags.txt

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
# FLAGS_CPP = -std=gnu++11 -fno-rtti -fno-exceptions -fno-threadsafe-statics
FLAGS_CPP = @$(VARIANT_PATH)/cxxflags.txt

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

FLAGS_D = $(call PARSE_BOARD,$(BOARD_TAG),compiler.mbed.arch.define)

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING) -Wl,--gc-sections -Wl,--as-needed
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU) --specs=nosys.specs
# --specs=nano.specs
FLAGS_LD += -T $(VARIANT_PATH)/$(LDSCRIPT) -mthumb
FLAGS_LD += -Wl,--cref -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map # Output a cross reference table.
FLAGS_LD += @$(VARIANT_PATH)/ldflags.txt

# nano33ble.compiler.mbed.extra_ldflags=-lstdc++ -lsupc++ -lm -lc -lgcc -lnosys
# nano33ble.compiler.mbed="{build.variant.path}/libs/libmbed.a" "{build.variant.path}/libs/libcc_310_core.a" "{build.variant.path}/libs/libcc_310_ext.a" "{build.variant.path}/libs/libcc_310_trng.a"

mbed1100a = $(call PARSE_BOARD,$(BOARD_TAG),compiler.mbed)
LD_WHOLE_ARCHIVE = $(shell echo $(mbed1100a) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')

LD_GROUP = $(call PARSE_BOARD,$(BOARD_TAG),compiler.mbed.extra_ldflags)

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

COMMAND_LINK = $(CXX) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_CORE_A) $(TARGET_A) -Wl,--whole-archive $(LD_WHOLE_ARCHIVE) -Wl,--no-whole-archive -Wl,--start-group $(LD_GROUP) -Wl,--end-group

# Target
#
TARGET_HEXBIN = $(TARGET_BIN)
TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex

endif # BOARD_TAG

endif # MAKEFILE_NAME

