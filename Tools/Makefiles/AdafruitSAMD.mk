#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2026
# All rights reserved
#
# Last update: 17 May 2024 release 14.4.1
#

ifeq ($(MAKEFILE_NAME),)

ADAFRUIT_SAMD_INITIAL = $(ARDUINO_PACKAGES_PATH)/adafruit

ifneq ($(wildcard $(ADAFRUIT_SAMD_INITIAL)/hardware/samd),)
    ADAFRUIT_SAMD_APP = $(ADAFRUIT_SAMD_INITIAL)
    ADAFRUIT_SAMD_PATH = $(ADAFRUIT_SAMD_APP)
    ADAFRUIT_SAMD_BOARDS = $(ADAFRUIT_SAMD_APP)/hardware/samd/$(ADAFRUIT_SAMD_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ADAFRUIT_SAMD_BOARDS)),)
MAKEFILE_NAME = AdafruitSAMD
RELEASE_CORE = $(ADAFRUIT_SAMD_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# Adafruit SAMD specifics
# ----------------------------------
#
PLATFORM := Adafruit SAMD
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := SAMD $(ADAFRUIT_SAMD_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ADAFRUIT_SAMD_PATH)/hardware/samd/$(ADAFRUIT_SAMD_RELEASE)
TOOL_CHAIN_PATH = $(ADAFRUIT_SAMD_PATH)/tools/arm-none-eabi-gcc/$(ADAFRUIT_GCC_ARM_RELEASE)
OTHER_TOOLS_PATH = $(ARDUINO_PACKAGES_PATH)/arduino/tools

BUILD_CORE = samd
SUB_PLATFORM = samd
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) EMCODE=$(RELEASE_NOW) ARDUINO_SAMD_ADAFRUIT ARDUINO_$(call PARSE_BOARD,$(BOARD_TAG),build.board)

# # Release check
# # ----------------------------------
# #
# REQUIRED_ADAFRUIT_SAMD_RELEASE = 1.6.4
#     ifeq ($(shell if [[ "$(ADAFRUIT_SAMD_RELEASE)" > "$(REQUIRED_ADAFRUIT_SAMD_RELEASE)" ]] || [[ "$(ADAFRUIT_SAMD_RELEASE)" = "$(REQUIRED_ADAFRUIT_SAMD_RELEASE)" ]]; then echo 1 ; else echo 0 ; fi ),0)
#     $(error Adafruit Feather M0 release $(REQUIRED_ADAFRUIT_SAMD_RELEASE) or later required, release $(ADAFRUIT_SAMD_RELEASE) installed)
# endif

UPLOAD_OFFSET = $(call PARSE_BOARD,$(BOARD_TAG),upload.offset)
ifeq ($(UPLOAD_OFFSET),)
    UPLOAD_OFFSET := 0x2000
endif

# Complicated menu system for Arduino 1.5
# Another example of Arduino's quick and dirty job
#
BOARD_OPTION_TAGS_LIST = $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4)
BOARD_TAGS_LIST = $(BOARD_TAG) $(BOARD_OPTION_TAGS_LIST)
# BOARD_TAGS_LIST = $(BOARD_TAG) $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4)

# SEARCH_FOR = $(strip $(foreach t,$(1),$(call PARSE_BOARD,$(t),$(2))))

# Uploader
# ----------------------------------
#
# Uploader bossac, openocd or jlink
# UPLOADER defined in .mk
#
ifeq ($(UPLOADER),bossac)
    USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
    UPLOADER = bossac
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/bossac/$(ADAFRUIT_BOSSAC_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bossac
    UPLOADER_PORT = $(subst /dev/,,$(AVRDUDE_PORT))
#    UPLOADER_OPTS = -i -d --port=$(UPLOADER_PORT) -U $(call PARSE_BOARD,$(BOARD_TAG),upload.native_usb) -i -e -w -v
    UPLOADER_OPTS = -i -d --port=$(UPLOADER_PORT) -U -i --offset=$(UPLOAD_OFFSET) -w -v

else ifeq ($(UPLOADER),cp_uf2)
    MESSAGE_WARNING = BETA! UF2 not yet tested against $(CONFIG_NAME).
    USB_RESET = #
    UPLOADER = cp_uf2
    TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
    COMMAND_PRE_UPLOAD = python  $(ADAFRUIT_NRF52_APP)/hardware/nrf52/$(ADAFRUIT_NRF52_RELEASE)/tools/uf2conv/uf2conv.py -c -b $(UPLOAD_OFFSET) -o $(TARGET_BIN_CP) $(TARGET_BIN)

else ifeq ($(UPLOADER),jlink)
    WORK_6a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
# Add prefix AT and get SAMD21G18 from __SAMD21G18A__
# Add prefix AT and get SAMD51J19 from __SAMD51J19A__
    JLINK_DEVICE = AT$(shell echo $(WORK_6a) | sed 's/-D__\(SAMD.*\)A__.*/\1/')

    UPLOADER = jlink
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    SHARED_OPTS = -device $(JLINK_DEVICE) -if swd -speed 4000
    UPLOADER_OPTS = $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/upload.jlink'

# Prepare the .jlink scripts
    COMMAND_PRE_UPLOAD = printf "r\nloadfile '$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex'\ng\nexit\n" > $(BUILDS_PATH)/upload.jlink ;
    COMMAND_PRE_UPLOAD += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

#    JLINK_POWER = 1
    JLINK_POWER ?= 0
    ifeq ($(JLINK_POWER),1)
        COMMAND_POWER = $(UPLOADER_EXEC) $(SHARED_OPTS)  -commanderscript '$(BUILDS_PATH)/power.jlink'
    endif

    # unused DEBUG_SERVER_PATH = $(SEGGER_PATH)/JLink
    # unused DEBUG_SERVER_NAME = JLinkGDBServer
    # unused DEBUG_SERVER_EXEC = $(DEBUG_SERVER_PATH)/$(DEBUG_SERVER_NAME)
    # unused DEBUG_SERVER_OPTS = $(SHARED_OPTS)

else ifeq ($(UPLOADER),ozone)
    WORK_6a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
    JLINK_DEVICE = AT$(shell echo $(WORK_6a) | sed 's/-D__\(SAMD.*\)A__.*/\1/')

    UPLOADER = ozone

# Ozone no longer seems to upload the executable
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    SHARED_OPTS = -device $(JLINK_DEVICE) -if swd -speed 4000
    UPLOADER_OPTS = $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/upload.jlink'

# Prepare the .jlink scripts
    COMMAND_PRE_UPLOAD = printf 'r\nloadfile \"$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex\"\ngo\nexit\n' > $(BUILDS_PATH)/upload.jlink ;
    COMMAND_PRE_UPLOAD += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

#    JLINK_POWER = 1
    ifeq ($(JLINK_POWER),1)
        COMMAND_POWER = $(UPLOADER_EXEC) $(SHARED_OPTS) -commanderscript Utilities/power.jlink
    endif

    # unused DEBUGGER_PATH = $(SEGGER_PATH)/Ozone
    # unused DEBUGGER_EXEC = open $(DEBUGGER_PATH)/Ozone.app
    # unused DEBUGGER_OPTS = --args $(BUILDS_PATH)/ozone.jdebug

else # UPLOADER

    UPLOADER = openocd
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/openocd/$(ARDUINO_SAMD_OPENOCD_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    UPLOADER_OPTS = -d2 -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.openocdscript)
    UPLOADER_COMMAND = program {$(TARGET_BIN)} verify reset $(UPLOAD_OFFSET)); shutdown
# telnet_port disabled;
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "$(UPLOADER_COMMAND)"

endif # UPLOADER

APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(HARDWARE_PATH)/cores/arduino
APP_LIB_PATH := $(HARDWARE_PATH)/libraries

# Generate main.cpp
# ----------------------------------
#
MAIN_LOCK = false

# Core files
# Crazy maze of sub-folders
#
CORE_C_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.c)
WORK_3 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(WORK_3))
CORE_AS1_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.S)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %.S, $(CORE_AS1_SRCS)))
CORE_AS2_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.s)
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %.s, $(CORE_AS_SRCS)))

CORE_OBJ_FILES = $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
CORE_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

# Three specific libraries
ifeq ($(APP_LIBS_LIST),0)
    APP_LIBS_LIST :=
endif

# Now, adding extra libraries manually
APP_LIBS_LIST += Adafruit_TinyUSB_Arduino

# Two locations for libraries
# First from package
#
APP_LIB_PATH := $(HARDWARE_PATH)/libraries

WORK_0 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))
WORK_0 += $(HARDWARE_PATH)/libraries/RedBear_Duo/src
WORK_0 += $(HARDWARE_PATH)/libraries/RedBear_Duo/src/utility

APP_LIB_CPP_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.c))
# unused APP_LIB_S_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.S))
APP_LIB_H_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.hpp))

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIBS_LIST = $(subst $(BUILD_APP_LIB_PATH)/, ,$(APP_LIB_CPP_SRC))

# Second from Arduino.CC
#
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

VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)
# unused LDSCRIPT_PATH = $(VARIANT_PATH)
LDSCRIPT = $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)
VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp)
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

# $(info VARIANT '$(VARIANT)')
# $(info VARIANT_PATH '$(VARIANT_PATH)')
# $(info VARIANT_OBJS '$(VARIANT_OBJS)')
# $(error 'ERROR')

# Tool-chain names
# ----------------------------------
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


MCU_FLAG_NAME = mcpu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
# F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)

F_CPU = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.f_cpu)
ifeq ($(F_CPU),)
    F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)
endif
OPTIMISATION ?= -Os -g3

# Adafruit Feather M0 USB PID VID
#
USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

ifneq ($(USB_VID),)
    USB_FLAGS = -DUSB_VID=$(USB_VID)
    USB_FLAGS += -DUSB_PID=$(USB_PID)
    USB_FLAGS += -DUSBCON -DUSB_CONFIG_POWER=100
    USB_FLAGS += -DUSB_MANUFACTURER='$(USB_VENDOR)'
    USB_FLAGS += -DUSB_PRODUCT='$(USB_PRODUCT)'
endif

USB_FLAGS += -I$(CORE_LIB_PATH)/TinyUSB -I$(CORE_LIB_PATH)/TinyUSB/Adafruit_TinyUSB_ArduinoCore
USB_FLAGS += -I$(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino/src/arduino

INCLUDE_PATH = $(CORE_LIB_PATH) $(APP_LIB_PATH) $(VARIANT_PATH) $(HARDWARE_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))
INCLUDE_PATH += $(OBJDIR)
INCLUDE_PATH += $(ADAFRUIT_SAMD_PATH)/tools/CMSIS/$(ADAFRUIT_SAMD_CMSIS_RELEASE)/CMSIS/Core/Include/
INCLUDE_PATH += $(ADAFRUIT_SAMD_PATH)/tools/CMSIS/$(ADAFRUIT_SAMD_CMSIS_RELEASE)/CMSIS/DSP/Include/
# Don't ask why this is an exception
# INCLUDE_PATH += $(ARDUINO_PACKAGES_PATH)/arduino/tools/CMSIS-Atmel/$(ADAFRUIT_CMSIS_ATMEL_RELEASE)/CMSIS/Device/ATMEL/
# Don't ask why this is no longer an exception
INCLUDE_PATH += $(ADAFRUIT_SAMD_PATH)/tools/CMSIS-Atmel/$(ADAFRUIT_CMSIS_ATMEL_RELEASE)/CMSIS/Device/ATMEL/

# adafruit_metro_m4.build.extra_flags=-D__SAMD51J19A__ -DADAFRUIT_METRO_M4_EXPRESS -D__SAMD51__ {build.usb_flags} -D__FPU_PRESENT -DARM_MATH_CM4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 {build.flags.optimize} {build.flags.maxspi} {build.flags.maxqspi}
WORK_2a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
WORK_2b = $(shell echo $(WORK_2a) | sed 's:{build.usb_flags}::g')
WORK_2c = $(shell echo $(WORK_2b) | sed 's:{build.flags.optimize}::g')
WORK_2d = $(shell echo $(WORK_2c) | sed 's:{build.flags.maxspi}::g')
FLAGS_MORE = $(shell echo $(WORK_2d) | sed 's:{build.flags.maxqspi}::g')

# build.flags.optimize is managed by OPTIMISATION
FLAGS_MORE += $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.flags.optimize)
FLAGS_MORE += $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.flags.maxspi)
FLAGS_MORE += $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.flags.maxqspi)

FLAGS_D = $(PLATFORM_TAG) ARDUINO_ARCH_SAMD

FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name pulse_asm.S.o)
FLAGS_WARNING += -Werror=return-type -Wno-expansion-to-defined

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
FLAGS_ALL += -mthumb -ffunction-sections -fdata-sections -nostdlib
FLAGS_ALL += --param max-inline-insns-single=500 -MMD
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG) $(FLAGS_D)) $(FLAGS_MORE)
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))
FLAGS_ALL += $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.cache_flags)

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
FLAGS_C = -std=gnu11

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = -std=gnu++11 -fno-threadsafe-statics -fno-rtti -fno-exceptions

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING) -Wl,--gc-sections -save-temps
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU) --specs=nano.specs --specs=nosys.specs
FLAGS_LD += -T $(LDSCRIPT) -mthumb
FLAGS_LD += -Wl,--cref -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map # Output a cross reference table.
FLAGS_LD += -Wl,--check-sections -Wl,--gc-sections
FLAGS_LD += -Wl,--unresolved-symbols=report-all
FLAGS_LD += -Wl,--warn-common -Wl,--warn-section-align

# adafruit_feather_m4.compiler.arm.cmsis.ldflags="-L{runtime.tools.CMSIS-5.4.0.path}/CMSIS/Lib/GCC/" "-L{build.variant.path}" -larm_cortexM4lf_math -mfloat-abi=hard -mfpu=fpv4-sp-d16
WORK_3a = $(call PARSE_BOARD,$(BOARD_TAG),compiler.arm.cmsis.ldflags)
ifneq ($(WORK_3a),)
    WORK_3b = $(shell echo $(WORK_3a) | sed 's:{build.variant.path}:$(HARDWARE_PATH)/variants/$(VARIANT):g')
#     WORK_3c = $(shell echo $(WORK_3b) | sed 's:{runtime.tools.CMSIS-$(ADAFRUIT_SAMD_CMSIS_RELEASE).path}:$(ADAFRUIT_SAMD_PATH)/tools/CMSIS/$(ADAFRUIT_SAMD_CMSIS_RELEASE):g')
    WORK_3c = $(shell echo $(WORK_3b) | sed 's:{runtime.tools.CMSIS-5.4.0.path}:$(ADAFRUIT_SAMD_PATH)/tools/CMSIS/$(ADAFRUIT_SAMD_CMSIS_RELEASE):g')
    FLAGS_LIB = $(WORK_3c)
# $(info WORK_3a $(WORK_3a))
# $(info WORK_3b $(WORK_3b))

# -L/Users/$(USER)/Library/Arduino15/packages/arduino/tools/CMSIS/4.5.0/CMSIS/Lib/GCC/
else
    FLAGS_LIB = -L$(ADAFRUIT_SAMD_PATH)/tools/CMSIS/$(ADAFRUIT_SAMD_CMSIS_RELEASE)/CMSIS/Lib/GCC/ -larm_cortexM0l_math
    FLAGS_LIB += -L$(HARDWARE_PATH)/variants/$(VARIANT)
endif
# -lsamd21_qtouch_gcc

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -v -Obinary

# Target
#
# J-Link requires HEX and no USB reset at 1200
ifeq ($(UPLOADER),jlink)
    TARGET_HEXBIN = $(TARGET_HEX)

else # UPLOADER

    TARGET_HEXBIN = $(TARGET_BIN)

# Serial 1200 reset
#
#    ifneq ($(UPLOADER),cp_uf2)
        USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.use_1200bps_touch)
        ifeq ($(USB_TOUCH),true)
#             USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
            USB_RESET = stty -F $(AVRDUDE_PORT) 1200
        endif # USB_TOUCH
#    endif

endif # UPLOADER

# Commands
# ----------------------------------
# Link command
#
## COMMAND_LINK = $(CXX) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--start-group $(FLAGS_LIB) -lm $(TARGET_A) -Wl,--end-group
COMMAND_LINK = $(CXX) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--start-group $(FLAGS_LIB) -lm $(TARGET_A) $(TARGET_CORE_A) -Wl,--end-group

# Upload command
#
# COMMAND_UPLOAD = $(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -P$(USED_SERIAL_PORT) -Uflash:w:$(TARGET_HEX):i

endif # BOARD_TAG

endif # MAKEFILE_NAME

