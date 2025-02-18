#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Created by Rei Vilo on 31 Aug 2023 
# 
# Last update: 18 Dec 2024 release 14.6.6
#

# On Linux, install pyserial with 
#	sudo apt install python-serial
#

ifeq ($(MAKEFILE_NAME),)

ARDUINO_ESP32_INITIAL = $(ARDUINO_PACKAGES_PATH)/arduino

ifneq ($(wildcard $(ARDUINO_ESP32_INITIAL)),)
    ARDUINO_ESP32_APP = $(ARDUINO_ESP32_INITIAL)
    ARDUINO_ESP32_PATH = $(ARDUINO_ESP32_APP)
    ARDUINO_ESP32_BOARDS = $(ARDUINO_ESP32_INITIAL)/hardware/esp32/$(ARDUINO_ESP32_RELEASE)/boards.txt
endif

# $(info === ARDUINO_ESP32_BOARDS $(ARDUINO_ESP32_BOARDS))
# $(info === BOARD_TAG $(BOARD_TAG))
# $(info === PARSE_FILE $(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_ESP32_BOARDS)))

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ARDUINO_ESP32_BOARDS)),)
MAKEFILE_NAME = ArduinoESP32
RELEASE_CORE = $(ARDUINO_ESP32_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# ESP32 specifics
# ----------------------------------
#
PLATFORM := Arduino ESP32
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_ESP32 EMCODE=$(RELEASE_NOW) ARDUINO_$(BUILD_BOARD) ESP32
APPLICATION_PATH := $(ARDUINO_ESP32_PATH)
PLATFORM_VERSION := $(ARDUINO_ESP32_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(APPLICATION_PATH)/hardware/esp32/$(ARDUINO_ESP32_RELEASE)

BOARDS_TXT := $(HARDWARE_PATH)/boards.txt
BUILD_CORE = $(call PARSE_BOARD,$(BOARD_TAG),build.core)
SUB_PLATFORM = $(BUILD_CORE)
BUILD_BOARD = $(call PARSE_BOARD,$(BOARD_TAG),build.board)
BUILD_VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)

# $(info === BOARDS_TXT $(BOARDS_TXT))
# $(info === BOARD_TAG $(BOARD_TAG))
BUILD_MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
BUILD_TARCH = $(call PARSE_BOARD,$(BOARD_TAG),build.tarch)
BUILD_TARGET = $(call PARSE_BOARD,$(BOARD_TAG),build.target)
SDK_PATH = $(HARDWARE_PATH)/tools/sdk/$(BUILD_MCU)

# compiler.path={runtime.tools.{build.tarch}-{build.target}-elf-gcc.path}/bin/
# TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/xtensa-esp32-elf-gcc/$(ARDUINO_GCC_ESP32_EXTENSA_RELEASE)
# TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/$(BUILD_TARCH)-$(BUILD_TARGET)-elf-gcc/$(ARDUINO_GCC_ESP32_EXTENSA_RELEASE)
# TOOL_CHAIN_PATH = $(ARDUINO_PACKAGES_PATH)/esp32/tools/$(BUILD_TARCH)-$(BUILD_TARGET)-elf-gcc/$(ARDUINO_GCC_ESP32_EXTENSA_RELEASE)
TOOL_CHAIN_PATH = $(ARDUINO_PACKAGES_PATH)/esp32/tools/s3-gcc/$(ARDUINO_GCC_ESP32_EXTENSA_RELEASE)


# $(info === TOOL_CHAIN_PATH $(TOOL_CHAIN_PATH))
# TOOL_CHAIN_PATH = $(HARDWARE_PATH)/tools/xtensa-esp32-elf
OTHER_TOOLS_PATH = $(APPLICATION_PATH)/tools/esptool_py/$(ESP32_TOOLS_RELEASE)
ESP32_TOOLS_PATH = $(ARDUINO_PACKAGES_PATH)/esp32/tools/esptool_py/$(ESP32_TOOLS_RELEASE)
# OTHER_TOOLS_PATH = $(HARDWARE_PATH)/tools

# Horrendous double-quote required by mDNS library
#
PLATFORM_TAG += ARDUINO_BOARD='"$(BUILD_BOARD)"' ARDUINO_VARIANT='"$(BUILD_VARIANT)"'

ESP_POST_COMPILE = $(PYTHON_EXEC) $(APPLICATION_PATH)/tools/esptool.py/$(ESP32_TOOLS_RELEASE)/esptool.py
BOOTLOADER_ELF = $(HARDWARE_PATH)/bootloaders/eboot/eboot.elf

# Complicated menu system for Arduino 1.5
# Another example of Arduino's quick and dirty job
#
BOARD_OPTION_TAGS_LIST = $(strip $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4) $(BOARD_TAG5) $(BOARD_TAG6) $(BOARD_TAG7) $(BOARD_TAG8) $(BOARD_TAG9) $(BOARD_TAG10))
BOARD_TAGS_LIST = $(BOARD_TAG) $(BOARD_OPTION_TAGS_LIST)

# SEARCH_FOR = $(strip $(foreach t,$(1),$(call PARSE_BOARD,$(t),$(2))))

# $(info BUILD_FLASH_SIZE $(BUILD_FLASH_SIZE))
# $(info *** BOARD_OPTION_TAGS_LIST '$(BOARD_OPTION_TAGS_LIST)')

# $(info BUILD_FLASH_SIZE $(BUILD_FLASH_SIZE))
# $(info BUILD_FLASH_FREQ $(BUILD_FLASH_FREQ))
# $(info BUILD_PARTITIONS $(BUILD_PARTITIONS))

# BUILD_PARTITIONS = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.partitions)
BUILD_PARTITIONS = $(call PARSE_BOARD,$(BOARD_TAG3),build.partitions)
ifeq ($(BUILD_PARTITIONS),)
    BUILD_PARTITIONS = $(call PARSE_BOARD,$(BOARD_TAG),build.partitions)
endif

# MAX_FLASH_SIZE might have already been defined in the board confguration file or in the main makefile.
ifeq ($(MAX_FLASH_SIZE),)
	MAX_FLASH_SIZE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),upload.maximum_size)
endif
# Not all variants define a specific MAX_FLASH_SIZE, take default one
ifeq ($(MAX_FLASH_SIZE),)
    MAX_FLASH_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),upload.maximum_size)
endif

# $(info BUILD_FLASH_SIZE $(BUILD_FLASH_SIZE))
# $(info BUILD_FLASH_FREQ $(BUILD_FLASH_FREQ))
# $(info BUILD_PARTITIONS $(BUILD_PARTITIONS))

PYTHON_EXEC = /usr/bin/python3
BOARD_FILE = $(CURRENT_DIR)/Configurations/$(SELECTED_BOARD).mk

# Variant
# 
VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)

VARIANT_C_SRCS = $(wildcard $(VARIANT_PATH)/*.c)
VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp)
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o) $(VARIANT_C_SRCS:.c=.c.o)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

# $(info >>> Variant)
# $(info > VARIANT= $(VARIANT))
# $(info > VARIANT_PATH= $(VARIANT_PATH))
# $(info > VARIANT_OBJS= $(VARIANT_OBJS))
# $(info > VARIANT_CPP_SRCS= $(VARIANT_CPP_SRCS))

# $(error sTOP)

MCU_FLAG_NAME = # mmcu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)

# bootloader.bin
# Take option first, then default
# 
# flash_size is defined twice for nodemcu and nodemcuv2, take first
#
BUILD_FLASH_SIZE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_size)
ifeq ($(BUILD_FLASH_SIZE),)
    BUILD_FLASH_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_size)
endif

BUILD_FLASH_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_freq)
# $(info === BUILD_FLASH_FREQ $(BUILD_FLASH_FREQ))
ifeq ($(BUILD_FLASH_FREQ),)
    BUILD_FLASH_FREQ = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_freq)
endif

# $(info === BUILD_FLASH_FREQ $(BUILD_FLASH_FREQ))
BUILD_FLASH_MODE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_mode)
# $(info === BUILD_FLASH_MODE $(BUILD_FLASH_MODE))
ifeq ($(BUILD_FLASH_MODE),)
    BUILD_FLASH_MODE = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode)
endif
# $(info === BUILD_FLASH_MODE $(BUILD_FLASH_MODE))

BUILD_FLASH_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_freq)
# $(info === BUILD_FLASH_FREQ-1 $(BUILD_FLASH_FREQ))
ifeq ($(BUILD_FLASH_FREQ),)
    BUILD_FLASH_FREQ = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_freq)
endif
# $(info === BUILD_FLASH_FREQ-2 $(BUILD_FLASH_FREQ))

# Default is provided by platform.txt
BUILD_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.boot)
# $(info === BUILD_BOOT-1 $(BUILD_BOOT))
ifeq ($(BUILD_BOOT),)
    BUILD_BOOT = $(call PARSE_FILE,build,boot=,$(HARDWARE_PATH)/platform.txt)
endif
# $(info === BUILD_BOOT-2 $(BUILD_BOOT))

BUILD_PSRAM_TYPE = $(call PARSE_BOARD,$(BOARD_TAG),build.psram_type)

# $(info === BUILD_MEMORY_TYPE $(BUILD_MEMORY_TYPE))
# Priority is provided by boards.txt
    esp1300a = $(call PARSE_BOARD,$(BOARD_TAG),build.memory_type)
# Default is provided by platform.txt
# $(info === esp1300a $(esp1300a))
ifeq ($(esp1300a),)
esp1300a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.memory_type)
endif
# $(info === esp1300a $(esp1300a))
esp1300b = $(shell echo $(esp1300a) | sed 's:{build.boot}:$(BUILD_BOOT):g')
esp1300c = $(shell echo $(esp1300b) | sed 's:{build.psram_type}:$(BUILD_PSRAM_TYPE):g')
BUILD_MEMORY_TYPE = $(esp1300c)

# $(info === esp1300b $(esp1300b))
# $(info === esp1300c $(esp1300c))
# $(info === BUILD_BOOT $(BUILD_BOOT))
# $(info === BUILD_PSRAM_TYPE $(BUILD_PSRAM_TYPE))
# $(info === BUILD_MEMORY_TYPE $(BUILD_MEMORY_TYPE))
# $(error STOP)

# Default is provided by platform.txt
# $(info >>> call PARSE_FILE,build,extra_flags.$(MCU),$(HARDWARE_PATH)/platform.txt)
esp1400a = $(call PARSE_FILE,build,extra_flags.$(MCU)=,$(HARDWARE_PATH)/platform.txt)

BUILD_CDC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.cdc_on_boot.$(MCU)=)
ifeq ($(BUILD_CDC_ON_BOOT),)
    BUILD_CDC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.cdc_on_boot)
endif

BUILD_DFU_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.dfu_on_boot.$(MCU)=)
ifeq ($(BUILD_DFU_ON_BOOT),)
    BUILD_DFU_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.dfu_on_boot)
endif

BUILD_MSC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.msc_on_boot.$(MCU)=)
ifeq ($(BUILD_MSC_ON_BOOT),)
    BUILD_MSC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.msc_on_boot)
endif

BUILD_USB_MODE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.usb_mode)
ifeq ($(BUILD_USB_MODE),)
    BUILD_USB_MODE = $(call SEARCH_FOR,$(BOARD_TAG),build.usb_mode)
endif

# $(info >>> build.extra_flags.$(MCU)=)
# $(info >>> BUILD_CDC_ON_BOOT '$(BUILD_CDC_ON_BOOT)')
# $(info >>> BUILD_DFU_ON_BOOT '$(BUILD_CDC_ON_BOOT)')
# $(info >>> BUILD_MSC_ON_BOOT '$(BUILD_CDC_ON_BOOT)')
# $(info >>> BUILD_USB_MODE '$(BUILD_USB_MODE)')

esp1400b = $(shell echo $(esp1400a) | sed 's:{build.cdc_on_boot}:$(BUILD_CDC_ON_BOOT):')
esp1400c = $(shell echo $(esp1400b) | sed 's:{build.dfu_on_boot}:$(BUILD_DFU_ON_BOOT):')
esp1400d = $(shell echo $(esp1400c) | sed 's:{build.msc_on_boot}:$(BUILD_MSC_ON_BOOT):')
esp1400e = $(shell echo $(esp1400d) | sed 's:{build.usb_mode}:$(BUILD_USB_MODE):')

# $(info >>> esp1400a '$(esp1400a)')
# $(info >>> esp1400b '$(esp1400b)')
# $(info >>> esp1400c '$(esp1400c)')
# $(info >>> esp1400d '$(esp1400d)')

BUILD_EXTRA_FLAGS = $(esp1400e)
BUILD_EXTRA_FLAGS += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.disable_pin_remap)

# $(error >>>)

#  Partitions
PARTITIONS_CSV = $(BUILDS_PATH)/partitions.csv
PARTITIONS_BIN = $(BUILDS_PATH)/partitions.bin
COMMAND_BEFORE_COMPILE += cp $(HARDWARE_PATH)/tools/partitions/$(BUILD_PARTITIONS).csv $(PARTITIONS_CSV) ;
COMMAND_BEFORE_COMPILE += touch $(BUILDS_PATH)/build_opt.h ; touch $(BUILDS_PATH)/files_opts.h ; 

MESSAGE_BEFORE = "Set partitions"

# Take option first, then default
BOOTLOADER_BIN = $(BUILDS_PATH)/bootloader.bin
BOOTLOADER_SOURCE_BIN = $(shell if [ -f $(VARIANT_PATH)/bootloader.bin ] ; then ls $(VARIANT_PATH)/bootloader.bin ; fi)

ifneq ($(BOOTLOADER_SOURCE_BIN),)
    COMMAND_COPY += cp $(BOOTLOADER_SOURCE_BIN) $(BOOTLOADER_BIN) ;
else
#    BOOTLOADER_BIN = $(SDK_PATH)/bin/bootloader_$(BUILD_FLASH_MODE)_$(BUILD_FLASH_FREQ).bin

    BOOTLOADER_SOURCE_ELF = $(SDK_PATH)/bin/bootloader_$(BUILD_BOOT)_$(BUILD_FLASH_FREQ).elf
#     COMMAND_COPY = $(PYTHON_EXEC) $(ESP32_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) --elf-sha256-offset 0xb0 -o $(BOOTLOADER_BIN) $(BOOTLOADER_SOURCE_ELF) ;

# recipe.objcopy.bin.pattern_args=--chip {build.mcu} elf2image --flash_mode "{build.flash_mode}" --flash_freq "{build.flash_freq}" --flash_size "{build.flash_size}" --elf-sha256-offset 0xb0 -o "{build.path}/{build.project_name}.bin" "{build.path}/{build.project_name}.elf"
    COMMAND_COPY += $(PYTHON_EXEC) $(ESP32_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) --elf-sha256-offset 0xb0 -o $(TARGET_BIN) $(TARGET_ELF) ;

    COMMAND_COPY += $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_esp32part.py -q $(PARTITIONS_CSV) $(PARTITIONS_BIN) ;

    COMMAND_BEFORE_COMPILE += $(PYTHON_EXEC) $(ESP32_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) -o $(BOOTLOADER_BIN) $(BOOTLOADER_SOURCE_ELF) ;

    MESSAGE_BEFORE += " and bootloader"
    
endif # BOOTLOADER_SOURCE_BIN
# $(info === BOOTLOADER_BIN $(BOOTLOADER_BIN))

# ifeq ($(UPLOADER),espota)
#     UPLOADER_PATH = $(HARDWARE_PATH)/tools
#     UPLOADER_EXEC = $(PYTHON_EXEC) $(UPLOADER_PATH)/espota.py
#     UPLOADER_OPTS = -r
# 
#     ifeq ($(SSH_ADDRESS),)
# #        $(eval SSH_ADDRESS = $(shell grep ^SSH_ADDRESS '$(BOARD_FILE)' | cut -d= -f 2- | sed 's/^ //'))
#         $(eval SSH_ADDRESS = $(shell grep ^SSH_ADDRESS '$(CURRENT_DIR)/Makefile' | cut -d= -f 2- | sed 's/^ //'))
#     endif # SSH_ADDRESS
# 
#     ifeq ($(SSH_ADDRESS),)
#         SSH_ADDRESS := $(shell zenity --width=240 --entry --title "emCode" --text "Enter IP address" --entry-text "192.168.1.11")
#         $(shell sed "s/^# SSH_ADDRESS =.*/SSH_ADDRESS = $(SSH_ADDRESS)/g" -i $(CURRENT_DIR)/Makefile)
#         $(shell sed "s/^SSH_ADDRESS = .*/SSH_ADDRESS = $(SSH_ADDRESS)/g" -i $(CURRENT_DIR)/Makefile)
#     endif # SSH_ADDRESS
# 
# #     $(info >>> SSH_ADDRESS = '$(SSH_ADDRESS)')
#     ifeq ($(SSH_ADDRESS),)
#         $(error SSH_ADDRESS empty)
#     endif # SSH_ADDRESS
# 
# else ifeq ($(UPLOADER),openocd-esp32)
# # Before: sudo kextunload -b com.FTDI.driver.FTDIUSBSerialDriver
# # After: sudo kextload -b com.FTDI.driver.FTDIUSBSerialDriver
# 
#     UPLOADER_PATH = $(APPLICATION_PATH)/tools/openocd-esp32/$(ESP32_OPENOCD_RELEASE)
#     UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
#     SHARED_OPTS	 = -s $(UPLOADER_PATH)/share/openocd/scripts
#     SHARED_OPTS += -f interface/ftdi/esp32_devkitj_v1.cfg
#     SHARED_OPTS += -f target/esp32.cfg
# 
#     UPLOADER_OPTS = $(SHARED_OPTS) -c "program_esp $(TARGET_BIN) 0x10000 verify exit"
# 
#     DEBUG_SERVER_PATH = $(UPLOADER_PATH)
#     DEBUG_SERVER_EXEC = $(UPLOADER_EXEC)
# 
#     DEBUG_SERVER_OPTS = $(SHARED_OPTS)
#     COMMAND_DEBUG_SERVER = $(DEBUG_SERVER_EXEC) $(DEBUG_SERVER_OPTS)
# 
# else ifeq ($(UPLOADER),dfu-util)

# ~/.arduino15/packages/arduino/tools/dfu-util/0.11.0-arduino5/dfu-util --device 0x2341:0x0070 -D ~/.var/app/cc.arduino.IDE2/cache/arduino/sketches/875B25B415F3CBA04731091289855208/Blink_Serial_01.ino.bin -Q
USB_VID = $(call PARSE_BOARD,$(BOARD_TAG),vid.0)
USB_PID = $(call PARSE_BOARD,$(BOARD_TAG),pid.0)

# $(info >>> ARDUINO_PACKAGES_PATH $(ARDUINO_PACKAGES_PATH))
# 
# $(error APPLICATION_PATH '$(APPLICATION_PATH)')

    UPLOADER_PATH = $(ARDUINO_PACKAGES_PATH)/arduino/tools/dfu-util/$(ARDUINO_DFU_UTIL_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/dfu-util

    UPLOADER_OPTS = --device $(USB_VID):$(USB_PID) -D $(TARGET_BIN) -Q

    
# else
#     UPLOADER = esptool
#     UPLOADER_PATH = $(OTHER_TOOLS_PATH)
# #     UPLOADER_EXEC = $(UPLOADER_PATH)/esptool
#     UPLOADER_EXEC = $(PYTHON_EXEC) $(UPLOADER_PATH)/esptool.py
#     UPLOADER_OPTS = --chip $(MCU) --port $(USED_SERIAL_PORT) --baud 921600
#     UPLOADER_OPTS += --before default_reset --after hard_reset write_flash -z
#     UPLOADER_OPTS += --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) 
#     UPLOADER_OPTS += --flash_size $(BUILD_FLASH_SIZE)
# # UPLOADER_OPTS += --flash_size detect
# # UPLOADER_OPTS += 0x1000 $(SDK_PATH)/bin/bootloader_dio_80m.bin
# # UPLOADER_OPTS += 0x0000 $(SDK_PATH)/bin/bootloader.bin
#     UPLOADER_OPTS += $(call PARSE_BOARD,$(BOARD_TAG),build.bootloader_addr) $(BOOTLOADER_BIN)
#     UPLOADER_OPTS += 0x8000 $(PARTITIONS_BIN)
#     UPLOADER_OPTS += 0xe000 $(HARDWARE_PATH)/tools/partitions/boot_app0.bin
#     UPLOADER_OPTS += 0x10000 $(TARGET_BIN)
# endif # UPLOADER

APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(HARDWARE_PATH)/cores/esp32

# # Release check
# # ----------------------------------
# #
# REQUIRED_ARDUINO_ESP32_RELEASE = 1.0.4
# ifeq ($(shell if [[ '$(REQUIRED_ARDUINO_ESP32_RELEASE)' > '$(REQUIRED_ARDUINO_ESP32_RELEASE)' ]] || [[ '$(ARDUINO_ESP32_RELEASE)' = '$(REQUIRED_ARDUINO_ESP32_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
# $(error ESP32 release $(REQUIRED_ARDUINO_ESP32_RELEASE) or later required, release $(ARDUINO_ESP32_RELEASE) installed)
# endif

# Generate main.cpp
# ----------------------------------
#
ifneq ($(strip $(KEEP_MAIN)),true)
    $(shell echo "// " > ./main.cpp)
    $(shell echo "// main.cpp generated by emCode" >> ./main.cpp)
    $(shell echo "// from $(CORE_LIB_PATH)/main.cpp" >> ./main.cpp)
    $(shell echo "// ----------------------------------" >> ./main.cpp)
    $(shell echo "// DO NOT EDIT THIS FILE." >> ./main.cpp)
    $(shell echo "// ----------------------------------" >> ./main.cpp)
    $(shell echo "#if defined(EMCODE)" >> ./main.cpp)
    $(shell echo " " >> ./main.cpp)
    $(shell echo "#include \"$(PROJECT_NAME_AS_IDENTIFIER).$(SKETCH_EXTENSION)\"" >> ./main.cpp)
    $(shell echo " " >> ./main.cpp)
    $(shell echo "// --- Imported main.cpp" >> ./main.cpp)
    $(shell echo " " >> ./main.cpp)
    $(shell cat $(CORE_LIB_PATH)/main.cpp >> ./main.cpp)
    $(shell echo " " >> ./main.cpp)
    $(shell echo "// --- End of Imported main.cpp" >> ./main.cpp)
    $(shell echo " " >> ./main.cpp)
    $(shell echo "#endif // EMCODE" >> ./main.cpp)
endif

# Take assembler file as first
#
APP_LIB_PATH := $(HARDWARE_PATH)/libraries
CORE_AS_SRCS = $(wildcard $(CORE_LIB_PATH)/*.S)
esp001 = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS_SRCS)))
FIRST_O_IN_A = $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(esp001))

# # Sketchbook/Libraries path
# # wildcard required for ~ management
# # ?ibraries required for libraries and Libraries
# #
# ifeq ($(ARDUINO_PREFERENCES),)
#     $(error Error: run Arduino once and define the sketchbook path)
# endif # ARDUINO_PREFERENCES
# 
# ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
#         SKETCHBOOK_DIR = $(shell grep sketchbook.path $(ARDUINO_PREFERENCES) | cut -d = -f 2)
# endif # SKETCHBOOK_DIR
# 
# ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
#    $(error Error: sketchbook path not found)
# endif # SKETCHBOOK_DIR
# 
# USER_LIB_PATH ?= $(wildcard $(SKETCHBOOK_DIR)/?ibraries)

# Tool-chain names
#
# compiler.prefix={build.tarch}-{build.target}-elf-
COMPILER_PREFIX = $(BUILD_TARCH)-$(BUILD_TARGET)-elf

CC = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-gcc
CXX = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-g++
AR = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-ar
OBJDUMP = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-objdump
OBJCOPY = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-objcopy
SIZE = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-size
NM = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-nm
GDB = $(APP_TOOLS_PATH)/$(COMPILER_PREFIX)-gdb

# $(info > CPU= '$(CPU)')
# $(info > OPTIMISATION= '$(OPTIMISATION)')

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION = -Os -g3 
    FLAGS_D += -DCORE_DEBUG_LEVEL=5
else
    OPTIMISATION ?= -Os -g 
    FLAGS_D += -DCORE_DEBUG_LEVEL=0 -DCORE_DEBUG_LEVEL=0
endif
# $(info > OPTIMISATION= '$(OPTIMISATION)')

# # Based on protocol.txt compiler.cpreprocessor.flags.esp32
esp1000a = $(call PARSE_FILE,compiler,cpreprocessor.flags.$(BUILD_MCU),$(HARDWARE_PATH)/platform.txt)
# # esp1000b = $(filter-out -DESP_PLATFORM -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H, $(esp1000a))
# esp1000c = $(shell echo $(esp1000b) | sed 's:-I{compiler.sdk.path}:$(HARDWARE_PATH)/tools/sdk:g')
# # $(info === BUILD_MCU $(BUILD_MCU))
SDK_PATH = $(HARDWARE_PATH)/tools/sdk/$(BUILD_MCU)
# esp1000b = $(shell echo $(esp1000a) | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
# FLAGS_D += -DUNITY_INCLUDE_CONFIG_H
# -DARDUINO_CORE_BUILD for core file compilation
esp1000b = $(shell echo '$(esp1000a)' | sed 's:-I{compiler.sdk.path}:$(HARDWARE_PATH)/tools/sdk:g')
$(info === esp1000b $(esp1000b))

# INCLUDE_PATH := $(esp1000b)
INCLUDE_PATH = $(CORE_LIB_PATH)
INCLUDE_PATH += $(VARIANT_PATH)

ifeq ($(wildcard $(EMCODE_TOOLS)/Cores/$(SELECTED_BOARD)_$(RELEASE_CORE).a),)
#     $(info Building core...)
#     MESSAGE_CRITICAL += First build for core. Relaunch build.
    FLAGS_D += -DARDUINO_CORE_BUILD
#     INCLUDE_PATH += ./.builds
endif

LDSCRIPT = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.flash_ld)

# Even more flags
# Final = is required to differentiate esp32 from esp32s2 or esp32c3 
# 
esp1100a = $(call PARSE_FILE,build,extra_flags=,$(HARDWARE_PATH)/platform.txt)
esp1100b = $(call PARSE_FILE,build,extra_flags.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)
esp1100c = $(esp1100a) $(esp1100b)
esp1100d = $(shell echo $(esp1100c) | sed 's:{build.extra_flags.{build.mcu}}::g')

BUILD_CODE_DEBUG = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.code_debug)
ifeq ($(BUILD_CODE_DEBUG),)
    BUILD_CODE_DEBUG = $(call PARSE_BOARD,$(BOARD_TAG),build.code_debug)
endif
ifeq ($(BUILD_CODE_DEBUG),)
    BUILD_CODE_DEBUG += 0
endif
esp1100e = $(shell echo $(esp1100d) | sed 's:{build.code_debug}:$(BUILD_CODE_DEBUG):g')

BUILD_LOOP_CORE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.loop_core)
ifeq ($(BUILD_LOOP_CORE),)
    BUILD_LOOP_CORE = $(call PARSE_BOARD,$(BOARD_TAG),build.loop_core)
endif
esp1100f = $(shell echo $(esp1100e) | sed 's:{build.loop_core}:$(BUILD_LOOP_CORE):g')

BUILD_EVENT_CORE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.event_core)
ifeq ($(BUILD_EVENT_CORE),)
    BUILD_EVENT_CORE = $(call PARSE_BOARD,$(BOARD_TAG),build.event_core)
endif
esp1100g = $(shell echo $(esp1100f) | sed 's:{build.event_core}:$(BUILD_EVENT_CORE):g')

BUILD_DEFINES = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.defines)
ifeq ($(BUILD_DEFINES),)
    BUILD_DEFINES = $(call PARSE_BOARD,$(BOARD_TAG),build.defines)
endif
ifeq ($(BOARD_TAG),nano_nora)
    BUILD_DEFINES:=#
#    FLAGS_USB += -DBOARD_HAS_PIN_REMAP -DBOARD_HAS_PSRAM -DUSB_MANUFACTURER='"Arduino"' -DUSB_PRODUCT='"Nano ESP32"'
    FLAGS_USB += -DBOARD_HAS_PSRAM -DUSB_MANUFACTURER='"Arduino"' -DUSB_PRODUCT='"Nano ESP32"'
endif
esp1100h = $(shell echo $(esp1100g) | sed 's:{build.defines}:$(BUILD_DEFINES):g')

esp1100i = $(shell echo $(esp1100h) | sed 's:{build.cdc_on_boot}:$(BUILD_CDC_ON_BOOT):g')
esp1100j = $(shell echo $(esp1100i) | sed 's:{build.msc_on_boot}:$(BUILD_MSC_ON_BOOT):g')
esp1100k = $(shell echo $(esp1100j) | sed 's:{build.dfu_on_boot}:$(BUILD_DFU_ON_BOOT):g')
esp1100l = $(shell echo $(esp1100k) | sed 's:{build.usb_mode}:$(BUILD_USB_MODE):g')
EXTRA_FLAGS = $(esp1100l)
# $(info >>> BOARD_OPTION_TAGS_LIST $(BOARD_OPTION_TAGS_LIST))
# $(info === esp1100a $(esp1100a))
# $(info === esp1100b $(esp1100b))
# $(info === esp1100c $(esp1100c))
# $(info === esp1100d $(esp1100d))
# $(info === esp1100e $(esp1100e))
# $(info === esp1100f $(esp1100f))
# $(info === esp1100g $(esp1100g))
# $(info === esp1100h $(esp1100h))
# $(info === esp1100i $(esp1100i))
# $(info === esp1100j $(esp1100j))
# $(info === esp1100k $(esp1100k))
# $(info === EXTRA_FLAGS $(EXTRA_FLAGS))
# $(error === EXTRA_FLAGS $(EXTRA_FLAGS))

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = -g $(OPTIMISATION) $(FLAGS_WARNING)
# FLAGS_ALL += $(esp1000b)
# FLAGS_ALL += -D__ets__ -DICACHE_FLASH -U__STRICT_ANSI__ -DLWIP_OPEN_SRC
# FLAGS_ALL += -DESP_PLATFORM -DESP32
# FLAGS_ALL += -DHAVE_CONFIG_H
# FLAGS_ALL += -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"'
# FLAGS_ALL += -DGCC_NOT_5_2_0=0 -DWITH_POSIX
# Standard IDE includes -fno-exceptions and -fexceptions
# emCode uses -fexceptions only
# FLAGS_ALL += -Wpointer-arith -fexceptions -fstack-protector
# FLAGS_ALL += -ffunction-sections -fdata-sections -fstrict-volatile-bitfields
# FLAGS_ALL += -mlongcalls -nostdlib -MMD -c
# FLAGS_ALL += -Wno-error=unused-function -Wno-error=unused-but-set-variable
# FLAGS_ALL += -Wno-error=unused-variable -Wno-error=deprecated-declarations
# FLAGS_ALL += -Wno-maybe-uninitialized -Wno-unused-function
# FLAGS_ALL += -Wno-unused-but-set-variable -Wno-unused-variable
# FLAGS_ALL += -Wno-unused-parameter -Wno-sign-compare
FLAGS_ALL += -DF_CPU=$(F_CPU)
FLAGS_ALL += -DARDUINO_PARTITION_$(BUILD_PARTITIONS)
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG) ARDUINO_$(BUILD_BOARD))
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))
FLAGS_ALL += $(EXTRA_FLAGS) $(BUILD_EXTRA_FLAGS)
FLAGS_ALL += $(FLAGS_USB) $(FLAGS_D)
FLAGS_ALL += @$(BUILDS_PATH)/build_opt.h @$(BUILDS_PATH)/files_opts.h
FLAGS_ALL += -D_TEST_1

# # Specific FLAGS_C for gcc only
# # gcc uses FLAGS_ALL and FLAGS_C
# #
# FLAGS_C = -std=gnu99
# # -Wno-implicit-function-declaration -Wl,-EL -fno-inline-functions -nostdlib
# FLAGS_C += -Wno-maybe-uninitialized -Wno-unused-function
# FLAGS_C += -Wno-unused-but-set-variable -Wno-unused-variable
# FLAGS_C += -Wno-deprecated-declarations -Wno-unused-parameter
# FLAGS_C += -Wno-sign-compare -Wno-old-style-declaration
# # was -std=c99
# 
# # Specific FLAGS_CPP for g++ only
# # g++ uses FLAGS_ALL and FLAGS_CPP
# #
# FLAGS_CPP = -std=gnu++11 -Wpointer-arith -fexceptions
# FLAGS_CPP += -Wno-error=maybe-uninitialized -Wno-error=unused-function
# FLAGS_CPP += -Wno-error=unused-but-set-variable -Wno-error=unused-variable
# FLAGS_CPP += -Wno-error=deprecated-declarations -Wno-unused-parameter
# FLAGS_CPP += -Wno-unused-but-set-parameter -Wno-missing-field-initializers
# FLAGS_CPP += -Wno-sign-compare -fno-rtti
# 
# # Specific FLAGS_AS for gcc assembler only
# # gcc assembler uses FLAGS_ALL and FLAGS_AS
# #
# FLAGS_AS = -x assembler-with-cpp

esp1200a = $(call PARSE_FILE,compiler,cpreprocessor.flags.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)
esp1200b = $(shell echo '$(esp1200a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1200c = $(filter-out -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h", $(esp1200b))
FLAGS_ALL += $(esp1200c)
FLAGS_ALL += -D_TEST_2
FLAGS_ALL += -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"'
FLAGS_ALL += -D_TEST_3

FLAGS_ALL += -I$(SDK_PATH)/$(BUILD_MEMORY_TYPE)/include

FLAGS_C = $(call PARSE_FILE,compiler,c.flags.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)
FLAGS_CPP = $(call PARSE_FILE,compiler,cpp.flags.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)
FLAGS_AS = $(call PARSE_FILE,compiler,S.flags.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_LD += -L$(SDK_PATH)/lib
FLAGS_LD += -L$(SDK_PATH)/ld
FLAGS_LD += -L$(SDK_PATH)/$(BUILD_MEMORY_TYPE)
FLAGS_LD += $(call PARSE_FILE,compiler,c.elf.flags.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)
# recipe.c.combine.pattern="{compiler.path}{compiler.c.elf.cmd}" "-Wl,--Map={build.path}/{build.project_name}.map" "-L{compiler.sdk.path}/lib" "-L{compiler.sdk.path}/ld" {compiler.c.elf.flags} {compiler.c.elf.extra_flags} -Wl,--start-group {build.extra_flags} {object_files} "{archive_file_path}" {compiler.c.elf.libs} {compiler.libraries.FLAGS_LD} -Wl,--end-group -Wl,-EL -o "{build.path}/{build.project_name}.elf"
# -Wl,--gc-sections
FLAGS_LD += $(EXTRA_FLAGS) $(FLAGS_USB)

# $(info >>> )
# $(info >>> EXTRA_FLAGS $(EXTRA_FLAGS))
# $(info >>> FLAGS_USB $(FLAGS_USB))
# $(info >>> FLAGS_D $(FLAGS_D))

# FLAGS_LD += -nostdlib
# # -L$(HARDWARE_PATH)/tools/sdk -L{compiler.sdk.path}/ld
# FLAGS_LD += -T esp32_out.ld -T esp32.project.ld -T esp32.rom.ld
# FLAGS_LD += -T esp32.peripherals.ld -T esp32.rom.libgcc.ld
# FLAGS_LD += -T esp32.rom.spiram_incompatible_fns.ld
# FLAGS_LD += -u esp_app_desc -u ld_include_panic_highint_hdl -u call_user_start_cpu0
# FLAGS_LD += -Wl,--gc-sections -Wl,-static
# FLAGS_LD += -Wl,--undefined=uxTopUsedPriority -Wl,-EL
# FLAGS_LD += -u __cxa_guard_dummy -u __cxx_fatal_exception
FLAGS_LD += -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map
# FLAGS_LD += -Wl,--gc-sections -Wl,-wrap,system_restart_local -Wl,-wrap,register_chipv6_phy

# FLAGS_L = -lgcc -lopenssl -lbtdm_app -lfatfs -lwps -lcoexist -lwear_levelling -lesp_http_client -lhal -lnewlib -ldriver -lbootloader_support -lpp -lmesh -lsmartconfig -ljsmn -lwpa -lethernet -lphy -lapp_trace -lconsole -lulp -lwpa_supplicant -lfreertos -lbt -lmicro-ecc -lcxx -lxtensa-debug-module -lmdns -lvfs -lsoc -lcore -lsdmmc -lcoap -ltcpip_adapter -lc_nano -lesp-tls -lrtc -lspi_flash -lwpa2 -lesp32 -lapp_update -lnghttp -lspiffs -lespnow -lnvs_flash -lesp_adc_cal -llog -lsmartconfig_ack -lexpat -lm -lc -lheap -lmbedtls -llwip -lnet80211 -lpthread -ljson  -lstdc++
# grep ^$(1).$(2) $(3)
FLAGS_L = $(call PARSE_FILE,compiler,c.elf.libs.$(BUILD_MCU)=,$(HARDWARE_PATH)/platform.txt)

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode)

# Target
#
TARGET_HEXBIN = $(TARGET_BIN)
# TARGET_BIN1 = $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).bin1

# VARIANT_SORTED_OBJS = $(OBJDIR)/variants/$(VARIANT)/dfu_callbacks.cpp.o $(OBJDIR)/variants/$(VARIANT)/double_tap.c.o $(OBJDIR)/variants/$(VARIANT)/io_pin_remap.cpp.o $(OBJDIR)/variants/$(VARIANT)/variant.cpp.o

# Commands
# ----------------------------------
# Link command
#
## COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) $(FLAGS_L) -Wl,--end-group -Wl,-EL
# COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_OBJS) $(USER_ARCHIVES) $(APP_LIB_OBJS) $(BUILD_APP_LIB_OBJS) $(VARIANT_SORTED_OBJS) $(TARGET_CORE_A) $(FLAGS_L) -Wl,--end-group -Wl,-ELVARIANT_SORTED_OBJS has no impact
# COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_OBJS) $(USER_ARCHIVES) $(APP_LIB_OBJS) $(BUILD_APP_LIB_OBJS) $(VARIANT_OBJS) $(TARGET_CORE_A) $(FLAGS_L) -Wl,--end-group -Wl,-EL # works
COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(VARIANT_OBJS) $(TARGET_A) $(TARGET_CORE_A) $(FLAGS_L) -Wl,--end-group -Wl,-EL # works 
# COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(USER_OBJS) $(VARIANT_OBJS) $(CORE_OBJS) $(BUILD_CORE_OBJS) $(FLAGS_L) -Wl,--end-group -Wl,-EL # fails

# COMMAND_COPY += $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_insights_package.py $(BUILDS_PATH) 
# $(info === BUILD_PARTITIONS $(BUILD_PARTITIONS))
# Option 1: no partition
# COMMAND_COPY += $(PYTHON_EXEC) $(ESP32_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) -o $@ $<

# Option 2: with partition

# COMMAND_POST_COPY = $(OTHER_TOOLS_PATH)/esptool --chip esp32 elf2image --flash_mode $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode) --flash_freq 80m --flash_size $(call PARSE_BOARD,$(BOARD_TAG),build.flash_size) -o $@ $<

esp1500a := $(call PARSE_BOARD,$(BOARD_TAG),tools.esptool_py.program.pattern_args)

# $(info > BOARDS_TXT $(BOARDS_TXT))
# $(info > $(BOARD_TAG).tools.esptool_py.program.pattern_args)
# $(info > esp1500a $(esp1500a))
# $(info > $(subst {build.mcu},$(MCU),$(esp1500a)))
# esp1500b = $(subst {build.mcu},$(MCU),$(esp1500a))
# $(info > esp1500b $(esp1500b))

ifneq ($(esp1500a),)
#     esp1500b = $(subst {build.mcu},$(MCU),$(esp1500a))
#     --chip {build.mcu} 
    esp1500b = $(shell echo $(esp1500a) | sed 's:{build.mcu}:$(MCU):g')

#     --port "{serial.port}" 
ifeq ($(USED_SERIAL_PORT),)
    esp1500c = $(shell echo $(esp1500b) | sed 's:--port {serial.port}::g')
else 
    esp1500c = $(shell echo $(esp1500b) | sed 's:{serial.port}:$(USED_SERIAL_PORT):g')
endif

#     --before default_reset --after hard_reset write_flash -z 
#     --flash_mode {build.flash_mode} 
    esp1500d = $(shell echo $(esp1500c) | sed 's:{build.flash_mode}:$(BUILD_FLASH_MODE):g')

#     --flash_freq {build.flash_freq} 
    esp1500e = $(shell echo $(esp1500d) | sed 's:{build.flash_freq}:$(BUILD_FLASH_FREQ):g')

#     --flash_size {build.flash_size} 
    esp1500f = $(shell echo $(esp1500e) | sed 's:{build.flash_size}:$(BUILD_FLASH_SIZE):g')

#     {build.bootloader_addr} "{build.path}/{build.project_name}.bootloader.bin" 
    BUILD_BOOTLOADER_ADDR = $(call PARSE_BOARD,$(BOARD_TAG),build.bootloader_addr)
    esp1500g = $(shell echo $(esp1500f) | sed 's:{build.bootloader_addr}:$(BUILD_BOOTLOADER_ADDR):g')
    esp1500h = $(shell echo $(esp1500g) | sed 's:{build.path}/{build.project_name}.bootloader.bin:$(BOOTLOADER_BIN):g')

#     0x8000 "{build.path}/{build.project_name}.partitions.bin" 
    esp1500i = $(shell echo $(esp1500h) | sed 's:{build.path}/{build.project_name}.partitions.bin:$(PARTITIONS_BIN):g')

#     0xe000 "{runtime.platform.path}/tools/partitions/boot_app0.bin" 
    esp1500j = $(shell echo $(esp1500i) | sed 's:{runtime.platform.path}:$(HARDWARE_PATH):g')

#     0xf70000 "{build.variant.path}/extra/nora_recovery/nora_recovery.ino.bin" 
    esp1500k = $(shell echo $(esp1500j) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')

#     0x10000 "{build.path}/{build.project_name}.bin"
    esp1500l = $(shell echo $(esp1500k) | sed 's:{build.path}/{build.project_name}.bin:$(TARGET_BIN):g')

#     COMMAND_POST_COPY = $(PYTHON_EXEC) $(ESP32_TOOLS_PATH)/esptool.py $(esp1500l)

# $(info > esp1500b $(esp1500b))
# $(info > esp1500c $(esp1500c))
# $(info > esp1500d $(esp1500d))
# $(info > esp1500e $(esp1500e))
# $(info > esp1500f $(esp1500f))
# $(info > esp1500g $(esp1500g))
# $(info > esp1500h $(esp1500h))
# $(info > esp1500i $(esp1500i))
# $(info > esp1500j $(esp1500j))
# $(info > esp1500k $(esp1500k))
else
    COMMAND_POST_COPY = $(PYTHON_EXEC) $(ESP32_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) -o $@ $<
endif

# COMMAND_POST_COPY = $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/esptool.py --chip esp32 elf2image --flash_mode $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode) --flash_freq 80m --flash_size $(call PARSE_BOARD,$(BOARD_TAG),build.flash_size) -o $@ $<
# $(call PARSE_BOARD,$(BOARD_TAG),build.flash_freq) = 80m

# Upload command
#
ifeq ($(UPLOADER),espota)
    COMMAND_UPLOAD = $(UPLOADER_EXEC) -i $(SSH_ADDRESS) -f $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).bin $(UPLOADER_OPTS)

else # UPLOADER

    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS)

endif # UPLOADER

# COMMAND_BEFORE_COMPILE :=
# COMMAND_POST_COPY :=

endif # ARDUINO_ESP32_BOARDS

endif # MAKEFILE_NAME
