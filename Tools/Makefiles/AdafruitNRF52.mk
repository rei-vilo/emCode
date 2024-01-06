#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2024
# All rights reserved
#
# Last update: 14 Dec 2023 release 14.2.12
#

ifeq ($(MAKEFILE_NAME),)

ADAFRUIT_NRF52_INITIAL = $(ARDUINO_PACKAGES_PATH)/adafruit

ifneq ($(wildcard $(ADAFRUIT_NRF52_INITIAL)/hardware/nrf52),)
    ADAFRUIT_NRF52_APP = $(ADAFRUIT_NRF52_INITIAL)
    ADAFRUIT_NRF52_PATH = $(ADAFRUIT_NRF52_APP)
    ADAFRUIT_NRF52_BOARDS = $(ADAFRUIT_NRF52_APP)/hardware/nrf52/$(ADAFRUIT_NRF52_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ADAFRUIT_NRF52_BOARDS)),)
MAKEFILE_NAME = AdafruitNRF52
RELEASE_CORE = $(ADAFRUIT_NRF52_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# Adafruit nRF52 specifics
# ----------------------------------
#
PLATFORM := Adafruit nRF52
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) EMCODE=$(RELEASE_NOW) ARDUINO_ARCH_NRF52
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := nRF52 $(ADAFRUIT_NRF52_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(ADAFRUIT_NRF52_PATH)/hardware/nrf52/$(ADAFRUIT_NRF52_RELEASE)
OTHER_TOOLS_PATH = $(ARDUINO_PACKAGES_PATH)/arduino/tools
TOOL_CHAIN_PATH = $(ADAFRUIT_NRF52_PATH)/tools/arm-none-eabi-gcc/$(ADAFRUIT_GCC_ARM_RELEASE)

BUILD_CORE = nrf52
SUB_PLATFORM = nrf52
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt

# # Release check
# # ----------------------------------
# #
# REQUIRED_ADAFRUIT_NRF52_RELEASE = 0.21.0
# ifeq ($(shell if [[ '$(ADAFRUIT_NRF52_RELEASE)' > '$(REQUIRED_ADAFRUIT_NRF52_RELEASE)' ]] || [[ '$(ADAFRUIT_NRF52_RELEASE)' = '$(REQUIRED_ADAFRUIT_NRF52_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
#     $(error Adafruit Feather nRF52 release $(REQUIRED_ADAFRUIT_NRF52_RELEASE) or later required, release $(ADAFRUIT_NRF52_RELEASE) installed)
# endif

# Complicated menu system for Arduino 1.5
# Another example of Arduino's quick and dirty job
#
BOARD_TAGS_LIST = $(BOARD_TAG) $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4)

# SEARCH_FOR = $(strip $(foreach t,$(1),$(call PARSE_BOARD,$(t),$(2))))

# $(info >>> UPLOADER $(UPLOADER))

# Uploader
# ----------------------------------
#
# Uploader bossac, openocd or jlink
# UPLOADER defined in .mk
#
ifeq ($(UPLOADER),bossac)

    USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
    UPLOADER = bossac
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)/bossac/$(ARDUINO_BOSSAC_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bossac
    UPLOADER_PORT = $(subst /dev/,,$(AVRDUDE_PORT))
    UPLOADER_OPTS = -i -d --port=$(UPLOADER_PORT) -U $(call PARSE_BOARD,$(BOARD_TAG),upload.native_usb) -i -e -w -v

else ifeq ($(UPLOADER),cp_uf2)

    ifneq ($(BOARD_TAG),feather52840)
        $(error UF2 not supported by $(CONFIG_NAME).)
    endif
    MESSAGE_WARNING = BETA! UF2 not yet tested against $(CONFIG_NAME).
# See https://github.com/adafruit/Adafruit_nRF52_Bootloader#making-your-own-uf2
# UPLOAD_OFFSET not required when using .hex
# UPLOAD_OFFSET = 0x26000
    FAMILY_UF2 = 0xADA52840
    USB_RESET = #
    TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
    COMMAND_PREPARE = python $(ADAFRUIT_NRF52_APP)/hardware/nrf52/$(ADAFRUIT_NRF52_RELEASE)/tools/uf2conv/uf2conv.py -c -o $(TARGET_BIN_CP) -f $(FAMILY_UF2) $(TARGET_HEX)
#     USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.use_1200bps_touch)
#     ifeq ($(USB_TOUCH),true)
#         USB_RESET = -stty -F $(AVRDUDE_PORT) 1200
#         # USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
#     endif

else ifeq ($(UPLOADER),jlink)

# openocd -f $(HARDWARE_PATH)/scripts/openocd/jlink_nrf52.cfg' -c "program {$(TARGET_HEX)} verify reset ; exit"

    ada1600a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
#    ada1600b = $(shell echo $(ada1600a) | sed 's:{build.flags.usb}::g')
#    ada1600c = $(firstword $(ada1600b))
#    JLINK_DEVICE = $(shell echo $(ada1600c) | sed 's:-D::g')
# Retain NRF52***_XXAA out of build.extra_flags
# feather52832.build.extra_flags=-DNRF52832_XXAA -DNRF52
# feather52840.build.extra_flags=-DNRF52840_XXAA {build.flags.usb}

    JLINK_DEVICE = $(shell echo $(ada1600a) | sed 's/.*\(NRF52.*_XXAA\).*/\1/')
    UPLOADER = jlink
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
# Recommended speed for stability 2000
    SHARED_OPTS = -device $(JLINK_DEVICE) -if swd -speed 2000
    UPLOADER_OPTS = $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/upload.jlink'

    COMMAND_PREPARE = printf "r\nloadfile $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex\ngo\nexit\n" > '$(BUILDS_PATH)/upload.jlink' ;
    COMMAND_PREPARE += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

#    JLINK_POWER = 1
    JLINK_POWER ?= 0
    ifeq ($(JLINK_POWER),1)
        COMMAND_POWER = $(UPLOADER_EXEC) $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/power.jlink'
    endif

    DEBUG_SERVER_PATH = $(SEGGER_PATH)/JLink
    DEBUG_SERVER_EXEC = $(DEBUG_SERVER_PATH)/JLinkGDBServer

# Adafruit nRF52 requires RTOSPlugin_FreeRTOS
# /usr/bin/JLinkGDBServer -rtos /opt/SEGGER/JLink/GDBServer/RTOSPlugin_FreeRTOS.so -device NRF52840_XXAA -if swd -speed 2000

    DEBUG_SERVER_OPTS = $(SHARED_OPTS) -rtos $(SEGGER_PATH)/GDBServer/RTOSPlugin_FreeRTOS.so

else ifeq ($(UPLOADER),ozone)
    ada1600a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
    JLINK_DEVICE = $(shell echo $(ada1600a) | sed 's/.*\(NRF52.*_XXAA\).*/\1/')

    UPLOADER = ozone

# Ozone no longer seems to upload the executable
    UPLOADER_PATH = $(SEGGER_PATH)/JLink
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    SHARED_OPTS = -device $(JLINK_DEVICE) -if swd -speed 4000
    UPLOADER_OPTS = $(SHARED_OPTS) -commanderscript '$(BUILDS_PATH)/upload.jlink'

# Prepare the .jlink scripts
    COMMAND_PREPARE = printf "r\nloadfile $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex\ngo\nexit\n" > $(BUILDS_PATH)/upload.jlink ;
    COMMAND_PREPARE += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

#    JLINK_POWER = 1
    ifeq ($(JLINK_POWER),1)
        COMMAND_POWER = $(UPLOADER_EXEC) $(SHARED_OPTS) -commanderscript Utilities/power.jlink
    endif

    DEBUGGER_PATH = $(SEGGER_PATH)/Ozone
    DEBUGGER_EXEC = open $(DEBUGGER_PATH)/Ozone.app
    DEBUGGER_OPTS = --args $(BUILDS_PATH)/ozone.jdebug

else ifeq ($(UPLOADER),nrfutil)

    # USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
    UPLOADER = nrfutil

# adafruit-nrfutil dfu genpkg --dev-type 0x0052 --sd-req 0x00B6 --application sketch.hex sketch.zip
# adafruit-nrfutil --verbose dfu serial -pkg sketch.zip -p /dev/ttyACM0 -b 115200 --singlebank

#    UPLOADER_PATH = /usr/local
# Dirty implementation for nrfutil
# nrfutil for linux downloaded from https://github.com/NordicSemiconductor/pc-nrfutil/releases
#    UPLOADER_EXEC = export LC_ALL=en_IE.UTF-8 ; export LANG=en_IE.UTF-8 ; $(HARDWARE_PATH)/tools/adafruit-nrfutil/macos/adafruit-nrfutil
#   UPLOADER_EXEC = $(HARDWARE_PATH)/tools/adafruit-nrfutil/linux/nrfutil-linux

    # UPLOADER_EXEC = $(UTILITIES_PATH)/nrfutil-linux
    UPLOADER_EXEC = adafruit-nrfutil

    COMMAND_PREPARE = $(NRFUTIL_EXEC) dfu genpkg --dev-type 0x0052 --application $(TARGET_HEX) $(TARGET_ZIP)

# --singlebank is back with release 0.9.2!
    UPLOADER_OPTS = --verbose dfu serial -pkg $(TARGET_ZIP) -p $(USED_SERIAL_PORT) -b 115200 --singlebank --touch 1200
# telnet_port disabled;
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS)

    NRFUTIL_EXEC = adafruit-nrfutil

    DELAY_BEFORE_UPLOAD = 2

else

    UPLOADER = openocd
    UPLOADER_PATH = /usr
    # UPLOADER_PATH = $(OTHER_TOOLS_PATH)/openocd/0.11.0-arduino2
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    UPLOADER_OPTS = -d2 -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f $(VARIANT_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.openocdscript)
#    UPLOAD_OFFSET not required when using .hex
#    UPLOADER_COMMAND = program {$(TARGET_BIN)}} verify reset 0x00002000; shutdown
    UPLOADER_COMMAND = program {$(TARGET_HEX)} verify reset ; shutdown ; quit
# telnet_port disabled;
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "$(UPLOADER_COMMAND)"
endif

# $(info >>> TARGET_HEX '$(TARGET_HEX)')
# $(info >>> UPLOADER '$(UPLOADER)')
# $(info >>> COMMAND_PREPARE '$(COMMAND_PREPARE)')

# NRFUTIL_EXEC := $(UTILITIES_PATH)/nrfutil-linux
NRFUTIL_EXEC := adafruit-nrfutil
APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(HARDWARE_PATH)/cores/nRF5
APP_LIB_PATH := $(HARDWARE_PATH)/libraries

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

# Core files
# Crazy maze of sub-folders
#
CORE_C_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.c)
ada1300 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(ada1300))
CORE_AS1_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.S)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %.S, $(CORE_AS1_SRCS)))
CORE_AS2_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.s)
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %.s, $(CORE_AS_SRCS)))
CORE_H_SRCS = $(foreach dir,$(ada1000),$(wildcard $(dir)/*.h))
CORE_H_SRCS += $(foreach dir,$(ada1000),$(wildcard $(dir)/*.hpp))

CORE_OBJ_FILES = $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
CORE_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

# Two locations for libraries
# First from package
#
APP_LIB_PATH := $(HARDWARE_PATH)/libraries

APP_LIBS_LOCK = 1

# Three specific libraries
ifeq ($(APP_LIBS_LIST),0)
    APP_LIBS_LIST :=
endif

# Now, adding extra libraries manually
APP_LIBS_LIST += Adafruit_TinyUSB_Arduino 
APP_LIBS_LIST += Adafruit_LittleFS InternalFileSytem
ifeq ($(BOARD_TAG),feather52832)
else
    APP_LIBS_LIST += Adafruit_nRFCrypto 
endif 
APP_LIBS_LIST += Bluefruit52Lib

# Now, adding some extra non-standard sub-folders manually
ada1000 = $(foreach dir,$(APP_LIBS_LIST),$(shell find $(APP_LIB_PATH)/$(dir) -type d  | egrep -v 'examples'))

# Pick and sort
APP_LIB_CPP_SRC = $(foreach dir,$(ada1000),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(ada1000),$(wildcard $(dir)/*.c))
APP_LIB_S_SRC = $(foreach dir,$(ada1000),$(wildcard $(dir)/*.S))
APP_LIB_H_SRC = $(foreach dir,$(ada1000),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(ada1000),$(wildcard $(dir)/*.hpp))

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

BUILD_APP_LIBS_LIST = $(subst $(BUILD_APP_LIB_PATH)/, ,$(APP_LIB_CPP_SRC))

# Second from Arduino.CC
#
BUILD_APP_LIB_PATH = $(APPLICATION_PATH)/libraries

ada1100 = $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
ada1100 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
ada1100 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
ada1100 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
ada1100 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
ada1100 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))

BUILD_APP_LIB_CPP_SRC = $(foreach dir,$(ada1100),$(wildcard $(dir)/*.cpp))
BUILD_APP_LIB_C_SRC = $(foreach dir,$(ada1100),$(wildcard $(dir)/*.c))
BUILD_APP_LIB_H_SRC = $(foreach dir,$(ada1100),$(wildcard $(dir)/*.h))
BUILD_APP_LIB_H_SRC += $(foreach dir,$(ada1100),$(wildcard $(dir)/*.hpp))

BUILD_APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(BUILD_APP_LIB_CPP_SRC))
BUILD_APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(BUILD_APP_LIB_C_SRC))

APP_LIBS_LOCK = 1

VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)

BUILD_SD_NAME = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.sd_name)
BUILD_SD_VERSION = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.sd_version)
BUILD_SD_FLAGS = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.sd_flags)
BUILD_SD_DWID = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.sd_fwid)

LDSCRIPT_PATH = $(VARIANT_PATH)
LDSCRIPT = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.ldscript)

VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp)
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

MAX_RAM_SIZE = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),upload.maximum_data_size)
MAX_FLASH_SIZE = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),upload.maximum_size)

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

MCU_FLAG_NAME = mcpu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION = -Ofast -g3 -DCFG_DEBUG=3 -DCFG_SYSVIEW=1
else
    OPTIMISATION = -Ofast -g -DCFG_DEBUG=0 -DCFG_SYSVIEW=0
endif # MAKECMDGOALS

# Choice of Serial port
OPTIMISATION += $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.logger_flags)

# Adafruit Feather nRF52 USB PID VID
#
USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

ifneq ($(USB_VID),)
    USB_FLAGS = -DUSBCON -DUSE_TINYUSB
    USB_FLAGS += -DUSB_VID=$(USB_VID)
    USB_FLAGS += -DUSB_PID=$(USB_PID)
    USB_FLAGS += -DUSB_MANUFACTURER='$(USB_VENDOR)'
    USB_FLAGS += -DUSB_PRODUCT='$(USB_PRODUCT)'
endif

USB_FLAGS += -I$(CORE_LIB_PATH)/TinyUSB -I$(CORE_LIB_PATH)/TinyUSB/Adafruit_TinyUSB_ArduinoCore -I$(CORE_LIB_PATH)/TinyUSB/Adafruit_TinyUSB_ArduinoCore/tinyusb/src -I$(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino/src -I$(APP_LIB_PATH)/Adafruit_nRFCrypto/src -I$(APP_LIB_PATH)/Adafruit_LittleFS/src -I$(APP_LIB_PATH)/InternalFileSytem/src

# WAS:
# INCLUDE_PATH = $(shell echo $(ada1400g) | sed 's:-I{build.core.path}:$(HARDWARE_PATH)/cores/nRF5:g')
# NOW: take build.flags.nrf from platform.txt and process it
ada1400a = $(call PARSE_FILE,build.flags,nrf,$(HARDWARE_PATH)/platform.txt)
ada1400b = $(filter-out {build.debug_flags}, $(ada1400a))
ada1400c = $(filter-out {build.logger_flags}, $(ada1400b))
ada1400d = $(filter-out {build.sysview_flags}, $(ada1400c))
ada1400e = $(shell echo $(ada1400d) | sed 's:{build.core.path}:$(CORE_LIB_PATH):g')
ada1400f = $(shell echo $(ada1400e) | sed 's:{nordic.path}:$(CORE_LIB_PATH)/nordic:g')
ada1400g = $(shell echo $(ada1400f) | sed 's:{rtos.path}:$(CORE_LIB_PATH)/freertos:g')
ada1400h = $(shell echo $(ada1400g) | sed 's:{build.sd_name}:$(BUILD_SD_NAME):g')
ada1400i = $(shell echo $(ada1400h) | sed 's:{runtime.platform.path}:$(HARDWARE_PATH):g')
ada1400j = $(shell echo $(ada1400i) | sed 's:{compiler.optimization_flag}::g')
ada1400k = $(shell echo $(ada1400j) | sed 's:{compiler.arm.cmsis.c.flags}::g')

INCLUDE_FLAGS = $(shell echo $(ada1400k) | sed 's:{build.sd_version}:$(BUILD_SD_VERSION):g')

BUILD_BOARD = $(call PARSE_BOARD,$(BOARD_TAG),build.board)

# Now the rest
INCLUDE_PATH += $(CORE_LIB_PATH) $(APP_LIB_PATH) $(VARIANT_PATH) $(HARDWARE_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))
INCLUDE_PATH += $(OBJDIR)

INCLUDE_PATH += $(ADAFRUIT_NRF52_PATH)/tools/CMSIS/$(ADAFRUIT_NRF52_CMSIS_RELEASE)/CMSIS/Core/Include/
INCLUDE_PATH += $(ADAFRUIT_NRF52_PATH)/tools/CMSIS/$(ADAFRUIT_NRF52_CMSIS_RELEASE)/CMSIS/DSP/Include/

# Was: And even empty folders from the specific libraries
# INCLUDE_PATH += $(ada1400g)
# Now: No longer, as -I and -D are mixed
# INCLUDE_FLAGS = $(ada1400i)

ada1500a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
FLAGS_D = $(shell echo $(ada1500a) | sed 's:{build.flags.usb}::g')
FLAGS_D += $(call PARSE_BOARD,$(BOARD_TAG),build.lfclk_flags)

ada1700a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
FLAGS_D += $(shell echo $(ada1700&) | sed 's:{build.flags.usb}::g')

# FLAGS_D += -DNRF5 -DNRF52 -DUSE_LFXO
# Was in 0.14.0
# FLAGS_D += -DSOFTDEVICE_PRESENT -DARDUINO_FEATHER52 -DARDUINO_$(BUILD_BOARD) -DNRF52832_XXAA -DLFS_NAME_MAX=64
# Now in 0.14.5, 0.15.1
FLAGS_D += -DARDUINO_$(BUILD_BOARD)
FLAGS_D += -DARDUINO_BSP_VERSION='"$(ADAFRUIT_NRF52_RELEASE)"'
FLAGS_D += -DSOFTDEVICE_PRESENT
FLAGS_D += -DCFG_LOGGER=0

FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name gcc_startup_nrf52.S.o)
FLAGS_WARNING += -Werror=return-type -Wno-expansion-to-defined

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
FLAGS_ALL += -mfloat-abi=hard -mfpu=fpv4-sp-d16 -u _printf_float
FLAGS_ALL += -ffunction-sections -fdata-sections -nostdlib -mthumb
FLAGS_ALL += --param max-inline-insns-single=500 -MMD
FLAGS_ALL += $(call PARSE_BOARD,$(BOARD_TAG),build.float_flags)
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) $(FLAGS_D) $(BUILD_SD_FLAGS)
FLAGS_ALL += $(INCLUDE_FLAGS) $(addprefix -I, $(INCLUDE_PATH))
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
FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU) 
FLAGS_LD += -Wl,--wrap=realloc -Wl,--wrap=calloc --specs=nano.specs --specs=nosys.specs
FLAGS_LD += $(call PARSE_BOARD,$(BOARD_TAG),build.float_flags)
# FLAGS_LD += -L$(HARDWARE_PATH)/variants/feather52
FLAGS_LD += -L$(VARIANT_PATH)
FLAGS_LD += -L$(HARDWARE_PATH)/cores/nRF5/linker
FLAGS_LD += -T $(LDSCRIPT) -mthumb
FLAGS_LD += -Wl,--cref -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map # Output a cross reference table.
FLAGS_LD += -Wl,--check-sections -Wl,--gc-sections
FLAGS_LD += -Wl,--unresolved-symbols=report-all
FLAGS_LD += -Wl,--warn-common -Wl,--warn-section-align -Wl,--wrap=malloc -Wl,--wrap=free
# FLAGS_LD += --specs=nano.specs --specs=nosys.specs
FLAGS_LD += -mfloat-abi=hard -mfpu=fpv4-sp-d16 -u _printf_float

FLAGS_LIB = -lm 
FLAGS_LIB += -L$(ADAFRUIT_NRF52_PATH)/tools/CMSIS/$(ADAFRUIT_NRF52_CMSIS_RELEASE)/CMSIS/DSP/Lib/GCC/ -larm_cortexM4lf_math
FLAGS_LIB += -L$(APP_LIB_PATH)/Adafruit_nRFCrypto/src/cortex-m4/fpv4-sp-d16-hard -lnrf_cc310_0.9.13-no-interrupts

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -v -Obinary

# Target
#
# J-Link requires HEX and no USB reset at 1200
# ifeq ($(UPLOADER),jlink)
    TARGET_HEXBIN = $(TARGET_HEX)
# else
#    TARGET_HEXBIN = $(TARGET_BIN)

# Serial 1200 reset
#
#    USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.use_1200bps_touch)
#    ifeq ($(USB_TOUCH),true)
#        USB_RESET = python $(UTILITIES_PATH)/reset_1200.py
#    endif
# endif

# Commands
# ----------------------------------
# Link command
#
# COMMAND_LINK = $(CC) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--start-group $(FLAGS_LIB) -lm $(TARGET_A) -Wl,--end-group
## COMMAND_LINK = $(CC) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--start-group $(FLAGS_LIB) -Wl,--end-group
COMMAND_LINK = $(CC) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(REMOTE_OBJS) $(FIRST_OBJS_IN_LINK) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_CORE_A) -Wl,--start-group $(FLAGS_LIB) -Wl,--end-group

# COMMAND_LINK = $(CC) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -Wl,--start-group -lm $(TARGET_A) -L$(APP_LIB_PATH)/Adafruit_nRFCrypto/src/cortex-m4/fpv4-sp-d16-hard -lnrf_cc310_0.9.13-no-interrupts -Wl,--end-group
# COMMAND_LINK = $(CC) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(OBJS) $(LOCAL_ARCHIVES) -Wl,--start-group -lm -L$(APP_LIB_PATH)/Adafruit_nRFCrypto/src/cortex-m4/fpv4-sp-d16-hard -lnrf_cc310_0.9.13-no-interrupts -Wl,--end-group

# Copy command
COMMAND_COPY = $(OBJCOPY) -O ihex $< $@

# Dirty implementation for nrfutil
# WAS: /usr/local/bin/nrfutil
# NOW: export LC_ALL=en_IE.UTF-8 ; export LANG=en_IE.UTF-8 ; $(HARDWARE_PATH)/tools/adafruit-nrfutil/macos/adafruit-nrfutil
# export required as per https://click.palletsprojects.com/en/7.x/python3/
# Post-copy command
# COMMAND_POST_COPY = /usr/local/bin/nrfutil dfu genpkg --dev-type 0x0052 --sd-req $(BUILD_SD_DWID) --application $(TARGET_HEX) $(TARGET_ZIP)
# COMMAND_POST_COPY = export LC_ALL=en_IE.UTF-8 ; export LANG=en_IE.UTF-8 ; $(HARDWARE_PATH)/tools/adafruit-nrfutil/macos/adafruit-nrfutil dfu genpkg --dev-type 0x0052 --sd-req $(BUILD_SD_DWID) --application $(TARGET_HEX) $(TARGET_ZIP)

# For Linux nrfutil version 6.1.0
# $(HOME)/.arduino15/packages/adafruit/hardware/nrf52/0.21.0/tools/adafruit-nrfutil/linux/nrfutil-linux pkg generate --hw-version 0x0052 --sd-req 0x00B6 --application-version 111411 --application $(HOME)/Projets/emCode/Nouveautés/nRF52/Generic_Blink/.builds/embeddedcomputing.hex $(HOME)/Projets/emCode/Nouveautés/nRF52/Generic_Blink/.builds/embeddedcomputing.zip

# COMMAND_POST_COPY = $(HARDWARE_PATH)/tools/adafruit-nrfutil/linux/nrfutil-linux pkg generate --hw-version 0x0052 --sd-req $(BUILD_SD_DWID) --application-version $(RELEASE_NOW) --application $(TARGET_HEX) $(TARGET_ZIP)

# COMMAND_POST_COPY = $(NRFUTIL_EXEC) dfu genpkg --dev-type 0x0052 --application $(TARGET_HEX) $(TARGET_ZIP)

# COMMAND_POST_COPY = $(NRFUTIL_EXEC) pkg generate --hw-version 0x0052 --sd-req $(BUILD_SD_DWID) --application-version $(RELEASE_NOW) --application $(TARGET_HEX) $(TARGET_ZIP)
FLAG_FIRMWARE = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.sd_fwid)
# COMMAND_POST_COPY = $(NRFUTIL_EXEC) dfu genpkg --dev-type 0x0052 --sd-req $(FLAG_FIRMWARE) --application $(TARGET_HEX) $(TARGET_ZIP)

# Upload command
#
# COMMAND_UPLOAD = $(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -P$(USED_SERIAL_PORT) -Uflash:w:$(TARGET_HEX):i

endif # ADAFRUIT_NRF52_BOARDS

endif # MAKEFILE_NAME

