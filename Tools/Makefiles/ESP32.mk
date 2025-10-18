#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Last update: 09 Oct 2025 release 14.7.25
#

# On Linux, install pyserial with 
# sudo apt install python-serial
#

ifeq ($(MAKEFILE_NAME),)

ESP32_INITIAL = $(ARDUINO_PACKAGES_PATH)/esp32

ifneq ($(wildcard $(ESP32_INITIAL)),)
    ESP32_APP = $(ESP32_INITIAL)
    ESP32_PATH = $(ESP32_APP)
    ESP32_BOARDS = $(ESP32_INITIAL)/hardware/esp32/$(ESP32_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(ESP32_BOARDS)),)

    MAKEFILE_NAME = ESP32
    RELEASE_CORE = $(ESP32_RELEASE)
    READY_FOR_EMCODE_NEXT = 1

ifeq ($(wildcard $(EMCODE_TOOLS)/Cores/$(SELECTED_BOARD)_$(RELEASE_CORE).a),)
    FLAG_BUILD_CORE_A = 1
else
    FLAG_BUILD_CORE_A = 0
endif

# Parallel build fails against ESP32 starting release 3.2.1
# Using sequential build instead (make).
ifeq ($(MAKECMDGOALS),build)
    MAKECMDGOALS := make
    $(info Changed MAKECMDGOALS to '$(MAKECMDGOALS)') 
endif # MAKECMDGOALS

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
# TOOL_CHAIN_PATH = $(HARDWARE_PATH)/tools/xtensa-esp32-elf

OTHER_TOOLS_PATH = $(APPLICATION_PATH)/tools/esptool_py/$(ESP32_TOOLS_RELEASE)

# Horrendous double-quote required by mDNS library
#
PLATFORM_TAG += ARDUINO_BOARD='"$(BUILD_BOARD)"' ARDUINO_VARIANT='"$(BUILD_VARIANT)"'

ESP_POST_COMPILE = $(APPLICATION_PATH)/tools/esptool.py/$(ESP32_TOOLS_RELEASE)/esptool
BOOTLOADER_ELF = $(HARDWARE_PATH)/bootloaders/eboot/eboot.elf

# Complicated menu system for Arduino 1.5
# Another example of Arduino's quick and dirty job
#
BOARD_OPTION_TAGS_LIST = $(strip $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4) $(BOARD_TAG5) $(BOARD_TAG6) $(BOARD_TAG7) $(BOARD_TAG8) $(BOARD_TAG9) $(BOARD_TAG10))
BOARD_TAGS_LIST = $(BOARD_TAG) $(BOARD_OPTION_TAGS_LIST)

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

PYTHON_EXEC = /usr/bin/python3
BOARD_FILE = $(CURRENT_DIR)/Configurations/$(SELECTED_BOARD).mk

# Variant
# 
VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)

VARIANT_CPP_SRCS = $(wildcard $(VARIANT_PATH)/*.cpp)
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

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
ifeq ($(BUILD_FLASH_FREQ),)
    BUILD_FLASH_FREQ = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_freq)
endif

BUILD_IMG_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.img_freq)
ifeq ($(BUILD_IMG_FREQ),)
    BUILD_IMG_FREQ = $(call PARSE_BOARD,$(BOARD_TAG),build.img_freq)
endif
ifeq ($(BUILD_IMG_FREQ),)
    BUILD_IMG_FREQ := $(BUILD_FLASH_FREQ)
endif

BUILD_FLASH_MODE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_mode)
ifeq ($(BUILD_FLASH_MODE),)
    BUILD_FLASH_MODE = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_mode)
endif
BUILD_FLASH_MODE := dio

BUILD_FLASH_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_freq)
ifeq ($(BUILD_FLASH_FREQ),)
    BUILD_FLASH_FREQ = $(call PARSE_BOARD,$(BOARD_TAG),build.flash_freq)
endif

# Default is provided by platform.txt
BUILD_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.boot)
ifeq ($(BUILD_BOOT),)
    BUILD_BOOT = $(call PARSE_FILE,build,boot=,$(HARDWARE_PATH)/platform.txt)
endif

BUILD_BOOT_FREQ = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.boot_freq)
ifeq ($(BUILD_BOOT_FREQ),)
    BUILD_BOOT_FREQ = $(BUILD_FLASH_FREQ)
endif

# Default is provided by platform.txt
esp1300a = $(call PARSE_BOARD,$(BOARD_TAG),build.memory_type)
ifeq ($(esp1300a),)
    esp1300a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.memory_type)
endif
ifeq ($(esp1300a),)
    esp1300a = $(call PARSE_FILE,build,memory_type,$(HARDWARE_PATH)/platform.txt)
endif
esp1300b = $(shell echo '$(esp1300a)' | sed 's:{build.boot}:$(BUILD_BOOT):g')

esp1300c = $(call PARSE_BOARD,$(BOARD_TAG),build.psram_type)
BUILD_PSRAM_TYPE = $(esp1300c)

esp1300d = $(shell echo '$(esp1300b)' | sed 's:{build.psram_type}:$(BUILD_PSRAM_TYPE):g')

BUILD_MEMORY_TYPE = $(esp1300d)

# Default is provided by platform.txt
esp1400a = $(call PARSE_FILE,build,extra_flags.$(MCU)=,$(HARDWARE_PATH)/platform.txt)

BUILD_CDC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.cdc_on_boot=)
ifeq ($(BUILD_CDC_ON_BOOT),)
    BUILD_CDC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.cdc_on_boot)
endif

BUILD_DFU_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.dfu_on_boot=)
ifeq ($(BUILD_DFU_ON_BOOT),)
    BUILD_DFU_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.dfu_on_boot)
endif

BUILD_MSC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.msc_on_boot=)
ifeq ($(BUILD_MSC_ON_BOOT),)
    BUILD_MSC_ON_BOOT = $(call SEARCH_FOR,$(BOARD_TAG),build.msc_on_boot)
endif

BUILD_USB_MODE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.usb_mode)
ifeq ($(BUILD_USB_MODE),)
    BUILD_USB_MODE = $(call SEARCH_FOR,$(BOARD_TAG),build.usb_mode)
endif

# build.FLAGS_EXTRA.esp32s3=-DARDUINO_USB_MODE={build.usb_mode} -DARDUINO_USB_CDC_ON_BOOT={build.cdc_on_boot} -DARDUINO_USB_MSC_ON_BOOT={build.msc_on_boot} -DARDUINO_USB_DFU_ON_BOOT={build.dfu_on_boot}
esp1400b = $(shell echo '$(esp1400a)' | sed 's:{build.usb_mode}:$(BUILD_USB_MODE):')
esp1400c = $(shell echo '$(esp1400b)' | sed 's:{build.cdc_on_boot}:$(BUILD_CDC_ON_BOOT):')
esp1400d = $(shell echo '$(esp1400c)' | sed 's:{build.msc_on_boot}:$(BUILD_MSC_ON_BOOT):')
esp1400e = $(shell echo '$(esp1400d)' | sed 's:{build.dfu_on_boot}:$(BUILD_DFU_ON_BOOT):')

FLAGS_BUILD_EXTRA = $(esp1400e)

# Take option first, then default
BOOTLOADER_BUILDS_BIN = $(BUILDS_PATH)/bootloader.bin
BOOTLOADER_SOURCE_BIN = $(shell if [ -f $(VARIANT_PATH)/bootloader.bin ] ; then ls $(VARIANT_PATH)/bootloader.bin ; fi)

ifneq ($(BOOTLOADER_SOURCE_BIN),)
    COMMAND_COPY = cp $(BOOTLOADER_SOURCE_BIN) $(BOOTLOADER_BUILDS_BIN) ;
else
#    BOOTLOADER_BUILDS_BIN = $(SDK_PATH)/bin/bootloader_$(BUILD_FLASH_MODE)_$(BUILD_FLASH_FREQ).bin
    BOOTLOADER_SOURCE_ELF = $(SDK_PATH)/bin/bootloader_$(BUILD_FLASH_MODE)_$(BUILD_FLASH_FREQ).elf
    COMMAND_COPY = $(OTHER_TOOLS_PATH)/esptool --chip $(MCU) elf2image --flash-mode $(BUILD_FLASH_MODE) --flash-freq $(BUILD_FLASH_FREQ) --flash-size $(BUILD_FLASH_SIZE) -o $(BOOTLOADER_BUILDS_BIN) $(BOOTLOADER_SOURCE_ELF) ;
endif # BOOTLOADER_SOURCE_BIN
# $(info === BOOTLOADER_BUILDS_BIN $(BOOTLOADER_BUILDS_BIN))

ifeq ($(UPLOADER),espota)
    UPLOADER_PATH = $(HARDWARE_PATH)/tools
    UPLOADER_EXEC = $(PYTHON_EXEC) $(UPLOADER_PATH)/espota.py
    UPLOADER_OPTS = -r

    ifeq ($(SSH_ADDRESS),)
        $(eval SSH_ADDRESS = $(shell grep ^SSH_ADDRESS '$(CURRENT_DIR)/Makefile' | cut -d= -f 2- | sed 's/^ //'))
    endif # SSH_ADDRESS

    ifeq ($(SSH_ADDRESS),)
        SSH_ADDRESS := $(shell zenity --width=240 --entry --title "emCode" --text "Enter IP address" --entry-text "192.168.1.11")
        $(shell sed "s/^# SSH_ADDRESS =.*/SSH_ADDRESS = $(SSH_ADDRESS)/g" -i $(CURRENT_DIR)/Makefile)
        $(shell sed "s/^SSH_ADDRESS = .*/SSH_ADDRESS = $(SSH_ADDRESS)/g" -i $(CURRENT_DIR)/Makefile)
    endif # SSH_ADDRESS

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
    UPLOADER_EXEC = $(OTHER_TOOLS_PATH)/esptool
    UPLOADER_OPTS = --chip $(MCU) --port $(USED_SERIAL_PORT) --baud 921600
    UPLOADER_OPTS += --before default_reset --after hard_reset write_flash -z
    UPLOADER_OPTS += --flash-mode $(BUILD_FLASH_MODE) --flash-freq $(BUILD_FLASH_FREQ) 
    UPLOADER_OPTS += --flash-size $(BUILD_FLASH_SIZE)
    UPLOADER_OPTS += $(call PARSE_BOARD,$(BOARD_TAG),build.bootloader_addr) $(BOOTLOADER_BUILDS_BIN)
    UPLOADER_OPTS += 0x8000 $(PARTITIONS_BUILDS_BIN)
    UPLOADER_OPTS += 0xe000 $(HARDWARE_PATH)/tools/partitions/boot_app0.bin
    UPLOADER_OPTS += 0x10000 $(TARGET_BIN)

endif # UPLOADER

APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin
CORE_LIB_PATH := $(HARDWARE_PATH)/cores/esp32

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

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION = -Os -g3 
    FLAGS_D += -DCORE_DEBUG_LEVEL=5
else
    OPTIMISATION ?= -Os -g 
    FLAGS_D += -DCORE_DEBUG_LEVEL=0
endif

SDK_PATH = $(APPLICATION_PATH)/tools/esp32-arduino-libs/$(ESP32_IDF_RELEASE)/$(BUILD_MCU)

INCLUDE_PATH = $(CORE_LIB_PATH)
INCLUDE_PATH += $(VARIANT_PATH)

LDSCRIPT = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.flash_ld)

# Even more flags
# Final = is required to differentiate esp32 from esp32s2 or esp32c3 
# 
esp1100a = $(call PARSE_FILE,build,extra_flags=,$(HARDWARE_PATH)/platform.txt)
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
ifeq ($(BUILD_DEFINES),)
    BUILD_DEFINES = $(call PARSE_BOARD,$(BOARD_TAG),build.defines)
endif
ifeq ($(BOARD_TAG),nano_nora)
    esp1100m = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.disable_pin_remap)
    BUILD_DEFINES:=#
# nano_nora.build.defines=-DBOARD_HAS_PIN_REMAP {build.disable_pin_remap} -DBOARD_HAS_PSRAM '-DUSB_MANUFACTURER="Arduino"' '-DUSB_PRODUCT="Nano ESP32"'
    FLAGS_USB += -DBOARD_HAS_PIN_REMAP $(esp1100m) -DBOARD_HAS_PSRAM -DUSB_MANUFACTURER='"Arduino"' -DUSB_PRODUCT='"Nano ESP32"'
endif
esp1100h = $(shell echo '$(esp1100g)' | sed 's:{build.defines}:$(BUILD_DEFINES):g')

esp1100i = $(shell echo '$(esp1100h)' | sed 's:{build.extra_flags.{build.mcu}}:$(FLAGS_BUILD_EXTRA):g')

BUILD_ZIGBEE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.zigbee_mode)
ifeq ($(BUILD_DEFINES),)
    BUILD_ZIGBEE = $(call PARSE_BOARD,$(BOARD_TAG),build.zigbee_mode)
    BUILD_ZIGBEE = $(call PARSE_FILE,build,zigbee_mode=,$(HARDWARE_PATH)/platform.txt)
endif

esp1100j = $(shell echo '$(esp1100i)' | sed 's:{build.zigbee_mode}:$(BUILD_ZIGBEE):g')
FLAGS_EXTRA = $(esp1100j)
FLAGS_EXTRA += -DARDUINO_HOST_OS='"linux"'
FLAGS_EXTRA += -DARDUINO_FQBN='"esp32:$(BUILD_CORE):$(BOARD_TAG)"'

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL += $(OPTIMISATION) $(FLAGS_WARNING) 
# Standard IDE includes -fno-exceptions and -fexceptions
# emCode uses -fexceptions only
FLAGS_ALL += -DF_CPU=$(F_CPU)
FLAGS_ALL += -DARDUINO_PARTITION_$(BUILD_PARTITIONS)
FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG) ARDUINO_$(BUILD_BOARD))
FLAGS_ALL += $(FLAGS_D)
FLAGS_ALL += $(addprefix -I, $(INCLUDE_PATH))
FLAGS_ALL += $(FLAGS_EXTRA)
FLAGS_ALL += $(FLAGS_USB) 

FLAGS_ALL += @$(BUILDS_PATH)/build_opt.h
FLAGS_ALL += @$(BUILDS_PATH)/file_opts

esp1200a = $(call PARSE_FILE,compiler,cpreprocessor.flags=,$(HARDWARE_PATH)/platform.txt)
esp1200b = $(shell echo '$(esp1200a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1200c = $(shell echo '$(esp1200b)' | sed 's:{build.source.path}:$(CURRENT_DIR):g')
esp1200d = $(shell echo '$(esp1200c)' | sed 's:{build.memory_type}:$(BUILD_MEMORY_TYPE):g')

FLAGS_ALL += $(esp1200d)

FLAGS_ALL += -I$(SDK_PATH)/$(BUILD_MEMORY_TYPE)/include

FLAGS_ERROR = $(call PARSE_FILE,compiler,common_werror_flag=,$(HARDWARE_PATH)/platform.txt)

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
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

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
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

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
esp1700a = $(call PARSE_FILE,compiler,S.flags=,$(HARDWARE_PATH)/platform.txt)
esp1700b = $(shell echo '$(esp1700a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1700c = $(shell echo '$(esp1700b)' | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
esp1700d = $(shell echo '$(esp1700c)' | sed 's:{compiler.optimization_flags}:$(OPTIMISATION):g')
esp1700e = $(shell echo '$(esp1700d)' | sed 's:{compiler.common_werror_flags}:$(FLAGS_ERROR):g')

# FLAGS_AS = -DFLAGS_AS 
FLAGS_AS += $(call PARSE_FILE,compiler,S.extra_flags=,$(HARDWARE_PATH)/platform.txt)
FLAGS_AS += $(esp1700e)

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
FLAGS_C += -Werror=return-type # -Wl,--wrap=esp_panic_handler

esp1800a = $(call PARSE_FILE,compiler,c.elf.flags=,$(HARDWARE_PATH)/platform.txt)
esp1800b = $(shell echo '$(esp1800a)' | sed 's:{compiler.sdk.path}:$(SDK_PATH):g')
esp1800c = $(shell echo '$(esp1800b)' | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
esp1800d = $(shell echo '$(esp1800c)' | sed 's:{compiler.optimization_flags}:$(OPTIMISATION):g')

FLAGS_LD += $(esp1800d)
# recipe.c.combine.pattern="{compiler.path}{compiler.c.elf.cmd}" "-Wl,--Map={build.path}/{build.project_name}.map" "-L{compiler.sdk.path}/lib" "-L{compiler.sdk.path}/ld" {compiler.c.elf.flags} {compiler.c.elf.FLAGS_EXTRA} -Wl,--start-group {build.FLAGS_EXTRA} {object_files} "{archive_file_path}" {compiler.c.elf.libs} {compiler.libraries.FLAGS_LD} -Wl,--end-group -Wl,-EL -o "{build.path}/{build.project_name}.elf"
FLAGS_LD += $(FLAGS_EXTRA)
FLAGS_LD += -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map

# Specific FLAGS_L for linker only
# linker uses FLAGS_ALL and FLAGS_L
#
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

#  Partitions
#
PARTITIONS_BUILDS_CSV = $(BUILDS_PATH)/partitions.csv
PARTITIONS_VARIANT_CSV = $(VARIANT_PATH)/$(BUILD_PARTITIONS).csv

PARTITIONS_BUILDS_BIN = $(BUILDS_PATH)/partitions.bin

# recipe.hooks.prebuild.1.pattern=/usr/bin/env bash -c "[ ! -f "{build.source.path}"/partitions.csv ] || cp -f "{build.source.path}"/partitions.csv "{build.path}"/partitions.csv"
COMMAND_BEFORE_COMPILE += [ ! -f $(CURRENT_DIR)/partitions.csv ] || cp -f $(CURRENT_DIR)/partitions.csv $(PARTITIONS_BUILDS_CSV) ;
# recipe.hooks.prebuild.2.pattern=/usr/bin/env bash -c "[ -f "{build.path}"/partitions.csv ] || [ ! -f "{build.variant.path}"/{build.custom_partitions}.csv ] || cp "{build.variant.path}"/{build.custom_partitions}.csv "{build.path}"/partitions.csv"
COMMAND_BEFORE_COMPILE += [ -f $(PARTITIONS_BUILDS_CSV) ] || [ ! -f $(PARTITIONS_VARIANT_CSV) ] || cp $(PARTITIONS_VARIANT_CSV) $(PARTITIONS_BUILDS_CSV) ;
# recipe.hooks.prebuild.3.pattern=/usr/bin/env bash -c "[ -f "{build.path}"/partitions.csv ] || cp "{runtime.platform.path}"/tools/partitions/{build.partitions}.csv "{build.path}"/partitions.csv"
COMMAND_BEFORE_COMPILE += [ -f $(PARTITIONS_BUILDS_CSV) ] || cp $(HARDWARE_PATH)/tools/partitions/$(BUILD_PARTITIONS).csv $(PARTITIONS_BUILDS_CSV) ;

BOOTLOADER_BUILDS_BIN = $(BUILDS_PATH)/bootloader.bin
BOOTLOADER_VARIANT_BIN = $(VARIANT_PATH)/$(BUILD_BOOTLOADER).bin

# recipe.hooks.prebuild.4.pattern=/usr/bin/env bash -c "[ -f "{build.source.path}"/bootloader.bin ] && cp -f "{build.source.path}"/bootloader.bin "{build.path}"/{build.project_name}.bootloader.bin || ( [ -f "{build.variant.path}"/{build.custom_bootloader}.bin ] && cp "{build.variant.path}"/{build.custom_bootloader}.bin "{build.path}"/{build.project_name}.bootloader.bin || "{tools.esptool_py.path}"/{tools.esptool_py.cmd} {recipe.hooks.prebuild.4.pattern_args} "{build.path}"/{build.project_name}.bootloader.bin "{compiler.sdk.path}"/bin/bootloader_{build.boot}_{build.boot_freq}.elf )"
# recipe.hooks.prebuild.4.pattern_args=--chip {build.mcu} elf2image --flash-mode {build.flash_mode} --flash-freq {build.img_freq} --flash-size {build.flash_size} -o
COMMAND_BEFORE_COMPILE += [ -f $(CURRENT_DIR)/bootloader.bin ] && cp -f $(CURRENT_DIR)/bootloader.bin $(BOOTLOADER_BUILDS_BIN) || ( [ -f $(BOOTLOADER_VARIANT_BIN) ] && cp $(BOOTLOADER_VARIANT_BIN) $(BOOTLOADER_BUILDS_BIN) || $(OTHER_TOOLS_PATH)/esptool --chip $(MCU) elf2image --flash-mode $(BUILD_FLASH_MODE) --flash-freq $(BUILD_IMG_FREQ) --flash-size $(BUILD_FLASH_SIZE) -o $(BOOTLOADER_BUILDS_BIN) $(SDK_PATH)/bin/bootloader_$(BUILD_BOOT)_$(BUILD_BOOT_FREQ).elf ) ; 

OPTION_BUILDS_H = $(BUILDS_PATH)/build_opt.h
PARTITIONS_VARIANT_CSV = $(VARIANT_PATH)/$(BUILD_PARTITIONS).csv

# recipe.hooks.prebuild.5.pattern=/usr/bin/env bash -c "[ ! -f "{build.source.path}"/build_opt.h ] || cp -f "{build.source.path}"/build_opt.h "{build.path}"/build_opt.h"
COMMAND_BEFORE_COMPILE += [ ! -f $(CURRENT_DIR)/build_opt.h ] || cp -f $(CURRENT_DIR)/build_opt.h $(OPTION_BUILDS_H) ;

# recipe.hooks.prebuild.6.pattern=/usr/bin/env bash -c "[ -f "{build.path}"/build_opt.h ] || : > "{build.path}"/build_opt.h"
COMMAND_BEFORE_COMPILE += [ -f $(OPTION_BUILDS_H) ] || : > $(OPTION_BUILDS_H) ;

FILE_OPTIONS_BUILDS = $(BUILDS_PATH)/file_opts

# recipe.hooks.prebuild.7.pattern=/usr/bin/env bash -c ": > '{file_opts.path}'"
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

MESSAGE_BEFORE = "Partitions and bootloader"

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

# Copy command
#
COMMAND_COPY = $(OTHER_TOOLS_PATH)/esptool --chip $(MCU) elf2image --flash-mode $(BUILD_FLASH_MODE) --flash-freq $(BUILD_FLASH_FREQ) --flash-size $(BUILD_FLASH_SIZE) --elf-sha256-offset 0xb0 -o $@ $<

COMMAND_POST_COPY = $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_esp32part.py -q $(PARTITIONS_BUILDS_CSV) $(PARTITIONS_BUILDS_BIN) ;

# recipe.hooks.objcopy.postobjcopy.1.pattern=/usr/bin/env bash -c "[ ! -d "{build.path}"/libraries/Insights ] || {tools.gen_insights_pkg.cmd} {recipe.hooks.objcopy.postobjcopy.1.pattern_args}"
COMMAND_POST_COPY += [ ! -d $(BUILDS_PATH)/libraries/Insights ] || $(PYTHON_EXEC) $(HARDWARE_PATH)/tools/gen_insights_package.py $(BUILDS_PATH) $(PROJECT_NAME_AS_IDENTIFIER) $(CURRENT_DIR) ;

# recipe.hooks.objcopy.postobjcopy.2.pattern=/usr/bin/env bash -c "[ ! -d "{build.path}"/libraries/ESP_SR ] || [ ! -f "{compiler.sdk.path}"/esp_sr/srmodels.bin ] || cp -f "{compiler.sdk.path}"/esp_sr/srmodels.bin "{build.path}"/srmodels.bin"
COMMAND_POST_COPY += [ ! -d $(BUILDS_PATH)/libraries/ESP_SR ] || [ ! -f $(APPLICATION_PATH)/tools/esp32-arduino-libs/$(ESP32_IDF_RELEASE)/$(BUILD_MCU)/esp_sr/srmodels.bin ] || cp -f $(APPLICATION_PATH)/tools/esp32-arduino-libs/$(ESP32_IDF_RELEASE)/$(BUILD_MCU)/esp_sr/srmodels.bin $(BUILDS_PATH)/srmodels.bin ;

# recipe.hooks.objcopy.postobjcopy.3.pattern_args=--chip {build.mcu} merge_bin -o "{build.path}/{build.project_name}.merged.bin" --fill-flash-size {build.flash_size} --flash-mode keep --flash-freq keep --flash-size keep {build.bootloader_addr} "{build.path}/{build.project_name}.bootloader.bin" 0x8000 "{build.path}/{build.project_name}.partitions.bin" 0xe000 "{runtime.platform.path}/tools/partitions/boot_app0.bin" 0x10000 "{build.path}/{build.project_name}.bin"
COMMAND_POST_COPY += $(OTHER_TOOLS_PATH)/esptool --chip $(MCU) merge-bin -o $(BUILDS_PATH)/merged_bin --pad-to-size $(BUILD_FLASH_SIZE) --flash-mode keep --flash-freq keep --flash-size keep 0x0 $(BUILDS_PATH)/bootloader.bin 0x8000 $(BUILDS_PATH)/partitions.bin 0xe000 $(HARDWARE_PATH)/tools/partitions/boot_app0.bin 0x10000 $(TARGET_BIN) ;

# Upload command
#
ifeq ($(UPLOADER),espota)
    COMMAND_UPLOAD = $(UPLOADER_EXEC) -i $(SSH_ADDRESS) -f $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).bin $(UPLOADER_OPTS)
else
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS)

endif # UPLOADER

endif # ESP32_BOARDS

endif # MAKEFILE_NAME
