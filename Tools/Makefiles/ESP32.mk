#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Last update: 22 Nov 2024 release 14.6.1
#

# On Linux, install pyserial with 
#	sudo apt install python-serial
#

ifeq ($(MAKEFILE_NAME),)

ESP32_INITIAL = $(ARDUINO_PACKAGES_PATH)/esp32

ifneq ($(wildcard $(ESP32_INITIAL)),)
    ESP32_APP = $(ESP32_INITIAL)
    ESP32_PATH = $(ESP32_APP)
    ESP32_BOARDS = $(ESP32_INITIAL)/hardware/esp32/$(ESP32_RELEASE)/boards.txt
endif

# $(info === ESP32_BOARDS $(ESP32_BOARDS))
# $(info === BOARD_TAG $(BOARD_TAG))
# $(info === PARSE_FILE $(call PARSE_FILE,$(BOARD_TAG),name,$(ESP32_BOARDS)))

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ESP32_BOARDS)),)
MAKEFILE_NAME = ESP32
RELEASE_CORE = $(ESP32_RELEASE)
READY_FOR_EMCODE_NEXT = 1

ifeq ($(wildcard $(EMCODE_TOOLS)/Cores/$(SELECTED_BOARD)_$(RELEASE_CORE).a),)
    FLAG_BUILD_CORE_A = 1
else
    FLAG_BUILD_CORE_A = 0
endif

# ifneq ($(BOARD_TAG),esp32)
# ifneq ($(BOARD_TAG),featheresp32)
# ifneq ($(BOARD_TAG),pico32)
#     MESSAGE_WARNING = BETA! Not yet tested against $(CONFIG_NAME).
# endif # BOARD_TAG
# endif # BOARD_TAG
# endif # BOARD_TAG

# ESP32 specifics
# ----------------------------------
#
PLATFORM := ESP32
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_ESP32 ESP32=ESP32 EMCODE=$(RELEASE_NOW) ARDUINO_$(BUILD_BOARD) ESP32
APPLICATION_PATH := $(ESP32_PATH)
PLATFORM_VERSION := $(ESP32_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(APPLICATION_PATH)/hardware/esp32/$(ESP32_RELEASE)

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

ifeq ($(BUILD_MCU),esp32) 
    TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-x32/$(ESP32_EXTENSA_RELEASE)
else ifeq ($(BUILD_MCU),esp32c2) 

else ifeq ($(BUILD_MCU),esp32c3) 
    TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-rv32/$(ESP32_EXTENSA_RELEASE)
else ifeq ($(BUILD_MCU),esp32c6) 
    TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-rv32/$(ESP32_EXTENSA_RELEASE)
else ifeq ($(BUILD_MCU),esp32h2) 
    TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-rv32/$(ESP32_EXTENSA_RELEASE)
else ifeq ($(BUILD_MCU),esp32s2) 
    TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-xs2/$(ESP32_EXTENSA_RELEASE)
else ifeq ($(BUILD_MCU),esp32s3) 
#     TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-xs3/$(ESP32_EXTENSA_RELEASE)
    TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/esp-x32/$(ESP32_EXTENSA_RELEASE)
endif

# compiler.path={runtime.tools.{build.tarch}-{build.target}-elf-gcc.path}/bin/
# TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/xtensa-esp32-elf-gcc/$(ESP32_EXTENSA_RELEASE)
# TOOL_CHAIN_PATH = $(APPLICATION_PATH)/tools/$(BUILD_TARCH)-$(BUILD_TARGET)-elf-gcc/$(ESP32_EXTENSA_RELEASE)
# $(info === TOOL_CHAIN_PATH $(TOOL_CHAIN_PATH))
# TOOL_CHAIN_PATH = $(HARDWARE_PATH)/tools/xtensa-esp32-elf
OTHER_TOOLS_PATH = $(APPLICATION_PATH)/tools/esptool_py/$(ESP32_TOOLS_RELEASE)
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
ifeq ($(BUILD_PARTITIONS),)
    BUILD_PARTITIONS = partitions
endif

# MAX_FLASH_SIZE might have already been defined in the board confguration file or in the main makefile.
ifeq ($(MAX_FLASH_SIZE),)
	MAX_FLASH_SIZE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),upload.maximum_size)
endif
# Not all variants define a specific MAX_FLASH_SIZE, take default one
ifeq ($(MAX_FLASH_SIZE),)
    MAX_FLASH_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),upload.maximum_size)
endif

BUILD_BOOTLOADER = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.custom_bootloader)
ifeq ($(BUILD_BOOTLOADER),)
    BUILD_BOOTLOADER = bootloader
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

VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp)
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

# $(info >>> Variant)
# $(info > VARIANT= $(VARIANT))
# $(info > VARIANT_PATH= $(VARIANT_PATH))

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

BUILD_IMG_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.img_freq)
# $(info === BUILD_IMG_FREQ-1 $(BUILD_IMG_FREQ))
ifeq ($(BUILD_IMG_FREQ),)
    BUILD_IMG_FREQ = $(call PARSE_BOARD,$(BOARD_TAG),build.img_freq)
endif
ifeq ($(BUILD_IMG_FREQ),)
    BUILD_IMG_FREQ := $(BUILD_FLASH_FREQ)
endif
# $(info === BUILD_IMG_FREQ-2 $(BUILD_IMG_FREQ))

# $(info === BUILD_FLASH_FREQ $(BUILD_FLASH_FREQ))
BUILD_FLASH_MODE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_mode)
# $(info === BUILD_FLASH_MODE $(BUILD_FLASH_MODE))
ifeq ($(BUILD_FLASH_MODE),)
    BUILD_FLASH_MODE = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode)
endif
# $(info === BUILD_FLASH_MODE $(BUILD_FLASH_MODE))
BUILD_FLASH_MODE := dio

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

BUILD_BOOT_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.boot_freq)
# $(info === BUILD_BOOT_FREQ-1 $(BUILD_BOOT_FREQ))
ifeq ($(BUILD_BOOT_FREQ),)
    BUILD_BOOT_FREQ = $(BUILD_FLASH_FREQ)
endif
# $(info === BUILD_BOOT_FREQ-2 $(BUILD_BOOT_FREQ))

# Default is provided by platform.txt
esp1300a = $(call PARSE_BOARD,$(BOARD_TAG),build.memory_type)
# $(info === BUILD_MEMORY_TYPE-1 $(BUILD_MEMORY_TYPE))
ifeq ($(esp1300a),)
    esp1300a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.memory_type)
#     $(info === BUILD_MEMORY_TYPE-2 $(BUILD_MEMORY_TYPE))
endif
ifeq ($(esp1300a),)
    esp1300a = $(call PARSE_FILE,build,memory_type,$(HARDWARE_PATH)/platform.txt)
#     $(info === BUILD_MEMORY_TYPE-3 $(BUILD_MEMORY_TYPE))
endif
esp1300b = $(shell echo '$(esp1300a)' | sed 's:{build.boot}:$(BUILD_BOOT):g')

esp1300c = $(call PARSE_BOARD,$(BOARD_TAG),build.psram_type)
BUILD_PSRAM_TYPE = $(esp1300c)

esp1300d = $(shell echo '$(esp1300b)' | sed 's:{build.psram_type}:$(BUILD_PSRAM_TYPE):g')

BUILD_MEMORY_TYPE = $(esp1300d)
# $(info === BUILD_MEMORY_TYPE-4 $(BUILD_MEMORY_TYPE))

# Default is provided by platform.txt
# $(info >>> call PARSE_FILE,build,FLAGS_EXTRA.$(MCU),$(HARDWARE_PATH)/platform.txt)
esp1400a = $(call PARSE_FILE,build,extra_flags.$(MCU)=,$(HARDWARE_PATH)/platform.txt)

BUILD_CDC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.cdc_on_boot=)
# $(info >>> BUILD_CDC_ON_BOOT-A '$(BUILD_CDC_ON_BOOT)')
ifeq ($(BUILD_CDC_ON_BOOT),)
    BUILD_CDC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.cdc_on_boot)
#     $(info >>> BUILD_CDC_ON_BOOT-2 '$(BUILD_CDC_ON_BOOT)')
endif

BUILD_DFU_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.dfu_on_boot=)
# $(info >>> BUILD_DFU_ON_BOOT-1 '$(BUILD_DFU_ON_BOOT)')
ifeq ($(BUILD_DFU_ON_BOOT),)
    BUILD_DFU_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.dfu_on_boot)
#     $(info >>> BUILD_DFU_ON_BOOT-2 '$(BUILD_DFU_ON_BOOT)')
endif

BUILD_MSC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.msc_on_boot=)
# $(info >>> BUILD_MSC_ON_BOOT-1 '$(BUILD_MSC_ON_BOOT)')
ifeq ($(BUILD_MSC_ON_BOOT),)
    BUILD_MSC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.msc_on_boot)
#     $(info >>> BUILD_MSC_ON_BOOT-2 '$(BUILD_MSC_ON_BOOT)')
endif

BUILD_USB_MODE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.usb_mode)
# $(info >>> BUILD_USB_MODE-1 '$(BUILD_USB_MODE)')
ifeq ($(BUILD_USB_MODE),)
    BUILD_USB_MODE = $(call SEARCH_FOR,$(BOARD_TAG),build.usb_mode)
#     $(info >>> BUILD_USB_MODE-2 '$(BUILD_USB_MODE)')
endif

# $(info >>> build.FLAGS_EXTRA.$(MCU)=)
# $(info >>> BUILD_CDC_ON_BOOT '$(BUILD_CDC_ON_BOOT)')
# $(info >>> BUILD_DFU_ON_BOOT '$(BUILD_DFU_ON_BOOT)')
# $(info >>> BUILD_MSC_ON_BOOT '$(BUILD_MSC_ON_BOOT)')
# $(info >>> BUILD_USB_MODE '$(BUILD_USB_MODE)')

# build.FLAGS_EXTRA.esp32s3=-DARDUINO_USB_MODE={build.usb_mode} -DARDUINO_USB_CDC_ON_BOOT={build.cdc_on_boot} 
# -DARDUINO_USB_MSC_ON_BOOT={build.msc_on_boot} -DARDUINO_USB_DFU_ON_BOOT={build.dfu_on_boot}
esp1400b = $(shell echo '$(esp1400a)' | sed 's:{build.usb_mode}:$(BUILD_USB_MODE):')
esp1400c = $(shell echo '$(esp1400b)' | sed 's:{build.cdc_on_boot}:$(BUILD_CDC_ON_BOOT):')
esp1400d = $(shell echo '$(esp1400c)' | sed 's:{build.msc_on_boot}:$(BUILD_MSC_ON_BOOT):')
esp1400e = $(shell echo '$(esp1400d)' | sed 's:{build.dfu_on_boot}:$(BUILD_DFU_ON_BOOT):')
# esp1400f = $(shell echo '$(esp1400e)' | sed 's:{runtime.os}":linux:')
# esp1400g = $(shell echo '$(esp1400f)' | sed 's/{build.fqbn}"/esp32:$(BUILD_CORE):$(BOARD_TAG)/')

FLAGS_BUILD_EXTRA = $(esp1400e)

# $(info === esp1400a '$(esp1400a)')
# $(info === esp1400b '$(esp1400b)')
# $(info === esp1400c '$(esp1400c)')
# $(info === esp1400d '$(esp1400d)')
# $(info === esp1400e '$(esp1400e)')
# $(info >>> FLAGS_BUILD_EXTRA '$(FLAGS_BUILD_EXTRA)')

# Take option first, then default
BOOTLOADER_BUILDS_BIN = $(BUILDS_PATH)/bootloader.bin
BOOTLOADER_SOURCE_BIN = $(shell if [ -f $(VARIANT_PATH)/bootloader.bin ] ; then ls $(VARIANT_PATH)/bootloader.bin ; fi)

# $(info >>> BOOTLOADER_BUILDS_BIN $(BOOTLOADER_BUILDS_BIN))
# $(info >>> BOOTLOADER_SOURCE_BIN $(BOOTLOADER_SOURCE_BIN))

ifneq ($(BOOTLOADER_SOURCE_BIN),)
    COMMAND_COPY = cp $(BOOTLOADER_SOURCE_BIN) $(BOOTLOADER_BUILDS_BIN) ;
else
#    BOOTLOADER_BUILDS_BIN = $(SDK_PATH)/bin/bootloader_$(BUILD_FLASH_MODE)_$(BUILD_FLASH_FREQ).bin
    BOOTLOADER_SOURCE_ELF = $(SDK_PATH)/bin/bootloader_$(BUILD_FLASH_MODE)_$(BUILD_FLASH_FREQ).elf
    COMMAND_COPY = $(PYTHON_EXEC) $(OTHER_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) -o $(BOOTLOADER_BUILDS_BIN) $(BOOTLOADER_SOURCE_ELF) ;
endif # BOOTLOADER_SOURCE_BIN
# $(info === BOOTLOADER_BUILDS_BIN $(BOOTLOADER_BUILDS_BIN))

ifeq ($(UPLOADER),espota)
    UPLOADER_PATH = $(HARDWARE_PATH)/tools
    UPLOADER_EXEC = $(PYTHON_EXEC) $(UPLOADER_PATH)/espota.py
    UPLOADER_OPTS = -r

    ifeq ($(SSH_ADDRESS),)
#         $(eval SSH_ADDRESS = $(shell grep ^SSH_ADDRESS '$(BOARD_FILE)' | cut -d= -f 2- | sed 's/^ //'))
        $(eval SSH_ADDRESS = $(shell grep ^SSH_ADDRESS '$(CURRENT_DIR)/Makefile' | cut -d= -f 2- | sed 's/^ //'))
    endif # SSH_ADDRESS

    ifeq ($(SSH_ADDRESS),)
        SSH_ADDRESS := $(shell zenity --width=240 --entry --title "emCode" --text "Enter IP address" --entry-text "192.168.1.11")
        $(shell sed "s/^# SSH_ADDRESS =.*/SSH_ADDRESS = $(SSH_ADDRESS)/g" -i $(CURRENT_DIR)/Makefile)
        $(shell sed "s/^SSH_ADDRESS = .*/SSH_ADDRESS = $(SSH_ADDRESS)/g" -i $(CURRENT_DIR)/Makefile)
    endif # SSH_ADDRESS

#     $(info >>> SSH_ADDRESS = '$(SSH_ADDRESS)')
    ifeq ($(SSH_ADDRESS),)
        $(info ERROR              SSH_ADDRESS empty)
        $(info .)
        $(call MESSAGE_GUI_ERROR,SSH_ADDRESS empty)
        $(error Stop)
    endif # SSH_ADDRESS

else ifeq ($(UPLOADER),openocd-esp32)
# Before: sudo kextunload -b com.FTDI.driver.FTDIUSBSerialDriver
# After: sudo kextload -b com.FTDI.driver.FTDIUSBSerialDriver

    UPLOADER_PATH = $(APPLICATION_PATH)/tools/openocd-esp32/$(ESP32_OPENOCD_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    SHARED_OPTS	 = -s $(UPLOADER_PATH)/share/openocd/scripts
    SHARED_OPTS += -f interface/ftdi/esp32_devkitj_v1.cfg
    SHARED_OPTS += -f target/esp32.cfg

    UPLOADER_OPTS = $(SHARED_OPTS) -c "program_esp $(TARGET_BIN) 0x10000 verify exit"

    DEBUG_SERVER_PATH = $(UPLOADER_PATH)
    DEBUG_SERVER_EXEC = $(UPLOADER_EXEC)

    DEBUG_SERVER_OPTS = $(SHARED_OPTS)
    COMMAND_DEBUG_SERVER = $(DEBUG_SERVER_EXEC) $(DEBUG_SERVER_OPTS)

else ifeq ($(UPLOADER),dfu-util)

    USB_VID = $(call PARSE_BOARD,$(BOARD_TAG),upload_port.0.vid)
    USB_PID = $(call PARSE_BOARD,$(BOARD_TAG),upload_port.0.pid)

    UPLOADER_PATH = $(ARDUINO_PACKAGES_PATH)/arduino/tools/dfu-util/$(ARDUINO_DFU_UTIL_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/dfu-util

    UPLOADER_OPTS = --device $(USB_VID):$(USB_PID) -D $(TARGET_BIN) -Q

else # UPLOADER

    UPLOADER = esptool
    UPLOADER_PATH = $(OTHER_TOOLS_PATH)
#     UPLOADER_EXEC = $(UPLOADER_PATH)/esptool
    UPLOADER_EXEC = $(PYTHON_EXEC) $(UPLOADER_PATH)/esptool.py
    UPLOADER_OPTS = --chip $(MCU) --port $(USED_SERIAL_PORT) --baud 921600
    UPLOADER_OPTS += --before default_reset --after hard_reset write_flash -z
    UPLOADER_OPTS += --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) 
    UPLOADER_OPTS += --flash_size $(BUILD_FLASH_SIZE)
# UPLOADER_OPTS += --flash_size detect
# UPLOADER_OPTS += 0x1000 $(SDK_PATH)/bin/bootloader_dio_80m.bin
# UPLOADER_OPTS += 0x0000 $(SDK_PATH)/bin/bootloader.bin
    UPLOADER_OPTS += $(call PARSE_BOARD,$(BOARD_TAG),build.bootloader_addr) $(BOOTLOADER_BUILDS_BIN)
    UPLOADER_OPTS += 0x8000 $(PARTITIONS_BUILDS_BIN)
    UPLOADER_OPTS += 0xe000 $(HARDWARE_PATH)/tools/partitions/boot_app0.bin
    UPLOADER_OPTS += 0x10000 $(TARGET_BIN)

endif # UPLOADER

APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(HARDWARE_PATH)/cores/esp32

# # Release check
# # ----------------------------------
# #
# REQUIRED_ESP32_RELEASE = 1.0.4
# ifeq ($(shell if [[ '$(REQUIRED_ESP32_RELEASE)' > '$(REQUIRED_ESP32_RELEASE)' ]] || [[ '$(ESP32_RELEASE)' = '$(REQUIRED_ESP32_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
# $(error ESP32 release $(REQUIRED_ESP32_RELEASE) or later required, release $(ESP32_RELEASE) installed)
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
$(shell cat $(CORE_LIB_PATH)/main.cpp >> ./main.cpp)
$(shell echo " " >> ./main.cpp)
$(shell echo "#include \"$(PROJECT_NAME_AS_IDENTIFIER).$(SKETCH_EXTENSION)\"" >> ./main.cpp)
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
# endif # ARDUINO_LIBRARY_PATH
# 
# ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
#         SKETCHBOOK_DIR = $(shell grep sketchbook.path $(ARDUINO_PREFERENCES) | cut -d = -f 2)
# endif # SKETCHBOOK_DIR
# 
# ifeq ($(shell if [ -d '$(SKETCHBOOK_DIR)' ]; then echo 1 ; fi ),)
#    $(call MESSAGE_GUI_ERROR,Sketchbook path not found)
#    $(info ERROR              Sketchbook path not found)
#    $(shell zenity --width=240 --title "emCode" --text "Sketchbook path not found" --error)
#    $(error Stop)
# endif # SKETCHBOOK_DIR
# 
# USER_LIB_PATH ?= $(wildcard $(SKETCHBOOK_DIR)/?ibraries)

# Tool-chain names
#
# compiler.prefix={build.tarch}-{build.target}-elf-
COMPILER_PREFIX = $(BUILD_TARCH)-$(BUILD_TARGET)-elf
# $(info >>> COMPILER_PREFIX= '$(COMPILER_PREFIX)')

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
    FLAGS_D += -DCORE_DEBUG_LEVEL=0
endif
# $(info > OPTIMISATION= '$(OPTIMISATION)')

# # Based on protocol.txt compiler.cpreprocessor.flags.esp32
# esp1000a = $(call PARSE_FILE,compiler,cpreprocessor.flags.$(BUILD_MCU),$(HARDWARE_PATH)/platform.txt)
# # esp1000b = $(filter-out -DESP_PLATFORM -DMBEDTLS_CONFIG_FILE="mbedtls/esp_config.h" -DHAVE_CONFIG_H, $(esp1000a))
# # esp1000c = $(shell echo '$(esp1000b)' | sed 's:-I{compiler.sdk.path}:$(HARDWARE_PATH)/tools/sdk:g')
# # $(info === BUILD_MCU $(BUILD_MCU))
SDK_PATH = $(APPLICATION_PATH)/tools/esp32-arduino-libs/$(ESP32_IDF_RELEASE)/$(BUILD_MCU)
# esp1000b = $(shell echo '$(esp1000a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
# FLAGS_D += -DUNITY_INCLUDE_CONFIG_H
# -DARDUINO_CORE_BUILD for core file compilation
# FLAGS_D += -DARDUINO_CORE_BUILD

# INCLUDE_PATH := $(esp1000b)
INCLUDE_PATH = $(CORE_LIB_PATH)
INCLUDE_PATH += $(VARIANT_PATH)

LDSCRIPT = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.flash_ld)

# Even more flags
# Final = is required to differentiate esp32 from esp32s2 or esp32c3 

# $(info >>> HARDWARE_PATH '$(HARDWARE_PATH)')
# 
esp1100a = $(call PARSE_FILE,build,extra_flags=,$(HARDWARE_PATH)/platform.txt)
# esp1100b = $(call PARSE_FILE,build,FLAGS_EXTRA.$(MCU)=,$(HARDWARE_PATH)/platform.txt)

# build.FLAGS_EXTRA=-DARDUINO_HOST_OS="{runtime.os}" -DARDUINO_FQBN="{build.fqbn}" 
# -DESP32 -DCORE_DEBUG_LEVEL={build.code_debug} {build.loop_core} {build.event_core} 
# {build.defines} {build.FLAGS_EXTRA.{build.mcu}} {build.zigbee_mode}

# esp1100b = $(shell echo '$(esp1200a)' | sed 's:{runtime.os}:\"linux\":')
# esp1100c = $(shell echo '$(esp1200b)' | sed 's/{build.fqbn}/\"esp32:$(BUILD_CORE):$(BOARD_TAG)\"/')

esp1100b = $(shell echo '$(esp1100a)' | sed 's:-DARDUINO_HOST_OS="{runtime.os}"::g')
esp1100d = $(shell echo '$(esp1100b)' | sed 's:-DARDUINO_FQBN="{build.fqbn}"::g')

BUILD_CODE_DEBUG = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.code_debug)
ifeq ($(BUILD_CODE_DEBUG),)
    BUILD_CODE_DEBUG = $(call PARSE_BOARD,$(BOARD_TAG),build.code_debug)
endif
ifeq ($(BUILD_CODE_DEBUG),)
    BUILD_CODE_DEBUG += 0
endif
esp1100e = $(shell echo '$(esp1100d)' | sed 's:{build.code_debug}:$(BUILD_CODE_DEBUG):g')

BUILD_LOOP_CORE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.loop_core)
ifeq ($(BUILD_LOOP_CORE),)
    BUILD_LOOP_CORE = $(call PARSE_BOARD,$(BOARD_TAG),build.loop_core)
endif
esp1100f = $(shell echo '$(esp1100e)' | sed 's:{build.loop_core}:$(BUILD_LOOP_CORE):g')

BUILD_EVENT_CORE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.event_core)
ifeq ($(BUILD_EVENT_CORE),)
    BUILD_EVENT_CORE = $(call PARSE_BOARD,$(BOARD_TAG),build.event_core)
endif
esp1100g = $(shell echo '$(esp1100f)' | sed 's:{build.event_core}:$(BUILD_EVENT_CORE):g')

BUILD_DEFINES = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.defines)
# $(info >>> BUILD_DEFINES-1 $(BUILD_DEFINES))
ifeq ($(BUILD_DEFINES),)
#     $(info >>> BUILD_DEFINES-2 $(BUILD_DEFINES))
    BUILD_DEFINES = $(call PARSE_BOARD,$(BOARD_TAG),build.defines)
endif
ifeq ($(BOARD_TAG),nano_nora)
    esp1100m = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.disable_pin_remap)
    BUILD_DEFINES:=#
# nano_nora.build.defines=-DBOARD_HAS_PIN_REMAP {build.disable_pin_remap} -DBOARD_HAS_PSRAM '-DUSB_MANUFACTURER="Arduino"' '-DUSB_PRODUCT="Nano ESP32"'
    FLAGS_USB += -DBOARD_HAS_PIN_REMAP $(esp1100m) -DBOARD_HAS_PSRAM -DUSB_MANUFACTURER='"Arduino"' -DUSB_PRODUCT='"Nano ESP32"'
#     $(info >>> esp1100m $(esp1100m))
#     $(info >>> FLAGS_USB-3 $(FLAGS_USB))
endif
#     $(info >>> BUILD_DEFINES-4 $(BUILD_DEFINES))
esp1100h = $(shell echo '$(esp1100g)' | sed 's:{build.defines}:$(BUILD_DEFINES):g')

esp1100i = $(shell echo '$(esp1100h)' | sed 's:{build.extra_flags.{build.mcu}}:$(FLAGS_BUILD_EXTRA):g')

BUILD_ZIGBEE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.zigbee_mode)
ifeq ($(BUILD_DEFINES),)
    BUILD_ZIGBEE = $(call PARSE_BOARD,$(BOARD_TAG),build.zigbee_mode)
    BUILD_ZIGBEE = $(call PARSE_FILE,build,zigbee_mode=,$(HARDWARE_PATH)/platform.txt)
endif

esp1100j = $(shell echo '$(esp1100i)' | sed 's:{build.zigbee_mode}:$(BUILD_ZIGBEE):g')

# esp1100i = $(shell echo '$(esp1200h)' | sed 's:{build.cdc_on_boot}:$(BUILD_CDC_ON_BOOT):g')
# esp1100i = $(shell echo '$(esp1200h)' | sed 's:{build.cdc_on_boot}:$(BUILD_CDC_ON_BOOT):g')
# esp1100j = $(shell echo '$(esp1200i)' | sed 's:{build.msc_on_boot}:$(BUILD_MSC_ON_BOOT):g')
# esp1100k = $(shell echo '$(esp1200j)' | sed 's:{build.dfu_on_boot}:$(BUILD_DFU_ON_BOOT):g')
# esp1100l = $(shell echo '$(esp1200k)' | sed 's:{build.usb_mode}:$(BUILD_USB_MODE):g')

FLAGS_EXTRA = $(esp1100j)
FLAGS_EXTRA += -DARDUINO_HOST_OS='"linux"'
FLAGS_EXTRA += -DARDUINO_FQBN='"esp32:$(BUILD_CORE):$(BOARD_TAG)"'

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
# $(info === FLAGS_EXTRA $(FLAGS_EXTRA))
# $(error === )

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
# FLAGS_ALL = -DFLAGS_ALL 
FLAGS_ALL += $(OPTIMISATION) $(FLAGS_WARNING) 
# FLAGS_ALL += -D__ets__ -DICACHE_FLASH -U__STRICT_ANSI__ -DLWIP_OPEN_SRC
# FLAGS_ALL += -DESP_PLATFORM -DESP32
# FLAGS_ALL += -DHAVE_CONFIG_H
# FLAGS_ALL += -DMBEDTLS_CONFIG_FILE=\"mbedtls/esp_config.h\"
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
# FLAGS_ALL += -DFLAGS_D 
FLAGS_ALL += $(FLAGS_D)
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))
# FLAGS_ALL += -DFLAGS_EXTRA 
FLAGS_ALL += $(FLAGS_EXTRA)
# FLAGS_ALL += -DFLAGS_USB 
FLAGS_ALL += $(FLAGS_USB) 

FLAGS_ALL += @$(BUILDS_PATH)/build_opt.h
FLAGS_ALL += @$(BUILDS_PATH)/file_opts

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

esp1200a = $(call PARSE_FILE,compiler,cpreprocessor.flags=,$(HARDWARE_PATH)/platform.txt)
esp1200b = $(shell echo '$(esp1200a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1200c = $(shell echo '$(esp1200b)' | sed 's:{build.source.path}:$(CURRENT_DIR):g')
esp1200d = $(shell echo '$(esp1200c)' | sed 's:{build.memory_type}:$(BUILD_MEMORY_TYPE):g')

# $(info === esp1200a $(esp1200a))
# $(info === esp1200b $(esp1200b))
# $(info === esp1200c $(esp1200c))
# $(info === esp1200d $(esp1200d))

FLAGS_ALL += $(esp1200d)

FLAGS_ALL += -I$(SDK_PATH)/$(BUILD_MEMORY_TYPE)/include

FLAGS_ERROR = $(call PARSE_FILE,compiler,common_werror_flag=,$(HARDWARE_PATH)/platform.txt)

# compiler.c.flags="@{compiler.sdk.path}/flags/c_flags" {compiler.warning_flags} {compiler.optimization_flags}
# recipe.c.o.pattern="{compiler.path}{compiler.c.cmd}" {compiler.c.extra_flags} {compiler.c.flags} -DF_CPU={build.f_cpu} -DARDUINO={runtime.ide.version} -DARDUINO_{build.board} -DARDUINO_ARCH_{build.arch} -DARDUINO_BOARD="{build.board}" -DARDUINO_VARIANT="{build.variant}" -DARDUINO_PARTITION_{build.partitions} {build.extra_flags} {compiler.cpreprocessor.flags} {includes} "@{build.opt.path}" "@{file_opts.path}" "{source_file}" -o "{object_file}"

esp1500a = $(call PARSE_FILE,compiler,c.flags=,$(HARDWARE_PATH)/platform.txt)
esp1500b = $(shell echo '$(esp1500a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1500c = $(shell echo '$(esp1500b)' | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
esp1500d = $(shell echo '$(esp1500c)' | sed 's:{compiler.optimization_flags}:$(OPTIMISATION):g')
esp1500e = $(shell echo '$(esp1500d)' | sed 's:{compiler.common_werror_flags}:$(FLAGS_ERROR):g')

# FLAGS_C = -DFLAGS_C 
FLAGS_C += $(call PARSE_FILE,compiler,c.extra_flags=,$(HARDWARE_PATH)/platform.txt)
FLAGS_C += $(esp1500e)

# $(info === esp1500a $(esp1500a))
# $(info === esp1500b $(esp1500b))
# $(info === esp1500c $(esp1500c))
# $(info === esp1500d $(esp1500d))

# compiler.cpp.flags="@{compiler.sdk.path}/flags/cpp_flags" {compiler.warning_flags} {compiler.optimization_flags}
# recipe.cpp.o.pattern="{compiler.path}{compiler.cpp.cmd}" {compiler.cpp.extra_flags} {compiler.cpp.flags} -DF_CPU={build.f_cpu} -DARDUINO={runtime.ide.version} -DARDUINO_{build.board} -DARDUINO_ARCH_{build.arch} -DARDUINO_BOARD="{build.board}" -DARDUINO_VARIANT="{build.variant}" -DARDUINO_PARTITION_{build.partitions} {build.extra_flags} {compiler.cpreprocessor.flags} {includes} "@{build.opt.path}" "@{file_opts.path}" "{source_file}" -o "{object_file}"

esp1600a = $(call PARSE_FILE,compiler,cpp.flags=,$(HARDWARE_PATH)/platform.txt)
esp1600b = $(shell echo '$(esp1600a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1600c = $(shell echo '$(esp1600b)' | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
esp1600d = $(shell echo '$(esp1600c)' | sed 's:{compiler.optimization_flags}:$(OPTIMISATION):g')
esp1600e = $(shell echo '$(esp1600d)' | sed 's:{compiler.common_werror_flags}:$(FLAGS_ERROR):g')

# FLAGS_CPP = -DFLAGS_CPP 
FLAGS_CPP += $(call PARSE_FILE,compiler,cpp.extra_flags=,$(HARDWARE_PATH)/platform.txt)
FLAGS_CPP += $(esp1600e)

# $(info === esp1600a $(esp1600a))
# $(info === esp1600b $(esp1600b))
# $(info === esp1600c $(esp1600c))
# $(info === esp1600d $(esp1600d))

esp1700a = $(call PARSE_FILE,compiler,S.flags=,$(HARDWARE_PATH)/platform.txt)
esp1700b = $(shell echo '$(esp1700a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1700c = $(shell echo '$(esp1700b)' | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
esp1700d = $(shell echo '$(esp1700c)' | sed 's:{compiler.optimization_flags}:$(OPTIMISATION):g')
esp1700e = $(shell echo '$(esp1700d)' | sed 's:{compiler.common_werror_flags}:$(FLAGS_ERROR):g')

# FLAGS_AS = -DFLAGS_AS 
FLAGS_AS += $(call PARSE_FILE,compiler,S.extra_flags=,$(HARDWARE_PATH)/platform.txt)
FLAGS_AS += $(esp1700e)

# $(info === esp1700a $(esp1700a))
# $(info === esp1700b $(esp1700b))
# $(info === esp1700c $(esp1700c))
# $(info === esp1700d $(esp1700d))

# $(info >>> FLAGS_C $(FLAGS_C))
# $(info >>> FLAGS_CPP $(FLAGS_CPP))
# $(info >>> FLAGS_AS $(FLAGS_AS))
# $(info >>> FLAGS_ALL $(FLAGS_ALL))

# $(error STOP)

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
# FLAGS_LD = -DFLAGS_LD 
FLAGS_LD += $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_LD += -L$(SDK_PATH)/lib
FLAGS_LD += -L$(SDK_PATH)/ld
FLAGS_LD += -L$(SDK_PATH)/$(BUILD_MEMORY_TYPE)

# compiler.c.elf.extra_flags="-Wl,--Map={build.path}/{build.project_name}.map" 
# "-L{compiler.sdk.path}/lib" "-L{compiler.sdk.path}/ld" "-L{compiler.sdk.path}/{build.memory_type}" 

# FLAGS_LD = -DFLAGS_LD $(call PARSE_FILE,compiler,elf.extra_flags=,$(HARDWARE_PATH)/platform.txt)
FLAGS_C += -Wl,--wrap=esp_panic_handler

esp1800a = $(call PARSE_FILE,compiler,c.elf.flags=,$(HARDWARE_PATH)/platform.txt)
esp1800b = $(shell echo '$(esp1800a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1800c = $(shell echo '$(esp1800b)' | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
esp1800d = $(shell echo '$(esp1800c)' | sed 's:{compiler.optimization_flags}:$(OPTIMISATION):g')

FLAGS_LD += $(esp1800d)
# recipe.c.combine.pattern="{compiler.path}{compiler.c.elf.cmd}" "-Wl,--Map={build.path}/{build.project_name}.map" "-L{compiler.sdk.path}/lib" "-L{compiler.sdk.path}/ld" {compiler.c.elf.flags} {compiler.c.elf.FLAGS_EXTRA} -Wl,--start-group {build.FLAGS_EXTRA} {object_files} "{archive_file_path}" {compiler.c.elf.libs} {compiler.libraries.FLAGS_LD} -Wl,--end-group -Wl,-EL -o "{build.path}/{build.project_name}.elf"
# -Wl,--gc-sections
FLAGS_LD += $(FLAGS_EXTRA)

# $(info === esp1800a $(esp1800a))
# $(info === esp1800b $(esp1800b))
# $(info === esp1800c $(esp1800c))
# $(info === esp1800d $(esp1800d))

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
# compiler.c.elf.libs
esp1900a = $(call PARSE_FILE,compiler,c.elf.libs=,$(HARDWARE_PATH)/platform.txt)
esp1900b = $(shell echo '$(esp1900a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')

FLAGS_L = $(esp1900b)

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode)

# $(info === FLAGS_ALL $(FLAGS_ALL))
# $(info === FLAGS_CPP $(FLAGS_CPP))
# $(info === FLAGS_CPP_EXTRA $(FLAGS_CPP_EXTRA))
# $(info === FLAGS_C $(FLAGS_C))
# $(info === FLAGS_C_EXTRA $(FLAGS_C_EXTRA))
# $(info === FLAGS_AS $(FLAGS_AS))
# $(info === FLAGS_AS_EXTRA $(FLAGS_AS_EXTRA))

# $(error STOP)

#  Partitions
PARTITIONS_BUILDS_CSV = $(BUILDS_PATH)/partitions.csv
PARTITIONS_VARIANT_CSV = $(VARIANT_PATH)/$(BUILD_PARTITIONS).csv

PARTITIONS_BUILDS_BIN = $(BUILDS_PATH)/partitions.bin

# recipe.hooks.prebuild.1.pattern=/usr/bin/env bash -c "[ ! -f "{build.source.path}"/partitions.csv ] || cp -f "{build.source.path}"/partitions.csv "{build.path}"/partitions.csv"
# COMMAND_BEFORE_COMPILE += echo$(info  1 ; 
COMMAND_BEFORE_COMPILE += [ ! -f $(CURRENT_DIR)/partitions.csv ] || cp -f $(CURRENT_DIR)/partitions.csv $(PARTITIONS_BUILDS_CSV) ;
# recipe.hooks.prebuild.2.pattern=/usr/bin/env bash -c "[ -f "{build.path}"/partitions.csv ] || [ ! -f "{build.variant.path}"/{build.custom_partitions}.csv ] || cp "{build.variant.path}"/{build.custom_partitions}.csv "{build.path}"/partitions.csv"
# COMMAND_BEFORE_COMPILE += echo$(info  2 ; 
COMMAND_BEFORE_COMPILE += [ -f $(PARTITIONS_BUILDS_CSV) ] || [ ! -f $(PARTITIONS_VARIANT_CSV) ] || cp $(PARTITIONS_VARIANT_CSV) $(PARTITIONS_BUILDS_CSV) ;
# recipe.hooks.prebuild.3.pattern=/usr/bin/env bash -c "[ -f "{build.path}"/partitions.csv ] || cp "{runtime.platform.path}"/tools/partitions/{build.partitions}.csv "{build.path}"/partitions.csv"
# COMMAND_BEFORE_COMPILE += echo$(info  3 ; 
COMMAND_BEFORE_COMPILE += [ -f $(PARTITIONS_BUILDS_CSV) ] || cp $(HARDWARE_PATH)/tools/partitions/$(BUILD_PARTITIONS).csv $(PARTITIONS_BUILDS_CSV) ;

BOOTLOADER_BUILDS_BIN = $(BUILDS_PATH)/bootloader.bin
BOOTLOADER_VARIANT_BIN = $(VARIANT_PATH)/$(BUILD_BOOTLOADER).bin

# recipe.hooks.prebuild.4.pattern=/usr/bin/env bash -c "[ -f "{build.source.path}"/bootloader.bin ] && cp -f "{build.source.path}"/bootloader.bin "{build.path}"/{build.project_name}.bootloader.bin || ( [ -f "{build.variant.path}"/{build.custom_bootloader}.bin ] && cp "{build.variant.path}"/{build.custom_bootloader}.bin "{build.path}"/{build.project_name}.bootloader.bin || "{tools.esptool_py.path}"/{tools.esptool_py.cmd} {recipe.hooks.prebuild.4.pattern_args} "{build.path}"/{build.project_name}.bootloader.bin "{compiler.sdk.path}"/bin/bootloader_{build.boot}_{build.boot_freq}.elf )"
# recipe.hooks.prebuild.4.pattern_args=--chip {build.mcu} elf2image --flash_mode {build.flash_mode} --flash_freq {build.img_freq} --flash_size {build.flash_size} -o
# COMMAND_BEFORE_COMPILE += echo$(info  4 ; 
COMMAND_BEFORE_COMPILE += [ -f $(CURRENT_DIR)/bootloader.bin ] && cp -f $(CURRENT_DIR)/bootloader.bin $(BOOTLOADER_BUILDS_BIN) || ( [ -f $(BOOTLOADER_VARIANT_BIN) ] && cp $(BOOTLOADER_VARIANT_BIN) $(BOOTLOADER_BUILDS_BIN) || $(PYTHON_EXEC) $(OTHER_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_IMG_FREQ) --flash_size $(BUILD_FLASH_SIZE) -o $(BOOTLOADER_BUILDS_BIN) $(SDK_PATH)/bin/bootloader_$(BUILD_BOOT)_$(BUILD_BOOT_FREQ).elf ) ; 

OPTION_BUILDS_H = $(BUILDS_PATH)/build_opt.h
PARTITIONS_VARIANT_CSV = $(VARIANT_PATH)/$(BUILD_PARTITIONS).csv

# recipe.hooks.prebuild.5.pattern=/usr/bin/env bash -c "[ ! -f "{build.source.path}"/build_opt.h ] || cp -f "{build.source.path}"/build_opt.h "{build.path}"/build_opt.h"
# COMMAND_BEFORE_COMPILE += echo$(info  5 ; 
COMMAND_BEFORE_COMPILE += [ ! -f $(CURRENT_DIR)/build_opt.h ] || cp -f $(CURRENT_DIR)/build_opt.h $(OPTION_BUILDS_H) ;

# recipe.hooks.prebuild.6.pattern=/usr/bin/env bash -c "[ -f "{build.path}"/build_opt.h ] || : > "{build.path}"/build_opt.h"
# COMMAND_BEFORE_COMPILE += echo$(info  6 ; 
COMMAND_BEFORE_COMPILE += [ -f $(OPTION_BUILDS_H) ] || : > $(OPTION_BUILDS_H) ;

FILE_OPTIONS_BUILDS = $(BUILDS_PATH)/file_opts

# recipe.hooks.prebuild.7.pattern=/usr/bin/env bash -c ": > '{file_opts.path}'"
# COMMAND_BEFORE_COMPILE += echo$(info  7 ; 
COMMAND_BEFORE_COMPILE += : > $(FILE_OPTIONS_BUILDS) ;
# recipe.hooks.prebuild.8.pattern=/usr/bin/env bash -c "cp -f "{compiler.sdk.path}"/sdkconfig "{build.path}"/sdkconfig"
COMMAND_BEFORE_COMPILE += cp -f $(SDK_PATH)/sdkconfig $(BUILDS_PATH)/sdkconfig ;

ifeq ($(FLAG_BUILD_CORE_A),1)
    COMMAND_BEFORE_COMPILE += echo -DARDUINO_CORE_BUILD > $(FILE_OPTIONS_BUILDS) ;
    $(info ESP32 core not available, added -DARDUINO_CORE_BUILD to file_opts)
endif

ifeq ($(BOARD_TAG),nano_nora)
    COMMAND_BEFORE_COMPILE += echo -DARDUINO_CORE_BUILD > $(FILE_OPTIONS_BUILDS) ;
endif

# COMMAND_BEFORE_COMPILE += cp $(HARDWARE_PATH)/tools/partitions/$(BUILD_PARTITIONS).csv $(PARTITIONS_CSV) ;
# COMMAND_BEFORE_COMPILE += touch $(BUILDS_PATH)/build_opt.h ; touch $(BUILDS_PATH)/files_opts.h ; 

MESSAGE_BEFORE = "Partitions and bootloader"

# $(info >>> COMMAND_BEFORE_COMPILE $(COMMAND_BEFORE_COMPILE))
# $(error STOP)

# Target
#
TARGET_HEXBIN = $(TARGET_BIN)
# TARGET_BIN1 = $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).bin1

# Commands
# ----------------------------------
# Link command
#
## COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) $(FLAGS_L) -Wl,--end-group -Wl,-EL
COMMAND_LINK = $(CXX) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) $(TARGET_CORE_A) $(FLAGS_L) -Wl,--end-group -Wl,-EL

# COMMAND_COPY += $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_insights_package.py $(BUILDS_PATH) 
# $(info === BUILD_PARTITIONS $(BUILD_PARTITIONS))
# Option 1: no partitions
# COMMAND_COPY += $(PYTHON_EXEC) $(OTHER_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) -o $@ $<

# COMMAND_POST_COPY = $(OTHER_TOOLS_PATH)/esptool --chip esp32 elf2image --flash_mode $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode) --flash_freq 80m --flash_size $(call PARSE_BOARD,$(BOARD_TAG),build.flash_size) -o $@ $<
COMMAND_COPY = $(PYTHON_EXEC) $(OTHER_TOOLS_PATH)/esptool.py --chip $(MCU) elf2image --flash_mode $(BUILD_FLASH_MODE) --flash_freq $(BUILD_FLASH_FREQ) --flash_size $(BUILD_FLASH_SIZE) --elf-sha256-offset 0xb0 -o $@ $<

# Option 2: with partitions
COMMAND_POST_COPY = $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_esp32part.py -q $(PARTITIONS_BUILDS_CSV) $(PARTITIONS_BUILDS_BIN) ;

# recipe.hooks.objcopy.postobjcopy.1.pattern=/usr/bin/env bash -c "[ ! -d "{build.path}"/libraries/Insights ] || {tools.gen_insights_pkg.cmd} {recipe.hooks.objcopy.postobjcopy.1.pattern_args}"
COMMAND_POST_COPY += [ ! -d $(BUILDS_PATH)/libraries/Insights ] || $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_insights_package.py $(BUILDS_PATH) $(PROJECT_NAME_AS_IDENTIFIER) $(CURRENT_DIR) ;

# recipe.hooks.objcopy.postobjcopy.2.pattern=/usr/bin/env bash -c "[ ! -d "{build.path}"/libraries/ESP_SR ] || [ ! -f "{compiler.sdk.path}"/esp_sr/srmodels.bin ] || cp -f "{compiler.sdk.path}"/esp_sr/srmodels.bin "{build.path}"/srmodels.bin"
COMMAND_POST_COPY += [ ! -d $(BUILDS_PATH)/libraries/ESP_SR ] || [ ! -f $(APPLICATION_PATH)/tools/esp32-arduino-libs/$(ESP32_IDF_RELEASE)/$(BUILD_MCU)/esp_sr/srmodels.bin ] || cp -f $(APPLICATION_PATH)/tools/esp32-arduino-libs/$(ESP32_IDF_RELEASE)/$(BUILD_MCU)/esp_sr/srmodels.bin $(BUILDS_PATH)/srmodels.bin ;

# recipe.hooks.objcopy.postobjcopy.3.pattern_args=--chip {build.mcu} merge_bin -o "{build.path}/{build.project_name}.merged.bin" --fill-flash-size {build.flash_size} --flash_mode keep --flash_freq keep --flash_size keep {build.bootloader_addr} "{build.path}/{build.project_name}.bootloader.bin" 0x8000 "{build.path}/{build.project_name}.partitions.bin" 0xe000 "{runtime.platform.path}/tools/partitions/boot_app0.bin" 0x10000 "{build.path}/{build.project_name}.bin"
COMMAND_POST_COPY += $(PYTHON_EXEC) $(OTHER_TOOLS_PATH)/esptool.py --chip $(MCU) merge_bin -o $(BUILDS_PATH)/merged_bin --fill-flash-size $(BUILD_FLASH_SIZE) --flash_mode keep --flash_freq keep --flash_size keep 0x0 $(BUILDS_PATH)/bootloader.bin 0x8000 $(BUILDS_PATH)/partitions.bin 0xe000 $(HARDWARE_PATH)/tools/partitions/boot_app0.bin 0x10000 $(TARGET_BIN) ;

# $(info TARGET_BIN $(TARGET_BIN))
# $(info COMMAND_COPY $(COMMAND_COPY))
# $(info COMMAND_POST_COPY $(COMMAND_POST_COPY))
# $(info OTHER_TOOLS_PATH $(OTHER_TOOLS_PATH))

# $(error STOP)

# recipe.objcopy.bin.pattern_args=--chip {build.mcu} elf2image --flash_mode "{build.flash_mode}" --flash_freq "{build.img_freq}" --flash_size "{build.flash_size}" --elf-sha256-offset 0xb0 -o "{build.path}/{build.project_name}.bin" "{build.path}/{build.project_name}.elf"

# COMMAND_POST_COPY = $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/esptool.py --chip esp32 elf2image --flash_mode $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode) --flash_freq 80m --flash_size $(call PARSE_BOARD,$(BOARD_TAG),build.flash_size) -o $@ $<
# $(call PARSE_BOARD,$(BOARD_TAG),build.flash_freq) = 80m

# Upload command
#
ifeq ($(UPLOADER),espota)
    COMMAND_UPLOAD = $(UPLOADER_EXEC) -i $(SSH_ADDRESS) -f $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).bin $(UPLOADER_OPTS)
else
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS)

endif # UPLOADER

endif # ESP32_BOARDS

endif # MAKEFILE_NAME
