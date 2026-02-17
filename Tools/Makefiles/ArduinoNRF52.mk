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

ARDUINO_NRF52_INITIAL = $(ARDUINO_PACKAGES_PATH)/arduino

ifneq ($(wildcard $(ARDUINO_NRF52_INITIAL)/hardware/nrf52),)
    ARDUINO_NRF52_APP = $(ARDUINO_NRF52_INITIAL)
    ARDUINO_NRF52_PATH = $(ARDUINO_NRF52_APP)
    ARDUINO_NRF52_BOARDS = $(ARDUINO_NRF52_APP)/hardware/nrf52/$(ARDUINO_NRF52_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_NRF52_BOARDS)),)
MAKEFILE_NAME = ArduinoNRF52
RELEASE_CORE = $(ARDUINO_NRF52_RELEASE)

# MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME).

# # Release check
# # ----------------------------------
# #
# REQUIRED_ARDUINO_NRF52_RELEASE = 1.1.4
# ifeq ($(shell if [[ '$(ARDUINO_NRF52_RELEASE)' > '$(REQUIRED_ARDUINO_NRF52_RELEASE)' ]] || [[ '$(ARDUINO_NRF52_RELEASE)' = '$(REQUIRED_ARDUINO_NRF52_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
# $(error Arduino nRF52 release $(REQUIRED_ARDUINO_NRF52_RELEASE) or later required, release $(ARDUINO_NRF52_RELEASE) installed)
# endif

# Arduino nRF52 specifics
# ----------------------------------
#
PLATFORM := Arduino
BUILD_CORE := nrf52
SUB_PLATFORM := nrf52

PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_PRIMO ARDUINO_ARCH_NRF52 EMCODE=$(RELEASE_NOW) ARDUINO_$(BUILD_BOARD) $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS))
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := nRF52 $(ARDUINO_NRF52_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ARDUINO_NRF52_PATH)/hardware/nrf52/$(ARDUINO_NRF52_RELEASE)
TOOL_CHAIN_PATH = $(ARDUINO_NRF52_PATH)/tools/arm-none-eabi-gcc/$(ARDUINO_GCC_ARM_RELEASE)
OTHER_TOOLS_PATH = $(ARDUINO_NRF52_PATH)/tools

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
VARIANT_C_SRCS = $(shell find $(VARIANT_PATH) -name \*.c)
VARIANT_AS1_SRCS = $(shell find $(VARIANT_PATH) -name \*.S)
VARIANT_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %.S, $(VARIANT_AS1_SRCS)))
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o) $(VARIANT_C_SRCS:.c=.c.o) $(VARIANT_AS1_SRCS_OBJ)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

# Generate main.cpp
# ----------------------------------
#
MAIN_LOCK = false

# Uploader openocd or avrdude or ssh
# UPLOADER defined in .mk
#
ifeq ($(UPLOADER),jlink)
    UPLOADER = jlink
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    SHARED_OPTS = -device nRF52832_xxAA -if swd -speed 4000
    UPLOADER_OPTS = $(SHARED_OPTS)  -commanderscript $(BUILDS_PATH)/upload.jlink
    COMMAND_PRE_UPLOAD = printf 'r\nloadfile \"$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)-merged.hex\"\ng\nexit\n' > $(BUILDS_PATH)/upload.jlink

    # unused DEBUG_SERVER_PATH = $(SEGGER_PATH)/JLink
    # unused DEBUG_SERVER_EXEC = $(DEBUG_SERVER_PATH)/JLinkGDBServer
# J-Link port 3333 for compatibility with OpenOCD
    # unused DEBUG_SERVER_OPTS = $(SHARED_OPTS)

else ifeq ($(UPLOADER),ozone)
    UPLOADER = ozone

# Ozone no longer seems to upload the executable
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    SHARED_OPTS = -device nRF52832_xxAA -if swd -speed 4000
    UPLOADER_OPTS = $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/upload.jlink'

    COMMAND_PRE_UPLOAD = printf 'r\nloadfile \"$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)-merged.hex\"\ng\nexit\n' > $(BUILDS_PATH)/upload.jlink

    # unused DEBUGGER_PATH = $(SEGGER_PATH)/Ozone
    # unused DEBUGGER_EXEC = open $(UPLOADER_PATH)/Ozone.app
    # unused DEBUGGER_OPTS = --args $(BUILDS_PATH)/ozone.jdebug

else # UPLOADER

# ifeq ($(UPLOADER),)
    UPLOADER = $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)

# Specific reelase of OpenOCD = 0.10.0-arduino1-static
    UPLOADER = openocd
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/openocd/$(ARDUINO_NRF52_OPENOCD_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    UPLOADER_OPTS = -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.openocdscript)
    UPLOADER_COMMAND = program {$(OBJDIR)/$(BINARY_SPECIFIC_NAME)-merged.hex} verify reset exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "$(UPLOADER_COMMAND)"

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

# Core files
# Crazy maze of sub-folders
#
CORE_C_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.c)
WORK_2 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(WORK_2))
CORE_AS1_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.S)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %.S, $(CORE_AS1_SRCS)))
CORE_AS2_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.s)
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %.s, $(CORE_AS_SRCS)))

CORE_OBJ_FILES = $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
CORE_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

ifeq ($(strip $(APP_LIBS_LIST)),0)
    APP_LIBS_LIST = BLE
else
    APP_LIBS_LIST += BLE
endif

# Two locations for Arduino libraries
#
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

# MCU options
#
MCU_FLAG_NAME = mcpu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)

# # USB PID VID not used for Star Otto
# #
# USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
# USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
# USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
# USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)
# U
# USB_FLAGS = -DUSB_VID=$(USB_VID)
# USB_FLAGS += -DUSB_PI
# USB_FLAGS += -DUSBCON
# USB_FLAGS += -DUSB_MANUFACTURER='$(USB_VENDOR)'
# USB_FLAGS += -DUSB_PRODUCT='$(USB_PRODUCT)'

# Arduino Due serial 1200 reset
#
# USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)
# USB_RESET = python $(UTILITIES_PATH)/reset_1200.py

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION ?= -O0 -ggdb
else
    OPTIMISATION ?= -Os -g
endif

#   --- Reading platform.txt directly
CMSIS_PATH = $(ARDUINO_NRF52_PATH)/tools/CMSIS/$(ARDUINO_CMSIS_RELEASE)
//INCLUDE_PATH += $(ARDUINO_NRF52_PATH)/tools/CMSIS/$(ARDUINO_CMSIS_RELEASE)/CMSIS/Include
nrf1001 = $(call PARSE_FILE,compiler,nrf_api_include,$(HARDWARE_PATH)/platform.txt)

#  Use of : instead of / for sed
nrf1002 = $(shell echo $(nrf1001) | sed 's:-I{runtime.tools.CMSIS.path}:$(CMSIS_PATH):g')
INCLUDE_PATH = $(shell echo $(nrf1002) | sed 's:-I{runtime.platform.path}:$(HARDWARE_PATH):g')

INCLUDE_PATH += $(CORE_LIB_PATH) $(VARIANT_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(HARDWARE_PATH)/libraries/BLE/utility/uECC

#   --- Reading platform.txt directly instead of
#   --- Incredible list of includes from platfrom.txt

# Flags for gcc, g++ and linker
# ----------------------------------
#
# -D flags
# a1720 = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
# a1730 = $(call PARSE_BOARD,$(BOARD_TAG),build.esp_ch_uart_br)
# FLAGS_D = $(shell echo $(a1720) | sed 's/-I{build.esp_ch_uart_br}/$(a1730)/g')
FLAGS_D += $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
FLAGS_D += -DNRF5 -DNRF52 -DS132 -DSOFTDEVICE_PRESENT
FLAGS_D += -DBLE_STACK_SUPPORT_REQD -DCONFIG_GPIO_AS_PINRESET

# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
FLAGS_ALL += -ffunction-sections -fdata-sections
# FLAGS_ALL += -nostdlib -fno-threadsafe-statics
# FLAGS_ALL += --param max-inline-insns-single=500 -mthumb
# CPFLAGS += -mfpu=$(call PARSE_BOARD,$(BOARD_TAG),build.fpu) -mfloat-abi=$(call PARSE_BOARD,$(BOARD_TAG),build.float-abi) -mthumb
# FLAGS_ALL += -lm -lc
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) $(FLAGS_D)
FLAGS_ALL += -mthumb -fno-builtin
# $(USB_FLAGS)
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
FLAGS_C = -w -std=gnu99

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = -fno-rtti -fno-exceptions -w -std=gnu++11

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU)
FLAGS_LD += -mfpu=$(call PARSE_BOARD,$(BOARD_TAG),build.fpu) -mfloat-abi=$(call PARSE_BOARD,$(BOARD_TAG),build.float-abi)
FLAGS_LD += --specs=nano.specs
FLAGS_LD += -T $(VARIANT_PATH)/$(LDSCRIPT) -mthumb
# FLAGS_LD += -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb-interwork
# FLAGS_LD += -lm -lgcc
FLAGS_LD += -Wl,--cref
FLAGS_LD += -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map # Output a cross reference table.
FLAGS_LD += -Wl,--gc-sections -Wl,--warn-common

ARCHIVE_A = $(HARDWARE_PATH)/cores/arduino/components/nfc/t2t_lib/nfc_t2t_lib_gcc.a
# For 1.0.1 only
ifeq ($(ARDUINO_NRF52_RELEASE),1.0.1)
    ARCHIVE_A += $(HARDWARE_PATH)/libraries/BLE/utility/uECC/micro_ecc_lib_nrf52.a
endif

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
# FLAGS_OBJCOPY = -v -O binary
FLAGS_OBJCOPY = -v -O ihex

# Commands
# ----------------------------------
# Link command
#
# FIRST_O_IN_LD = $(shell find $(BUILDS_PATH) -name syscalls.c.o)
# FIRST_O_IN_LD += $(shell find $(BUILDS_PATH) -name *.S.o) # not required

# COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) -Wl,--start-group $(FIRST_O_IN_LD) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--whole-archive $(ARCHIVE_A) -Wl,--no-whole-archive $(TARGET_A) -Wl,--end-group
COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) -Wl,--start-group $(FIRST_O_IN_LD) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(ARCHIVE_A) $(TARGET_A) -Wl,--end-group

# Copy command
COMMAND_COPY = $(OBJCOPY) -O ihex $< $@

# Post-copy command
# For 1.0.1 only
ifeq ($(ARDUINO_NRF52_RELEASE),1.0.1)
    COMMAND_POST_COPY = $(OTHER_TOOLS_PATH)/nrf5x-cl-tools/$(ARDUINO_NRF5X_TOOLS_RELEASE)/mergehex/mergehex --merge $(HARDWARE_PATH)/firmwares/primo/softdevice/s132_nrf52_2.0.0_softdevice.hex $(TARGET_HEX) --output $(OBJDIR)/$(BINARY_SPECIFIC_NAME)-merged.hex --quiet
else
# For 1.0.2
    COMMAND_POST_COPY = $(OTHER_TOOLS_PATH)/nrf5x-cl-tools/$(ARDUINO_NRF5X_TOOLS_RELEASE)/mergehex/mergehex --merge $(HARDWARE_PATH)/firmwares/primo/softdevice/s132_nrf52_2.0.0_softdevice.hex $(HARDWARE_PATH)/bootloaders/$(call PARSE_BOARD,$(BOARD_TAG),bootloader.file) $(TARGET_HEX) --output $(OBJDIR)/$(BINARY_SPECIFIC_NAME)-merged.hex --quiet
endif

# Upload command
#
# $(FLAGS_ALL)

# Target
#
TARGET_HEXBIN = $(TARGET_HEX)
# TARGET_HEXBIN = $(TARGET_BIN)
# TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex

endif

endif # MAKEFILE_NAME

