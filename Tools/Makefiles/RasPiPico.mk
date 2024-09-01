#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2024
# All rights reserved
#
# Created: 04 Sep 2021 release 11.15.0
#
# Last update: 26 Aug 2024 release 14.5.0
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
endif

# $(info === RP2040_BOARDS $(RP2040_BOARDS))
# $(info === BOARD_TAG $(BOARD_TAG))

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(RP2040_BOARDS)),)
MAKEFILE_NAME = RasPiPico
RELEASE_CORE = $(RP2040_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# # Release check
# # ----------------------------------
# #
# REQUIRED_RP2040_RELEASE = 1.9.8
# ifeq ($(shell if [[ '$(RP2040_RELEASE)' > '$(REQUIRED_RP2040_RELEASE)' ]] || [[ '$(RP2040_RELEASE)' = '$(REQUIRED_RP2040_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
# $(error RP2040 release $(REQUIRED_RP2040_RELEASE) or later required, release $(RP2040_RELEASE) installed)
# endif

BOARD_OPTION_TAGS_LIST = $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4) $(BOARD_TAG5) $(BOARD_TAG6) $(BOARD_TAG7) $(BOARD_TAG8) $(BOARD_TAG9) $(BOARD_TAG10) 
# SEARCH_FOR = $(strip $(foreach t,$(1),$(call PARSE_BOARD,$(t),$(2))))

# Arduino RP2040 specifics
# ----------------------------------
#
PLATFORM := Earle F. Philhower
BUILD_CORE := rp2040
SUB_PLATFORM := rp2040
# For an unknwon reason, calling PARSE_BOARD freezes 
VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
# VARIANT := $(shell grep ^$(BOARD_TAG).build.variant= $(RP2040_BOARDS)  | cut -d = -f 2-)

PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_ARCH_RP2040 EMCODE=$(RELEASE_NOW) $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS)) ARDUINO_VARIANT='"$(VARIANT)"'
# TARGET_RP2040
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := RP2040 $(RP2040_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

# $(info === PLATFORM_TAG $(PLATFORM_TAG))

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
BUILD_TOOLCHAIN = $(call PARSE_BOARD,$(BOARD_TAG),build.toolchain)
BUILD_OPTIONS = $(call PARSE_BOARD,$(BOARD_TAG),build.toolchainopts)
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
endif # KEEP_MAIN

# Uploader openocd or bossac
# UPLOADER defined in .mk
#
TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
# WAS
# recipe.objcopy.uf2.pattern="{runtime.tools.pqt-elf2uf2.path}/elf2uf2" "{build.path}/{build.project_name}.elf" "{build.path}/{build.project_name}.uf2"
# COMMAND_UF2 = $(OTHER_TOOLS_PATH)/pqt-elf2uf2/$(RP2040_TOOLS_RELEASE)/elf2uf2 $(TARGET_ELF) $(TARGET_BIN_CP)
# NOW
# recipe.objcopy.uf2.pattern="{runtime.tools.pqt-picotool.path}/picotool" uf2 convert "{build.path}/{build.project_name}.elf" "{build.path}/{build.project_name}.uf2" {build.uf2family}
COMMAND_UF2 = $(OTHER_TOOLS_PATH)/pqt-picotool/$(RP2040_PICOTOOL_RELEASE)/picotool uf2 convert $(TARGET_ELF) $(TARGET_BIN_CP) $(BUILD_UF2)

ifeq ($(UPLOADER),cp_uf2)
    USB_RESET = stty -F 
    BEFORE_VOLUME_PORT = $(USB_RESET)

    TARGET_BIN_CP = $(BUILDS_PATH)/firmware.uf2
    COMMAND_PRE_UPLOAD = $(OTHER_TOOLS_PATH)/pqt-elf2uf2/$(RP2040_TOOLS_RELEASE)/elf2uf2 $(TARGET_ELF) $(TARGET_BIN_CP)
    # USED_VOLUME_PORT = $(shell ls -d $(BOARD_VOLUME))
    USED_VOLUME_PORT = $(strip $(BOARD_VOLUME))

    # Seeed Xiao does not support plain cp, while Raspberry Pi Pico does.
    # Option 1 --- With https://github.com/microsoft/uf2
    # stty -F $(AVRDUDE_PORT) 1200
    # python uf2conv.py --family RP2040 --convert $(TARGET_ELF) --output $(TARGET_BIN_CP)
    # python uf2conv.py --device $(AVRDUDE_PORT) --family RP2040 --deploy $(TARGET_BIN_CP)
    # 
    # Option 2 --- With .../Arduino15/packages/rp2040/hardware/rp2040/3.2.1/tools
    # stty -F $(AVRDUDE_PORT) 1200
    # python uf2conv.py --family RP2040 --convert $(TARGET_ELF) --output $(TARGET_BIN_CP)
    # python uf2conv.py --device $(AVRDUDE_PORT) --family RP2040 --deploy $(TARGET_BIN_CP)
    # End of options ---
    UPLOADER_PATH = $(HARDWARE_PATH)/tools
    UPLOADER_EXEC = $(UPLOADER_PATH)/uf2conv.py
    UPLOADER_OPTS = --family RP2040 --deploy $(TARGET_BIN_CP)
    # UPLOADER_OPTS += --device $(AVRDUDE_PORT) # Not required
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
# # Option 1 - 1.5.0-a-5007782 is actually arm-none-eabi-cpp (GCC) 10.3.0 but gdb remains 8.2.5
# # /home/reivilo/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/bin/openocd
#     UPLOADER_PATH := $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/bin
#     UPLOADER_EXEC = $(UPLOADER_PATH)/openocd
#     # /home/reivilo/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/share/openocd/scripts
#     UPLOADER_OPTS += -s $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/share/openocd/scripts
# Option 2 - Consistent tool-chain
    UPLOADER_PATH := $(EMCODE_TOOLS)/OpenOCD_RP2040/$(RP2040_OPENOCD_PICOPROBE_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/openocd_picoprobe
    UPLOADER_OPTS += -s $(UPLOADER_PATH)/tcl/
# End
    UPLOADER_OPTS += -f interface/picoprobe.cfg -f target/rp2040.cfg
    UPLOADER_COMMAND = verify reset exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_HEX) $(UPLOADER_COMMAND)"

else ifeq ($(UPLOADER),debugprobe)
    UPLOADER = openocd
# # Option 1 - 1.5.0-a-5007782 is actually arm-none-eabi-cpp (GCC) 10.3.0 but gdb remains 8.2.5
# # /home/reivilo/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/bin/openocd
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/openocd
    # /home/reivilo/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/share/openocd/scripts
    UPLOADER_OPTS += -s $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/share/openocd/scripts
# # Option 2 - Consistent tool-chain
#     UPLOADER_PATH := $(EMCODE_TOOLS)/OpenOCD_RP2040/$(RP2040_OPENOCD_PICOPROBE_RELEASE)
#     UPLOADER_EXEC = $(UPLOADER_PATH)/openocd_picoprobe
#     UPLOADER_OPTS += -s $(UPLOADER_PATH)/tcl/
# End
    UPLOADER_OPTS += -f interface/cmsis-dap.cfg -f target/rp2040.cfg
    UPLOADER_OPTS += -c "adapter speed 5000"
    UPLOADER_COMMAND = verify reset exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_ELF) $(UPLOADER_COMMAND)"

else ifeq ($(UPLOADER),jlink)
    UPLOADER = jlink

    # Prepare the .jlink scripts
    COMMAND_PRE_UPLOAD = printf 'r\nloadfile "$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).hex"\ng\nexit\n' > '$(BUILDS_PATH)/upload.jlink' ;
    COMMAND_PRE_UPLOAD += printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;

# # Option 1 - 1.5.0-a-5007782 is actually arm-none-eabi-cpp (GCC) 10.3.0 but gdb remains 8.2.5
# # /home/reivilo/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/bin/openocd
    UPLOADER_PATH := /usr/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/JLinkExe
    # /home/reivilo/.arduino15/packages/rp2040/tools/pqt-openocd/1.5.0-b-c7bab52/share/openocd/scripts
    # UPLOADER_OPTS += -s $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/share/openocd/scripts
# # Option 2 - Consistent tool-chain
#     UPLOADER_PATH := $(EMCODE_TOOLS)/OpenOCD_RP2040/$(RP2040_OPENOCD_PICOPROBE_RELEASE)
#     UPLOADER_EXEC = $(UPLOADER_PATH)/openocd_picoprobe
#     UPLOADER_OPTS += -s $(UPLOADER_PATH)/tcl/
# End
    UPLOADER_OPTS += -device RP2040_M0_0 -if swd -speed 2000 
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -commanderscript $(BUILDS_PATH)/upload.jlink

else
# tools.openocd.upload.pattern="{path}/{cmd}" {upload.verbose} -s "{path}/share/openocd/scripts/" {bootloader.programmer} {upload.transport} {bootloader.config} -c "telnet_port disabled; init; reset init; halt; adapter speed 10000; program {{build.path}/{build.project_name}.elf}; reset run; shutdown"
    UPLOADER = openocd
    # UPLOADER_PATH := /usr/local
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/pqt-openocd/$(RP2040_OPENOCD_PICOPROBE_RELEASE)/bin
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
# UPLOADER_OPTS = -d3
    UPLOADER_OPTS = $(call PARSE_BOARD,$(BOARD_TAG),upload.transport)
    UPLOADER_OPTS += -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f interface/jlink.cfg -c 'transport select swd' -c 'adapter speed 2000' -f target/rp2040.cfg
    UPLOADER_COMMAND = verify reset exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_HEX) $(UPLOADER_COMMAND)"

#    JLINK_POWER = 1
    JLINK_POWER ?= 0
    ifeq ($(JLINK_POWER),1)
        # COMMAND_POWER = printf "power on\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;
        COMMAND_POWER = printf "power on\ng\nexit\n" > '$(BUILDS_PATH)/power.jlink' ;
        COMMAND_POWER += JLinkExe -device RP2040_M0_0 -if swd -speed 2000 -commanderscript '$(BUILDS_PATH)/power.jlink'
    endif # JLINK_POWER

endif # UPLOADER

# Tool-chain names
#
CC = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-gcc
CXX = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-g++
AR = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-ar
OBJDUMP = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-objdump
OBJCOPY = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-objcopy
SIZE = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-size
NM = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-nm
GDB = $(APP_TOOLS_PATH)/$(BUILD_TOOLCHAIN)-gdb

# Specific AVRDUDE location and options
#
BOARD = $(call PARSE_BOARD,$(BOARD_TAG),board)
LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)

SYSTEM_LIB = $(call PARSE_BOARD,$(BOARD_TAG),build.variant_system_lib)
SYSTEM_PATH = $(VARIANT_PATH)
SYSTEM_OBJS = $(SYSTEM_PATH)/$(SYSTEM_LIB)

# ifeq ($(APP_LIBS_LIST),0)
#     APP_LIBS_LIST = Adafruit_TinyUSB_Arduino
# else
#     APP_LIBS_LIST += Adafruit_TinyUSB_Arduino
# endif

# Two locations for application libraries
# No, only HARDWARE_PATH as it contains all the libraries
#
APP_LIB_PATH = $(HARDWARE_PATH)/libraries

rp2040_00 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
rp2040_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
rp2040_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
rp2040_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
rp2040_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
rp2040_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))
rp2040_00 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/dhcpserver,$(APP_LIBS_LIST)))

APP_LIB_CPP_SRC = $(foreach dir,$(rp2040_00),$(wildcard $(dir)/*.cpp))
APP_LIB_C_SRC = $(foreach dir,$(rp2040_00),$(wildcard $(dir)/*.c))
APP_LIB_H_SRC = $(foreach dir,$(rp2040_00),$(wildcard $(dir)/*.h))
APP_LIB_H_SRC += $(foreach dir,$(rp2040_00),$(wildcard $(dir)/*.hpp))

# Adding Adafruit_TinyUSB_Arduino
ifneq ($(filter %.tinyusb,$(BOARD_OPTION_TAGS_LIST)),)
    APP_LIB_CPP_SRC += $(shell find $(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino -name \*.cpp)
    APP_LIB_C_SRC += $(shell find $(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino -name \*.c)
    APP_LIB_H_SRC += $(shell find $(APP_LIB_PATH)/Adafruit_TinyUSB_Arduino -name \*.h)
endif # tinyusb

APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

# Now, APPLICATION_PATH contains generic libraries and is duplicated
# BUILD_APP_LIB_PATH = $(APPLICATION_PATH)/libraries
# 
# rp2040_10 = $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
# rp2040_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
# rp2040_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
# rp2040_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
# rp2040_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_CORE),$(APP_LIBS_LIST)))
# rp2040_10 += $(foreach dir,$(BUILD_APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_CORE),$(APP_LIBS_LIST)))
# 
# BUILD_APP_LIB_CPP_SRC = $(foreach dir,$(rp2040_10),$(wildcard $(dir)/*.cpp))
# BUILD_APP_LIB_C_SRC = $(foreach dir,$(rp2040_10),$(wildcard $(dir)/*.c))
# BUILD_APP_LIB_H_SRC = $(foreach dir,$(rp2040_10),$(wildcard $(dir)/*.h))
# BUILD_APP_LIB_H_SRC += $(foreach dir,$(rp2040_10),$(wildcard $(dir)/*.hpp))
# 
# BUILD_APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(BUILD_APP_LIB_CPP_SRC))
# BUILD_APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(BUILD_APP_LIB_C_SRC))

APP_LIBS_LOCK = 1

# One location for core libraries
#
CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)

# # rp2040_20 = $(filter-out %main.cpp, $(wildcard $(CORE_LIB_PATH)/*.cpp $(CORE_LIB_PATH)/*/*.cpp $(CORE_LIB_PATH)/*/*/*.cpp $(CORE_LIB_PATH)/*/*/*/*.cpp))
rp2040_20 = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(rp2040_20))

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
BUILD_CHIP = $(call PARSE_BOARD,$(BOARD_TAG),build.chip)
# MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu) deprecated with 4.0.1
# === MCU cortex-m0plus rp2040
MCU = cortex-m0plus
F_CPU = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.f_cpu)

# $(info === MCU $(MCU))

# Arduino Nano 33 BLE USB PID VID
#
# USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),vid.0)
# USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),pid.0)
USB_FLAGS_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.usbvid)
USB_FLAGS_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.usbpid)
USB_FLAGS_POWER = $(call PARSE_BOARD,$(BOARD_TAG),build.usbpwr)
USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
USB_VENDOR := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)

USB_VID = $(shell echo $(USB_FLAGS_VID) | cut -d= -f2)
USB_PID = $(shell echo $(USB_FLAGS_PID) | cut -d= -f2)

# $(info >>> $(USB_VID) $(USB_PID))

rp1000a := $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.usbstack_flags)
rp1000b = $(shell echo $(rp1000a) | sed 's:{runtime.platform.path}:$(HARDWARE_PATH):g')
USB_STACK := $(rp1000b)

ifeq ($(USB_VENDOR),)
    USB_VENDOR = "Arduino"
endif

# USB_FLAGS = -DCFG_TUSB_MCU=OPT_MCU_RP2040 # deprecated with 4.0.1
# USB_FLAGS += -DUSB_VID=$(USB_VID)
# USB_FLAGS += -DUSB_PID=$(USB_PID)
USB_FLAGS += -DUSB_MANUFACTURER='$(USB_VENDOR)'
USB_FLAGS += -DUSB_PRODUCT='$(USB_PRODUCT)'
USB_FLAGS += $(USB_FLAGS_PID) $(USB_FLAGS_VID) $(USB_FLAGS_POWER) $(USB_STACK)
# USB_FLAGS += -DTARGET_RP2040
USB_FLAGS += -DPICO_FLASH_SIZE_BYTES=$(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_total)
USB_FLAGS += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_def.txt

# Define menu.ipstack and menu.usbstack
# WAS Define build.wificc and build.lwipdefs for WiFi
# USB_FLAGS += -DPICO_CYW43_ARCH_THREADSAFE_BACKGROUND=1 -DCYW43_LWIP=1 
# USB_FLAGS += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.lwipdefs)
# NOW
BUILD_WIFI = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.wificc)
ifeq ($(USB_VENDOR),)
    # BUILD_WIFI = -DWIFICC=CYW43_COUNTRY_WORLDWIDE
    BUILD_WIFI = $(call PARSE_FILE,$(BOARD_TAG),build,wificc)
endif

USB_FLAGS += $(FLAGS_W_DEFS)
USB_FLAGS += $(BUILD_WIFI)
USB_FLAGS += -DLWIP_IGMP=1 -DLWIP_CHECKSUM_CTRL_PER_NETIF=1

# Serial 1200 reset
#
USB_TOUCH := $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)
# USB_RESET = python $(UTILITIES_PATH)/reset_1200.py

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
endif

FLAG_EXCEPTION = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flags.exceptions)
FLAG_EXCEPTION += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flags.libstdcpp)
ifeq ($(FLAG_EXCEPTION),)
    FLAG_EXCEPTION := $(call PARSE_FILE,build,flags.exceptions,$(HARDWARE_PATH)/platform.txt)
    FLAG_EXCEPTION += $(call PARSE_FILE,build,flags.libstdcpp,$(HARDWARE_PATH)/platform.txt)
endif

# WAS FLAGS_LWIP lwipdefs, NOW FLAGS_W_DEFS libpicowdefs
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

# $(info === HARDWARE_PATH $(HARDWARE_PATH))
# $(info === BOARD_OPTION_TAGS_LIST $(BOARD_OPTION_TAGS_LIST))
# $(info === FLAG_STACK $(FLAG_STACK))
# $(info === FLAG_EXCEPTION $(FLAG_EXCEPTION))

# Flahs for simplesub
BUILD_FLASH_LENGTH = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.flash_length)
BUILD_EEPROM_START = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.eeprom_start)
BUILD_FS_START = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.fs_start)
BUILD_FS_END = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.fs_end)
BUILD_RAM_LENGTH = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.ram_length)

BUILD_PSRAM_LENGTH = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.psram_length)
ifeq ($(BUILD_PSRAM_LENGTH),)
    BUILD_PSRAM_LENGTH = 0
endif

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
FLAGS_ALL = -Werror=return-type -Wno-psabi
# FLAGS_ALL += $(USB_FLAGS)
FLAGS_ALL += $(OPTIMISATION) $(FLAGS_WARNING)
# FLAGS_ALL += -march=armv6-m -mcpu=cortex-m0plus ~ deprecated with 4.0.1
FLAGS_ALL += $(BUILD_OPTIONS)
# FLAGS_ALL += -$(MCU_FLAG_NAME)=$(MCU) 
# FLAGS_ALL += -mthumb 
FLAGS_ALL += -ffunction-sections -fdata-sections 
# -fno-exceptions
FLAGS_ALL += $(FLAG_EXCEPTION) $(FLAG_STACK) $(FLAG_CMSIS)
FLAGS_ALL += -pipe 

FLAGS_ALL += $(addprefix -D, $(PLATFORM_TAG)) # printf=iprintf
FLAGS_ALL += -DF_CPU=$(F_CPU)
FLAGS_ALL += -DARDUINO_$(BUILD_BOARD)
FLAGS_ALL += -BOARD_NAME='"$(BOARD_NAME)"'

FLAGS_ALL += $(FLAGS_D)
FLAGS_ALL += $(FLAGS_MORE) -MMD

FLAGS_ALL += $(FLAGS_NET)

# $(info === FLAGS_ALL $(FLAGS_ALL))

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
# FLAGS_C = -std=gnu11
FLAGS_C = -c -std=gnu17
FLAGS_C += -iprefix$(HARDWARE_PATH)/
FLAGS_C += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_inc.txt
FLAGS_C += @$(HARDWARE_PATH)/lib/core_inc.txt
FLAGS_C += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
# FLAGS_CPP = -std=gnu++11 -fno-rtti -fno-exceptions -fno-threadsafe-statics
FLAGS_CPP = -c -fno-rtti -std=gnu++17
FLAGS_CPP += -iprefix$(HARDWARE_PATH)/
FLAGS_CPP += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_inc.txt
FLAGS_CPP += @$(HARDWARE_PATH)/lib/core_inc.txt
FLAGS_CPP += $(addprefix -I, $(INCLUDE_PATH))

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
FLAGS_AS = -x assembler-with-cpp

FLAGS_D = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.debug_level)
FLAGS_D += $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.debug_port)

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
# FLAGS_LD = $(OPTIMISATION) $(FLAGS_WARNING)
# FLAGS_LD += -$(MCU_FLAG_NAME)=$(MCU)
# FLAGS_LD += -mthumb -ffunction-sections -fdata-sections -fno-exceptions
# FLAGS_LD += -march=armv6-m -DCFG_TUSB_MCU=OPT_MCU_RP2040 # deprecated with 4.0.1
FLAGS_LD += $(BUILD_OPTIONS)
# FLAGS_LD += $(addprefix -D, $(PLATFORM_TAG)) $(FLAGS_D) # printf=iprintf
FLAGS_LD = -u _printf_float -u _scanf_float
FLAGS_LD += @$(HARDWARE_PATH)/lib/$(BUILD_CHIP)/platform_wrap.txt
FLAGS_LD += @$(HARDWARE_PATH)/lib/core_wrap.txt
FLAGS_LD += -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all
FLAGS_LD += -Wl,--warn-common
FLAGS_LD += -Wl,--undefined=runtime_init_install_ram_vector_table
FLAGS_LD += -Wl,--script=$(BUILDS_PATH)/memmap_default.ld
# --specs=nano.specs
FLAGS_LD += -Wl,-Map,$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map 
FLAGS_LD += -Wl,--no-warn-rwx-segments
# FLAGS_LD += @$(VARIANT_PATH)/FLAGS_LD.txt

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
# Option 2: with USB libraries first then partial archive, WORKS
### COMMAND_ARCHIVE = $(QUIET)$(AR) rcs $(TARGET_A) $(CORE_OBJS) $(BUILD_CORE_OBJS) $(VARIANT_OBJS) $(USER_OBJS)

# Commands
# ----------------------------------
# Link command
#
# FIRST_O_IN_LD = $$(find $(BUILDS_PATH) -name syscalls.c.o)
# FIRST_O_IN_LD = $(shell find . -name syscalls.c.o)

COMMAND_EXTRA_1 = $(OTHER_TOOLS_PATH)/pqt-python3/$(RP2040_PYTHON_RELEASE)/python3 -I $(HARDWARE_PATH)/tools/simplesub.py --input $(HARDWARE_PATH)/lib/$(BUILD_CHIP)/memmap_default.ld --out $(BUILDS_PATH)/memmap_default.ld $(FLAGS_SUB)

# WAS
# {compiler.path}{compiler.S.cmd} {compiler.c.elf.flags} {compiler.c.elf.extra_flags} -c $(HARDWARE_PATH)/boot2/$(call PARSE_BOARD,$(BOARD_TAG),build.boot2).S -I$(HARDWARE_PATH)/pico-sdk/src/rp2040/hardware_regs/include/ -I$(HARDWARE_PATH)/pico-sdk/src/common/pico_binary_info/include -o $(BUILDS_PATH)/boot2.o 
# NOW 
# "{compiler.path}{compiler.S.cmd}" {compiler.c.elf.flags} {compiler.c.elf.extra_flags} -c "{runtime.platform.path}/boot2/{build.chip}/{build.boot2}.S" "-I{runtime.platform.path}/pico-sdk/src/{build.chip}/hardware_regs/include/" "-I{runtime.platform.path}/pico-sdk/src/common/pico_binary_info/include" -o "{build.path}/boot2.o"
COMMAND_EXTRA_2 = $(CC) -c $(FLAGS_ALL) -u _printf_float -u _scanf_float -c $(HARDWARE_PATH)/boot2/$(BUILD_CHIP)/$(call PARSE_BOARD,$(BOARD_TAG),build.boot2).S -I$(HARDWARE_PATH)/pico-sdk/src/$(BUILD_CHIP)/hardware_regs/include/ -I$(HARDWARE_PATH)/pico-sdk/src/common/pico_binary_info/include -o $(BUILDS_PATH)/boot2.o 
# COMMAND_EXTRA_2 = $(CC) -c $(FLAGS_ALL) -u _printf_float -u _scanf_float -c $(HARDWARE_PATH)/boot2/$(call PARSE_BOARD,$(BOARD_TAG),build.boot2).S -I$(HARDWARE_PATH)/pico-sdk/src/$(BUILD_CHIP)/hardware_regs/include/ -I$(HARDWARE_PATH)/pico-sdk/src/common/pico_binary_info/include -o $(BUILDS_PATH)/boot2.o 

COMMAND_EXTRA = $(COMMAND_EXTRA_1) ; $(COMMAND_EXTRA_2)

# $(CXX) -L$(OBJDIR) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) -Wl,--whole-archive $(LD_WHOLE_ARCHIVE) -Wl,--no-whole-archive -Wl,--start-group $(LD_GROUP) -Wl,--end-group
# Option 3: with all files, FAILS
# COMMAND_LINK = $(CXX) -L$(BUILDS_PATH) $(FLAGS_ALL) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group -L$(OBJDIR) $(REMOTE_OBJS) $(BUILDS_PATH)/boot2.o $(HARDWARE_PATH)/lib/libpico.a -lm -lc -lstdc++ -lc -Wl,--end-group

# Option 2: with USB libraries first then partial archive, WORKS
# For Pico W, explicit mention of variant objects
## COMMAND_LINK = $(CXX) -L$(BUILDS_PATH) $(FLAGS_ALL) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group -L$(OBJDIR) $(APP_LIB_OBJS) $(BUILD_APP_LIB_OBJS) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(VARIANT_OBJS) $(USER_ARCHIVES) $(TARGET_CORE_A) $(TARGET_A) $(FLAGS_LIBS) -Wl,--end-group
COMMAND_LINK = $(CXX) -L$(BUILDS_PATH) $(FLAGS_ALL) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(VARIANT_OBJS) $(USER_ARCHIVES) $(TARGET_CORE_A) $(TARGET_A) $(FLAGS_LIBS) -Wl,--end-group
# Option 1: with archive for all files, FAILS
# COMMAND_LINK = $(CXX) -L$(BUILDS_PATH) $(FLAGS_ALL) $(FLAGS_LD) $(OUT_PREPOSITION)$@ -Wl,--start-group -L$(OBJDIR) $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) $(BUILDS_PATH)/boot2.o $(HARDWARE_PATH)/lib/libpico.a -lm -lc -lstdc++ -lc -Wl,--end-group

# COMMAND_UF2 = $(COMMAND_PRE_UPLOAD)

# Target
#
TARGET_HEXBIN = $(TARGET_UF2)
# TARGET_HEXBIN = $(TARGET_BIN)
TARGET_EEP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex

endif # BOARD_TAG

endif # MAKEFILE_NAME

