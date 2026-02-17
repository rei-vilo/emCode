#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Created: 12 Jan 2024 release 14.3.0
#
# Last update: 25 Jul 2025 release 14.7.16
#

# Silicon Labs for Arduino
# ----------------------------------
#
ifeq ($(MAKEFILE_NAME),)

SILABS_INITIAL = $(ARDUINO_PACKAGES_PATH)/SiliconLabs

ifneq ($(wildcard $(SILABS_INITIAL)/hardware/silabs),)
    SILABS_APP = $(SILABS_INITIAL)
    SILABS_PATH = $(SILABS_APP)
    SILABS_BOARDS = $(SILABS_APP)/hardware/silabs/$(SILICONLABS_SILABS_RELEASE)/boards.txt
endif

ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(SILABS_BOARDS)),)
MAKEFILE_NAME = SiliconLabs
RELEASE_CORE = $(SILICONLABS_SILABS_RELEASE)
READY_FOR_EMCODE_NEXT = 1

BOARD_OPTION_TAGS_LIST = $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4) $(BOARD_TAG5) $(BOARD_TAG6) $(BOARD_TAG7) $(BOARD_TAG8) $(BOARD_TAG9) $(BOARD_TAG10)

# Arduino RP2040 specifics
# ----------------------------------
#
PLATFORM := Silicon Labs
BUILD_CORE := SiLabs
SUB_PLATFORM := SiLabs
# For an unknwon reason, calling PARSE_BOARD freezes
VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)

# PLATFORM_TAG is replaced by FLAGS_D with compiler.define
# PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) ARDUINO_SILABS='"$(SILICONLABS_SILABS_RELEASE)"' EMCODE='"$(RELEASE_NOW)"' $(filter __%__ ,$(GCC_PREPROCESSOR_DEFINITIONS))
APPLICATION_PATH := $(ARDUINO_PATH)
PLATFORM_VERSION := $(SILICONLABS_SILABS_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

HARDWARE_PATH = $(SILABS_PATH)/hardware/silabs/$(SILICONLABS_SILABS_RELEASE)
TOOL_CHAIN_PATH = $(SILABS_PATH)/tools/gcc-arm-none-eabi/$(SILICONLABS_GCC_ARM_RELEASE)
OTHER_TOOLS_PATH = $(SILABS_PATH)/tools

# New GCC for ARM tool-suite
APP_TOOLS_PATH := $(TOOL_CHAIN_PATH)/bin

CORE_LIB_PATH := $(HARDWARE_PATH)/cores/gecko
APP_LIB_PATH := $(HARDWARE_PATH)/libraries
BOARDS_TXT := $(HARDWARE_PATH)/boards.txt
BUILD_BOARD = $(call PARSE_BOARD,$(BOARD_TAG),build.board)
BUILD_PLATFORM = $(call PARSE_BOARD,$(BOARD_TAG),build.platform)
BUILD_ARCH = SILABS

# FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name variant.cpp.o)

VARIANT = $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
VARIANT_PATH = $(HARDWARE_PATH)/variants/$(VARIANT)
VARIANT_CPP_SRCS = $(shell find $(VARIANT_PATH) -name \*.cpp)
VARIANT_C_SRCS = $(shell find $(VARIANT_PATH) -name \*.c)
VARIANT_AS1_SRCS = $(shell find $(VARIANT_PATH) -name \*.S)
VARIANT_OBJ_FILES = $(VARIANT_CPP_SRCS:.cpp=.cpp.o) $(VARIANT_C_SRCS:.c=.c.o) $(VARIANT_AS1_SRCS:.S=.S.o)
VARIANT_OBJS = $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(VARIANT_OBJ_FILES))

# Generate main.cpp
# ----------------------------------
#
MAIN_LOCK = false

# Boot-loader
#
BOOTLOADER_FILE = $(HARDWARE_PATH)/bootloaders/$(call PARSE_BOARD,$(BOARD_TAG),bootloader.file)

# Uploader
# UPLOADER defined in .mk
#
UPLOADER_PROTOCOL = $(call PARSE_BOARD,$(BOARD_TAG),upload.protocol)

ifeq ($(UPLOADER),openocd)

# ~/.arduino15/packages/SiliconLabs/tools/openocd/0.12.0-arduino1-static/bin/openocd -d2 -s ~/.arduino15/packages/SiliconLabs/tools/openocd/0.12.0-arduino1-static/share/openocd/scripts/ -f interface/cmsis-dap.cfg -f target/efm32s2_g23.cfg -c "init; reset_config srst_nogate; reset halt; program {/tmp/arduino/sketches/49013B1BA7E8C0ACCF2136108904F353/matter_lightbulb_color.ino.hex}; reset; exit"
    UPLOADER = openocd
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/openocd/$(SILICONLABS_OPENOCD_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/bin/openocd
    UPLOADER_OPTS = $(call PARSE_BOARD,$(BOARD_TAG),upload.transport)
    UPLOADER_OPTS += -d2 -s $(UPLOADER_PATH)/share/openocd/scripts/
    UPLOADER_OPTS += -f $(call PARSE_BOARD,$(BOARD_TAG),debug.server.openocd.scripts.0)
    UPLOADER_OPTS += -f $(call PARSE_BOARD,$(BOARD_TAG),debug.server.openocd.scripts.1)
    UPLOADER_COMMAND = reset; exit
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "init; reset_config srst_nogate; reset halt; program $(TARGET_HEX); $(UPLOADER_COMMAND)"
    COMMAND_BOOTLOADER = $(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "init; reset_config srst_nogate; reset halt; program $(BOOTLOADER_FILE); $(UPLOADER_COMMAND)"

else # commander or jlink

#     ~/.arduino15/packages/SiliconLabs/tools/simplicitycommander/1.14.5/commander  flash ~/.var/app/cc.arduino.IDE2/cache/arduino/sketches/787161434EF5B388F6727A50919C6517/Blink.ino.elf
    UPLOADER_PATH := $(OTHER_TOOLS_PATH)/simplicitycommander/$(SILICONLABS_TOOLS_RELEASE)
    UPLOADER_EXEC = $(UPLOADER_PATH)/commander

    UPLOADER_OPTS = 
    COMMAND_UPLOAD = $(UPLOADER_EXEC) $(UPLOADER_OPTS) flash $(TARGET_ELF)
    COMMAND_BOOTLOADER = $(UPLOADER_EXEC) $(UPLOADER_OPTS) flash $(BOOTLOADER_FILE)

endif # UPLOADER

#  Boot-loader
# ~/.arduino15/packages/SiliconLabs/tools/simplicitycommander/1.14.5/commander  flash ~/.arduino15/packages/SiliconLabs/hardware/silabs/1.0.0/bootloaders/bgm220-explorer-kit-ble-bootloader-apploader.hex

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


# Specific options
#
# unused BOARD= $(call PARSE_BOARD,$(BOARD_TAG),board)

SYSTEM_LIB = $(call PARSE_BOARD,$(BOARD_TAG),build.variant_system_lib)
SYSTEM_PATH = $(VARIANT_PATH)
SYSTEM_OBJS = $(SYSTEM_PATH)/$(SYSTEM_LIB)

# Two locations for application libraries
# No, only HARDWARE_PATH as it contains all the libraries
#
APP_LIB_PATH = $(HARDWARE_PATH)/libraries

ifneq ($(APP_LIBS_LIST),0)

    WORK_0 = $(foreach dir,$(APP_LIBS_LIST),$(shell find $(APP_LIB_PATH)/$(dir) -type d  | egrep -v 'examples' | egrep -v 'extras'))

    APP_LIB_CPP_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.cpp))
    APP_LIB_C_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.c))
    APP_LIB_H_SRC = $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.h))
    APP_LIB_H_SRC += $(foreach dir,$(WORK_0),$(wildcard $(dir)/*.hpp))

    APP_LIB_OBJS = $(patsubst $(HARDWARE_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
    APP_LIB_OBJS += $(patsubst $(HARDWARE_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))

endif # APP_LIBS_LIST

APP_LIBS_LOCK = 1

# One location for core libraries
#
CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)

SILABS_CPP = $(filter-out %main.cpp, $(shell find $(CORE_LIB_PATH) -name \*.cpp))
CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(SILABS_CPP))

CORE_AS1_SRCS = $(wildcard $(CORE_LIB_PATH)/*.S)
CORE_AS2_SRCS = $(wildcard $(CORE_LIB_PATH)/*.s)
CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS1_SRCS)))
CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %s, $(CORE_AS2_SRCS)))

CORE_OBJ_FILES += $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
CORE_OBJS += $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))

CORE_LIBS_LOCK = 1

# MCU options
#
MCU_FLAG_NAME = mcpu
MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
F_CPU = $(call SEARCH_FOR,$(BOARD_TAG),build.f_cpu)

SILABS_GSDK_VERSION = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),gsdk_folder)
ifeq ($(SILABS_GSDK_VERSION),)
    SILABS_GSDK_VERSION = $(call PARSE_BOARD,$(BOARD_TAG),gsdk_folder)
endif # SILABS_GSDK_VERSION

SILABS_MATTER_VERSION = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),matter_sdk_folder)
ifeq ($(SILABS_GSDK_VERSION),)
    SILABS_MATTER_VERSION = $(call PARSE_BOARD,$(BOARD_TAG),matter_sdk_folder)
endif # SILABS_GSDK_VERSION

WORK_1a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.matter_sdk_path)
ifeq ($(WORK_1a),)
    WORK_1a = $(call PARSE_BOARD,$(BOARD_TAG),build.matter_sdk_path)
endif # WORK_1a
WORK_1b = $(shell echo $(WORK_1a) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')
WORK_1c = $(shell echo $(WORK_1b) | sed 's:{matter_sdk_folder}:$(SILABS_MATTER_VERSION):g')

SILABS_MATTER_PATH = $(WORK_1c)

# Include list
WORK_2a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.gsdk_path)
ifeq ($(WORK_2a),)
    WORK_2a = $(call PARSE_BOARD,$(BOARD_TAG),build.gsdk_path)
endif # WORK_2a
WORK_2b = $(shell echo $(WORK_2a) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')
WORK_2c = $(shell echo $(WORK_2b) | sed 's:{gsdk_folder}:$(SILABS_GSDK_VERSION):g')

SILABS_GSDK_PATH = $(WORK_2c)

WORK_3a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.include_list)
ifeq ($(WORK_3a),)
    WORK_3a = $(call PARSE_BOARD,$(BOARD_TAG),build.include_list)
endif # WORK_3a
WORK_3b = $(shell echo $(WORK_3a) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')
WORK_3c = $(shell echo $(WORK_3b) | sed 's:{build.gsdk_path}:$(SILABS_GSDK_PATH):g')
WORK_3d = $(shell echo $(WORK_3c) | sed 's:{build.matter_sdk_path}:$(SILABS_MATTER_PATH):g')

FLAGS_INCLUDE := $(WORK_3d)

FLAGS_INCLUDE += -I$(CORE_LIB_PATH)
FLAGS_INCLUDE += -I$(VARIANT_PATH)
FLAGS_INCLUDE += $(addprefix -I, $(sort $(dir $(APP_LIB_H_SRC) $(BUILD_APP_LIB_H_SRC))))
FLAGS_INCLUDE += -I$(CORE_LIB_PATH)/api/deprecated

# Flags for gcc, g++ and linker
# ----------------------------------
#
# Extra flags
#
FLAGS_MORE = $(call PARSE_BOARD,$(BOARD_TAG),build.board_specific_macros)

FLAGS_FLOAT = $(call PARSE_BOARD,$(BOARD_TAG),build.float_flags)

# Common FLAGS_ALL for gcc, g++, assembler and linker
# {compiler.optimization_flags} {compiler.define} {build.extra_flags} {compiler.silabs.flags}={build.include_list} {includes}
#
WORK_4a = $(call PARSE_FILE,build,compiler.optimization_flags,$(HARDWARE_PATH)/platform.txt)
FLAGS_ALL = $(WORK_4a)

# compiler.define=-DF_CPU={build.f_cpu} -DARDUINO={runtime.ide.version} -DARDUINO_SILABS="{version}" -DARDUINO_BOARD_{build.board} -DARDUINO_ARCH_{build.arch} -DARDUINO_SILABS_{build.platform}
WORK_8a = $(call PARSE_FILE,compiler,define,$(HARDWARE_PATH)/platform.txt)
WORK_8b = $(shell echo $(WORK_8a) | sed 's:{build.f_cpu}:$(F_CPU):g')
WORK_8c = $(shell echo $(WORK_8b) | sed 's:{runtime.ide.version}:$(RELEASE_ARDUINO):g')
WORK_8d = $(shell echo $(WORK_8c) | sed 's:-DARDUINO_SILABS="{version}"::g')
WORK_8e = $(shell echo $(WORK_8d) | sed 's:{build.board}:$(BUILD_BOARD):g')
WORK_8f = $(shell echo $(WORK_8e) | sed 's:{build.arch}:$(BUILD_ARCH):g')
WORK_8g = $(shell echo $(WORK_8f) | sed 's:{build.platform}:$(BUILD_PLATFORM):g')

FLAGS_D = $(WORK_8g)
FLAGS_D += -DARDUINO_SILABS='"$(SILICONLABS_SILABS_RELEASE)"'
FLAGS_D += -DEMCODE='"$(RELEASE_NOW)"'

# FLAGS_D = -DF_CPU=$(F_CPU)
# FLAGS_D += $(addprefix -D, $(PLATFORM_TAG))
# FLAGS_D += -DARDUINO_$(call PARSE_BOARD,$(BOARD_TAG),build.board) -DARDUINO_ARCH_SILABS

FLAGS_ALL += $(FLAGS_D)
FLAGS_ALL += $(OPTIMISATION) $(FLAGS_WARNING)

WORK_5a = $(call PARSE_BOARD,$(BOARD_TAG),build.board_specific_macros)

FLAGS_MORE := $(WORK_5a)

WORK_6a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.extra_flags)
ifeq ($(WORK_6a),)
    WORK_6a = $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags)
endif # WORK_6a
WORK_6b = $(patsubst {build.board_specific_macros},$(FLAGS_MORE),$(WORK_6a))

FLAGS_ALL += $(WORK_6b)

WORK_7a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.precompiled_libs)
ifeq ($(WORK_7a),)
    WORK_7a = $(call PARSE_BOARD,$(BOARD_TAG),build.precompiled_libs)
endif # WORK_7a
WORK_7b = $(shell echo $(WORK_7a) | sed 's:{build.gsdk_path}:$(SILABS_GSDK_PATH):g')
WORK_7c = $(shell echo $(WORK_7b) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')

SILABS_PRE_LIBS = $(WORK_7c)

FLAGS_ALL += $(FLAGS_INCLUDE)

# Specific FLAGS_C for gcc only
# gcc uses FLAGS_ALL and FLAGS_C
#
SILABS_10a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.c_flags)
ifeq ($(SILABS_10a),)
    SILABS_10a = $(call PARSE_BOARD,$(BOARD_TAG),build.c_flags)
endif # SILABS_10a
SILABS_10b = $(shell echo $(SILABS_10a) | sed 's:{build.mcu}:$(MCU):g')
SILABS_10c = $(shell echo $(SILABS_10b) | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
SILABS_10d = $(shell echo $(SILABS_10c) | sed 's:{build.float_flags}:$(FLAGS_FLOAT):g')
SILABS_10e = $(shell echo $(SILABS_10d) | sed 's:{build.gsdk_path}:$(SILABS_GSDK_PATH):g')

FLAGS_C := $(SILABS_10e)
FLAGS_C += -MMD
FLAGS_C += -MP

# Specific FLAGS_CPP for g++ only
# g++ uses FLAGS_ALL and FLAGS_CPP
#
SILABS_20a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.cpp_flags)
ifeq ($(SILABS_20a),)
    SILABS_20a = $(call PARSE_BOARD,$(BOARD_TAG),build.cpp_flags)
endif # SILABS_20a
SILABS_20b = $(shell echo $(SILABS_20a) | sed 's:{build.mcu}:$(MCU):g')
SILABS_20c = $(shell echo $(SILABS_20b) | sed 's:{compiler.warning_flags}:$(FLAGS_WARNING):g')
SILABS_20d = $(shell echo $(SILABS_20c) | sed 's:{build.float_flags}:$(FLAGS_FLOAT):g')

FLAGS_CPP := $(SILABS_20d)

# Specific FLAGS_AS for gcc assembler only
# gcc assembler uses FLAGS_ALL and FLAGS_AS
#
SILABS_30a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.s_flags)
ifeq ($(SILABS_30a),)
    SILABS_30a = $(call PARSE_BOARD,$(BOARD_TAG),build.s_flags)
endif # SILABS_30a
SILABS_30b = $(shell echo $(SILABS_30a) | sed 's:{build.mcu}:$(MCU):g')
FLAGS_AS := $(SILABS_30b)
FLAGS_AS += -x assembler-with-cpp

# Specific FLAGS_LD for linker only
# linker uses FLAGS_ALL and FLAGS_LD
#
SILABS_40a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.ld_flags)
ifeq ($(SILABS_40a),)
    SILABS_40a = $(call PARSE_BOARD,$(BOARD_TAG),build.ld_flags)
endif # SILABS_40a
SILABS_40b = $(shell echo $(SILABS_40a) | sed 's:{build.mcu}:$(MCU):g')
SILABS_40c = $(shell echo $(SILABS_40b) | sed 's:{build.path}/{build.project_name}:$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME):g')
SILABS_40d = $(shell echo $(SILABS_40c) | sed 's:{compiler.mapfile_path}:$(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map:g')

FLAGS_LD := $(SILABS_40d)

# Specific FLAGS_LIBS for linker only
#
FLAGS_LIBS = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.ld_libs)
ifeq ($(FLAGS_LIBS),)
    FLAGS_LIBS = $(call PARSE_BOARD,$(BOARD_TAG),build.ld_libs)
endif # FLAGS_LIBS

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -v -Obinary

# No USB PID VID

# No Serial 1200 reset

ifeq ($(MAKECMDGOALS),debug)
    OPTIMISATION ?= -ggdb -g
else
    OPTIMISATION ?= -Os -g
endif # MAKECMDGOALS

INCLUDE_PATH = $(CORE_LIB_PATH) $(VARIANT_PATH)
INCLUDE_PATH += $(sort $(dir $(APP_LIB_CPP_SRC) $(APP_LIB_C_SRC) $(APP_LIB_H_SRC)))
INCLUDE_PATH += $(sort $(dir $(BUILD_APP_LIB_CPP_SRC) $(BUILD_APP_LIB_C_SRC) $(BUILD_APP_LIB_H_SRC)))

TARGET_HEXBIN = $(TARGET_HEX)

FIRST_O_IN_A = $$(find $(BUILDS_PATH) -name crt0.S.o)

# Commands
# ----------------------------------
# Link command
#
# recipe.c.combine.pattern="{compiler.path}{compiler.c.elf.cmd}" {} {} "-T{build.ldscript}" {compiler.ldflags} {object_files} -Wl,-whole-archive "{build.path}/{archive_file}" {compiler.silabs.precompiled_gsdk} -Wl,-no-whole-archive -Wl,--start-group {compiler.ldlibs} {compiler.silabs.precompiled_libs} -Wl,--end-group -o "{build.path}/{build.project_name}.elf"

SILABS_41a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.precompiled_gsdk)
ifeq ($(SILABS_41a),)
    SILABS_41a = $(call PARSE_BOARD,$(BOARD_TAG),build.precompiled_gsdk)
endif # SILABS_41a
SILABS_41b = $(shell echo $(SILABS_41a) | sed 's:{build.variant.path}:$(VARIANT_PATH):g')

SILABS_PRE_GSDK = $(SILABS_41b)

SILABS_42a = $(call SEARCH_FOR,$(BOARD_OPTION_TAGS_LIST),build.ldscript)
ifeq ($(SILABS_42a),)
    SILABS_42a = $(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)
endif # SILABS_42a
SILABS_42b = $(patsubst {build.variant.path}%,$(VARIANT_PATH)%,$(SILABS_42a))
LDSCRIPT = $(SILABS_42b)

# recipe.c.combine.pattern="{compiler.path}{compiler.c.elf.cmd}" {compiler.c.elf.flags} {compiler.c.elf.extra_flags} "-T{build.ldscript}" {compiler.ldflags} {object_files} -Wl,-whole-archive "{build.path}/{archive_file}" {compiler.silabs.precompiled_gsdk} -Wl,-no-whole-archive -Wl,--start-group {compiler.ldlibs} {compiler.silabs.precompiled_libs} -Wl,--end-group -o "{build.path}/{build.project_name}.elf"
# TARGET_A replaced by OBJS_NON_CORE

COMMAND_LINK = $(CC) -T $(LDSCRIPT) $(FLAGS_LD) -Wl,--no-warn-rwx-segments -Wl,-whole-archive $(OBJS_NON_CORE) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -L$(OBJDIR) $(TARGET_CORE_A) $(SILABS_PRE_GSDK) -Wl,-no-whole-archive -Wl,--start-group $(FLAGS_LIBS) $(SILABS_PRE_LIBS) -Wl,--end-group $(OUT_PREPOSITION)$@

# COMMAND_LINK = $(CC) -T $(LDSCRIPT) $(FLAGS_LD) -Wl,--no-warn-rwx-segments -Wl,-whole-archive $(OBJS_NON_CORE) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) -L$(OBJDIR) $(OBJS_CORE) $(SILABS_PRE_GSDK) -Wl,-no-whole-archive -Wl,--start-group $(FLAGS_LIBS) $(SILABS_PRE_LIBS) -Wl,--end-group $(OUT_PREPOSITION)$@

# Target
#
TARGET_HEXBIN = $(TARGET_HEX)

endif # BOARD_TAG

endif # MAKEFILE_NAME

