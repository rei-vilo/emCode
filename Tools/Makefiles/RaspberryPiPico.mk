#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Created: 04 Sep 2021 release 11.15.0
#
# Last update: 25 Sep 2025 release 14.7.23
#

# RP2040 Pico for Arduino
# ----------------------------------
#
ifeq ($(MAKEFILE_NAME),)

ARDUINO_RP2040_INITIAL = $(ARDUINO_PACKAGES_PATH)/rp2040

ifneq ($(wildcard $(ARDUINO_RP2040_INITIAL)/hardware/rp2040),)
    RP2040_APP = $(ARDUINO_RP2040_INITIAL)
    RP2040_PATH = $(RP2040_APP)
    RP2040_BOARDS = $(RP2040_APP)/hardware/rp2040/$(RP2040_RELEASE)/boards.txt
endif # ARDUINO_RP2040_INITIAL

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(RP2040_BOARDS)),)
MAKEFILE_NAME = RaspberryPiPico
RELEASE_CORE = $(RP2040_RELEASE)
READY_FOR_EMCODE_NEXT = 1

BOARD_OPTION_TAGS_LIST = $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4) $(BOARD_TAG5) $(BOARD_TAG6) $(BOARD_TAG7) $(BOARD_TAG8) $(BOARD_TAG9) $(BOARD_TAG10) $(BOARD_TAG11)
BOARD_TAGS_LIST = $(BOARD_TAG) $(BOARD_OPTION_TAGS_LIST)

# Arduino RP2040 specifics
# ----------------------------------
#
PLATFORM := Earle F. Philhower
BUILD_CORE := rp2040
SUB_PLATFORM := rp2040
# For an unknwon reason, calling PARSE_BOARD freezes
VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)

PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_RP2040 EMCODE=$(RELEASE_NOW) $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS)) ARDUINO_VARIANT='"$(VARIANT)"'
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := RP2040 $(RP2040_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(RP2040_PATH)/hardware/rp2040/$(RP2040_RELEASE)
TOOL_CHAIN_PATH = $(RP2040_PATH)/tools/pqt-gcc/$(RP2040_GCC_ARM_RELEASE)
OTHER_TOOLS_PATH = $(RP2040_PATH)/tools

# New GCC for ARM tool-suite
APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin

CORE_LIB_PATH := $(HARDWARE_PATH)/cores/rp2040
APP_LIB_PATH := $(HARDWARE_PATH)/libraries
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt
BUILD_BOARD = $(call PARSE_BOARD,$(BOARD_TAG),build.board)

# New with RP2350
BUILD_TOOLCHAIN = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.toolchain)
BUILD_OPTIONS = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.toolchainopts)
# unused BUILD_PACKAGE $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.toolchainpkg)

BUILD_UF2 = $(call PARSE_BOARD,$(BOARD_TAG),build.uf2family)

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
TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
# recipe.objcopy.uf2.pattern="{runtime.tools.pqt-picotool.path}/picotool" uf2 convert "{build.path}/{build.project_name}.elf" "{build.path}/{build.project_name}.uf2" {build.uf2family}
COMMAND_UF2 = $(OTHER_TOOLS_PATH)/pqt-picotool/$(RP2040_PICOTOOL_RELEASE)/picotool uf2 convert $(TARGET_ELF) $(TARGET_BIN_CP) $(BUILD_UF2)

ifeq ($(UPLOADER),cp_uf2)
    USB_RESET = stty -F
    BEFORE_VOLUME_PORT = $(USB_RESET)

    TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
#     pqt-elf2uf2 is deprecated
#     COMMAND_PRE_UPLOAD = $(OTHER_TOOLS_PATH)/pqt-elf2uf2/$(RP2040_TOOLS_RELEASE)/elf2uf2 $(TARGET_ELF) $(TARGET_BIN_CP)
    USED_VOLUME_PORT = $(strip $(BOARD_VOLUME))

    UPLOADER_PATH = $(HARDWARE_PATH)/tools
    UPLOADER_EXEC = $(UPLOADER_PATH)/uf2conv.py
    UPLOADER_OPTS = --family RP2040 --deploy $(TARGET_BIN_CP)
    COMMAND_UPLOAD = python $(UPLOADER_EXEC) $(UPLOADER_OPTS)

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

else ifeq ($(UPLOADER),picoprobe)
    UPLOADER = openocd
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/openocd
    UPLOADER_OPTS += -s $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/share/openocd/scripts
    UPLOADER_OPTS += -f interface/picoprobe.cfg -f target/$(BUILD_CHIP).cfg
    UPLOADER_COMMAND = verify reset exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_HEX) $(UPLOADER_COMMAND)"

else ifeq ($(UPLOADER),debugprobe)
    UPLOADER = openocd
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/openocd
    UPLOADER_OPTS += -s $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/share/openocd/scripts
    UPLOADER_OPTS += -f interface/cmsis-dap.cfg -f target/$(BUILD_CHIP).cfg
    UPLOADER_OPTS += -c "init; adapter speed 5000;"
    UPLOADER_COMMAND = verify; reset; exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_ELF) $(UPLOADER_COMMAND)"

else ifeq ($(UPLOADER),jlink)

    UPLOADER = jlink

# Prepare the .jlink scripts
    COMMAND_PRE_UPLOAD = printf 'r\nloadfile "$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex"\ng\nexit\n' > '$(BUILDS_PATH)/upload.jlink' ;
    COMMAND_PRE_UPLOAD += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

    UPLOADER_PATH := /usr/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    UPLOADER_OPTS += -device RP2040_M0_0 -if swd -speed 2000
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -commanderscript $(BUILDS_PATH)/upload.jlink

else # UPLOADER

# tools.openocd.upload.pattern="{path}/{cmd}" {upload.verbose} -s "{path}/share/openocd/scripts/" {bootloader.programmer} {upload.transport} {bootloader.config} -c "telnet_port disabled; init; reset init; halt; adapter speed 10000; program {{build.path}/{build.project_name}.elf}; reset run; shutdown"
    UPLOADER = openocd
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    UPLOADER_OPTS = $(call PARSE_BOARD,$(BOARD_TAG),upload.transport)
    UPLOADER_OPTS += -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f interface/jlink.cfg -c 'transport select swd' -c 'adapter speed 2000' -f target/rp2040.cfg
    UPLOADER_COMMAND = verify reset exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_HEX) $(UPLOADER_COMMAND)"

#    JLINK_POWER = 1
    JLINK_POWER ?= 0
    ifeq ($(JLINK_POWER),1)
        COMMAND_POWER = printf "power on\ng\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;
        COMMAND_POWER += JLinkExe -device RP2040_M0_0 -if swd -speed 2000 -commanderscript '$(BUILDS_PATH)/power.jlink'
    endif # JLINK_POWER

endif # UPLOADER

# RAM size depends on options
#
MAX_RAM_SIZE := $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),upload.maximum_data_size)

# Tool-chain names
#
# CCACHE_PATH = ~/Applications/bin/ccache
COMPILER_PREFIX := $(BUILD_TOOLCHAIN)
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
# No, only HARDWARE_PATH as it contains all the libraries
#
APP_LIB_PATH = $(HARDWARE_PATH)/libraries

WORK_0 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))
WORK_0 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/dhcpserver,$(APP_LIBS_LIST)))

APP_LIB_CPP_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.c))
APP_LIB_H_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.hpp))

# Adding Adafruit_TinyUSB_Arduino
ifneq ($(filter %.tinyusb,$(BOARD_OPTION_TAGS_LIST)),)
    APP_LIB_CPP_SRC += $(shell find $(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino -name \*.cpp)
    APP_LIB_C_SRC += $(shell find $(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino -name \*.c)
    APP_LIB_H_SRC += $(shell find $(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino -name \*.h)
endif # tinyusb

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

APP_LIBS_LOCK = 1

#  New 4.7.0
# One location but multiple sub-locations for core libraries
#
# CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)
CORE_C_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.c)

WORK_2 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(WORK_2))

# CORE_AS_SRCS = $(wildcard $(CORE_LIB_PATH)/*.S)
CORE_AS1_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.S)
CORE_AS2_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.s)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS1_SRCS)))
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %s, $(CORE_AS2_SRCS)))

CORE_OBJ_FILES += $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
CORE_OBJS += $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

# MCU options
#
MCU_FLAG_NAME = mcpu
BUILD_CHIP = $(call SEARCH_FOR,$(BOARD_TAGS_LIST),build.chip)

MCU := $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.mcu)
ifeq ($(MCU),)
    MCU := $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
endif # MCU
F_CPU = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.f_cpu)

# USB flags
# At the very beginning of the build commands
#
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

ifeq ($(USB_VENDOR),)
    USB_VENDOR = "Arduino"
endif # USB_VENDOR

# $(info >>> USB_PRODUCT <$(USB_PRODUCT)>)
# $(info >>> USB_VENDOR <$(USB_VENDOR)>)

FLAGS_USB_FIRST += -DUSB_MANUFACTURER='$(USB_VENDOR)'
FLAGS_USB_FIRST += -DUSB_PRODUCT='$(USB_PRODUCT)'

USB_FLAGS_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.usbvid)
USB_FLAGS_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.usbpid)
USB_FLAGS_POWER = $(call PARSE_BOARD,$(BOARD_TAG),build.usbpwr)

USB_VID = $(shell echo $(USB_FLAGS_VID) | cut -d= -f2)
USB_PID = $(shell echo $(USB_FLAGS_PID) | cut -d= -f2)

WORK_3a := $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.usbstack_flags)
WORK_3b = $(shell echo $(WORK_3a) | sed 's:{runtime.platform.path}:$(HARDWARE_PATH):g')
USB_STACK := $(WORK_3b)

FLAGS_USB_FIRST += $(USB_FLAGS_PID) $(USB_FLAGS_VID) $(USB_FLAGS_POWER) $(USB_STACK)

USB_FLAGS += -DPICO_FLASH_SIZE_BYTES=$(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_total)
USB_FLAGS += -DFS_START=$(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.fs_start)
USB_FLAGS += -DFS_END=$(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.fs_end)

USB_FLAGS += @$(HARDWARE_PATH)/lib/platform_def.txt
USB_FLAGS += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_def.txt

# Define menu.ipstack and menu.usbstack
BUILD_WIFI = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.wificc)
ifeq ($(USB_VENDOR),)
    BUILD_WIFI = $(call PARSE_FILE,$(BOARD_TAG),build,wificc)
endif # USB_VENDOR

# Define sdfatdefines
FLAGS_SDFAT_DEFS = $(call PARSE_FILE,build,sdfatdefines,$(HARDWARE_PATH)/platform.txt)
# $(info >>> FLAGS_SDFAT_DEFS $(FLAGS_SDFAT_DEFS))

# USB_FLAGS += $(FLAGS_W_DEFS)
USB_FLAGS += $(FLAGS_SDFAT_DEFS)
USB_FLAGS += $(BUILD_WIFI)
USB_FLAGS += -DLWIP_CHECKSUM_CTRL_PER_NETIF=1

# Serial 1200 reset
#
USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION ?= -ggdb -g
else
    OPTIMISATION ?= -Os -g
endif # MAKECMDGOALS

INCLUDE_PATH = $(CORE_LIB_PATH) $(VARIANT_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))

# Adding Pico library
ifneq ($(filter %.picousb,$(BOARD_OPTION_TAGS_LIST)),)
    INCLUDE_PATH += $(HARDWARE_PATH)/tools/libpico
endif # picousb
INCLUDE_PATH += $(HARDWARE_PATH)/include

rp2000a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
FLAGS_MORE = $(filter-out {build.usb_flags}, $(rp2000a))
FLAGS_MORE += $(call PARSE_BOARD,$(BOARD_TAG),build.float-abi)
FLAGS_MORE += $(call PARSE_BOARD,$(BOARD_TAG),build.fpu)

TARGET_HEXBIN = $(TARGET_UF2)

FLAG_STACK = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flags.stackprotect)
ifeq ($(FLAG_STACK),)
    FLAG_STACK := $(call PARSE_FILE,build,flags.stackprotect,$(HARDWARE_PATH)/platform.txt)
endif # FLAG_STACK

FLAG_EXCEPTION = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flags.exceptions)
FLAG_EXCEPTION += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flags.libstdcpp)
ifeq ($(FLAG_EXCEPTION),)
    FLAG_EXCEPTION := $(call PARSE_FILE,build,flags.exceptions,$(HARDWARE_PATH)/platform.txt)
    FLAG_EXCEPTION += $(call PARSE_FILE,build,flags.libstdcpp,$(HARDWARE_PATH)/platform.txt)
endif # FLAG_EXCEPTION

FLAGS_W_DEFS = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.libpicowdefs)
ifeq ($(FLAGS_W_DEFS),)
    FLAGS_W_DEFS := $(call PARSE_FILE,build,libpicowdefs,$(HARDWARE_PATH)/platform.txt)
endif # FLAGS_W_DEFS

FLAGS_W_LIB = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.libpicow)
ifeq ($(FLAGS_W_LIB),)
    FLAGS_W_LIB := $(call PARSE_FILE,build,libpicow,$(HARDWARE_PATH)/platform.txt)
endif # FLAGS_W_LIB

FLAG_CMSIS := $(call PARSE_FILE,build,flags.cmsis,$(HARDWARE_PATH)/platform.txt)

rp3000a = $(call PARSE_FILE,compiler,netdefines,$(HARDWARE_PATH)/platform.txt)
FLAGS_NET = $(shell echo $(rp3000a) | sed 's:{build.libpicowdefs}:$(FLAGS_W_DEFS):g')

FLAG_ESP_WIFI_TYPE = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.espwifitype)
ifeq ($(FLAG_ESP_WIFI_TYPE),)
    FLAG_ESP_WIFI_TYPE := $(call PARSE_FILE,build,espwifitype,$(HARDWARE_PATH)/platform.txt)
endif # FLAGS_W_LIB

# Flahs for simplesub
BUILD_FLASH_LENGTH = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_length)
BUILD_EEPROM_START = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.eeprom_start)
BUILD_FS_START = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.fs_start)
BUILD_FS_END = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.fs_end)
BUILD_RAM_LENGTH = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.ram_length)

BUILD_PSRAM_LENGTH = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.psram_length)
ifeq ($(BUILD_PSRAM_LENGTH),)
    BUILD_PSRAM_LENGTH = 0
endif # BUILD_PSRAM_LENGTH

FLAGS_SUB  = --sub __FLASH_LENGTH__ $(BUILD_FLASH_LENGTH)
FLAGS_SUB += --sub __EEPROM_START__ $(BUILD_EEPROM_START)
FLAGS_SUB += --sub __FS_START__ $(BUILD_FS_START)
FLAGS_SUB += --sub __FS_END__ $(BUILD_FS_END)
FLAGS_SUB += --sub __RAM_LENGTH__ $(BUILD_RAM_LENGTH)
FLAGS_SUB += --sub __PSRAM_LENGTH__ $(BUILD_PSRAM_LENGTH)

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Common FLAGS_ALL for gcc, g++, assembler and linker
#
FLAGS_ALL = $(FLAGS_USB_FIRST)
FLAGS_ALL += -Werror=return-type -Wno-psabi
FLAGS_ALL += $(OPTIMISATION) $(FLAGS_WARNING)
FLAGS_ALL += $(BUILD_OPTIONS)
FLAGS_ALL += -ffunction-sections -fdata-sections # -fno-exceptions
FLAGS_ALL += $(FLAG_EXCEPTION) $(FLAG_STACK) $(FLAG_CMSIS)
FLAGS_ALL += -pipe

FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) # printf=iprintf
FLAGS_ALL += -DF_CPU=$(F_CPU)
FLAGS_ALL += -DARDUINO_$(BUILD_BOARD)
FLAGS_ALL += -DBOARD_NAME='"$(BUILD_BOARD)"'
FLAGS_ALL += -DARDUINO_$(call PARSE_BOARD,$(BOARD_TAG),build.board)

FLAGS_ALL += $(FLAGS_D)
FLAGS_ALL += $(FLAGS_MORE) -MMD

FLAGS_ALL += $(FLAGS_NET)

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
# FLAGS_C = -std=gnu11
FLAGS_C = -c -std=gnu17
FLAGS_C += -iprefix$(HARDWARE_PATH)/
FLAGS_C += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_inc.txt
FLAGS_C += @$(HARDWARE_PATH)/lib/core_inc.txt
FLAGS_C += $(addprefix -I, $(INCLUDE_PATH))
FLAGS_C += $(FLAG_ESP_WIFI_TYPE)

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
FLAGS_CPP = -c -fno-rtti -std=gnu++17
FLAGS_CPP += -iprefix$(HARDWARE_PATH)/
FLAGS_CPP += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_inc.txt
FLAGS_CPP += @$(HARDWARE_PATH)/lib/core_inc.txt
FLAGS_CPP += $(addprefix -I, $(INCLUDE_PATH))
FLAGS_CPP += $(FLAG_ESP_WIFI_TYPE)

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

FLAGS_D = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.debug_level)
FLAGS_D += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.debug_port)
FLAGS_D += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.os)
FLAGS_D += $(call PARSE_BOARD,$(BOARD_TAG),build.led)

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
rp2200a = $(call PARSE_FILE,compiler,wrap,$(HARDWARE_PATH)/platform.txt)
rp2200b = $(shell echo $(rp2200a) | sed 's:{runtime.platform.path}:$(HARDWARE_PATH):g')
rp2200c = $(shell echo $(rp2200b) | sed 's:{build.chip}:$(BUILD_CHIP):g')
BUILD_WRAP = $(rp2200c)

# rp2100a = $(call PARSE_BOARD,$(BOARD_TAG),compiler.ldflags)
rp2100a = $(call PARSE_FILE,compiler,ldflags,$(HARDWARE_PATH)/platform.txt)
rp2100b = $(shell echo $(rp2100a) | sed 's:{compiler.wrap}:$(BUILD_WRAP):g')

# $(info >>> rp2100a $(rp2100a))
# $(info >>> rp2100b $(rp2100b))

FLAGS_LD = $(rp2100b)
FLAGS_LD += $(BUILD_OPTIONS)
FLAGS_LD += -u _printf_float -u _scanf_float
FLAGS_LD += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_wrap.txt
FLAGS_LD += @$(HARDWARE_PATH)/lib/core_wrap.txt
# FLAGS_LD += -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all
# FLAGS_LD += -Wl,--warn-common
# FLAGS_LD += -Wl,--undefined=runtime_init_install_ram_vector_table
FLAGS_LD += -Wl,--script=$(BUILDS_PATH)/memmap_default.ld
FLAGS_LD += -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map
FLAGS_LD += -Wl,--no-warn-rwx-segments

# Specific FLAGS_LIBS for linker only
#
FLAGS_LIBS = $(BUILDS_PATH)/boot2.o
FLAGS_LIBS += $(HARDWARE_PATH)/lib/$(BUILD_CHIP)/ota.o
FLAGS_LIBS += $(HARDWARE_PATH)/lib/$(BUILD_CHIP)/libbearssl.a
FLAGS_LIBS += $(HARDWARE_PATH)/lib/$(BUILD_CHIP)/libpico.a
FLAGS_LIBS += $(HARDWARE_PATH)/lib/$(BUILD_CHIP)/$(FLAGS_W_LIB)
FLAGS_LIBS += -lm -lc -lstdc++ -lc

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -v -Obinary

# FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name pulse_asm.S.o)

# Commands
# ----------------------------------
# Link command
#
# FIRST_O_IN_LD = $$(find $(BUILDS_PATH) -name syscalls.c.o)
# FIRST_O_IN_LD = $(shell find . -name syscalls.c.o)

COMMAND_EXTRA_1 = $(OTHER_TOOLS_PATH)/pqt-python3/$(RP2040_PYTHON_RELEASE)/python3 -I $(HARDWARE_PATH)/tools/simplesub.py --input $(HARDWARE_PATH)/lib/$(BUILD_CHIP)/memmap_default.ld --out $(BUILDS_PATH)/memmap_default.ld $(FLAGS_SUB)

# "{compiler.path}{compiler.S.cmd}" {compiler.c.elf.flags} {compiler.c.elf.extra_flags} -c "{runtime.platform.path}/boot2/{build.chip}/{build.boot2}.S" "-I{runtime.platform.path}/pico-sdk/src/{build.chip}/hardware_regs/include/" "-I{runtime.platform.path}/pico-sdk/src/common/pico_binary_info/include" -o "{build.path}/boot2.o"
COMMAND_EXTRA_2 = $(CC) -c $(FLAGS_ALL) -u _printf_float -u _scanf_float -c $(HARDWARE_PATH)/boot2/$(BUILD_CHIP)/$(call PARSE_BOARD,$(BOARD_TAG),build.boot2).S -I$(HARDWARE_PATH)/pico-sdk/src/$(BUILD_CHIP)/hardware_regs/include/ -I$(HARDWARE_PATH)/pico-sdk/src/common/pico_binary_info/include -o $(BUILDS_PATH)/boot2.o

COMMAND_EXTRA = $(COMMAND_EXTRA_1) ; $(COMMAND_EXTRA_2)

COMMAND_LINK = $(CXX) -L$(BUILDS_PATH) $(FLAGS_ALL) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(VARIANT_OBJS) $(USER_ARCHIVES) $(TARGET_CORE_A) $(TARGET_A) $(FLAGS_LIBS) -Wl,--end-group

# Target
#
TARGET_HEXBIN = $(TARGET_UF2)
TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex

endif # BOARD_TAG

endif # MAKEFILE_NAME

