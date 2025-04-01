#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2025
# All rights reserved
#
# Last update: 09 Feb 2024 release 14.3.4
#

ifeq ($(MAKEFILE_NAME),)

# TEENSY_PATH = $(TEENSY_APP)
# TEENSY_BOARDS = $(TEENSY_PATH)/hardware/teensy/avr/boards.txt

TEENSY_INITIAL = $(ARDUINO_PACKAGES_PATH)/teensy

ifneq ($(wildcard $(TEENSY_INITIAL)/hardware/avr),)
    TEENSY_APP = $(TEENSY_INITIAL)
    TEENSY_PATH = $(TEENSY_APP)
    TEENSY_BOARDS = $(TEENSY_APP)/hardware/avr/$(TEENSY_RELEASE)/boards.txt
endif

BOARD_CHECK := 0
ifneq ($(call PARSE_FILE,$(BOARD_TAG),name,$(TEENSY_BOARDS)),)
    BOARD_CHECK := 1
endif

ifeq ($(BOARD_CHECK),1)
MAKEFILE_NAME = Teensy
RELEASE_CORE = $(TEENSY_RELEASE)
READY_FOR_EMCODE_NEXT = 1

# Teensy specifics
# ----------------------------------
#
PLATFORM := Teensy
APPLICATION_PATH := $(TEENSY_PATH)
PLATFORM_TAG = ARDUINO=$(RELEASE_ARDUINO) TEENSY_CORE EMCODE=$(RELEASE_NOW) ARDUINO_$(call PARSE_BOARD,$(BOARD_TAG),build.board)

# t001 = $(APPLICATION_PATH)/lib/teensyduino.txt
# t002 = $(APPLICATION_PATH)/lib/version.txt
# MODIFIED_ARDUINO_VERSION =  $(shell if [ -f $(t002) ] ; then cat $(t002) ; fi)
PLATFORM_VERSION := $(TEENSY_RELEASE) for Arduino $(ARDUINO_IDE_RELEASE)

# # Release check
# # ----------------------------------
# #
# ifeq ($(PLATFORM),Teensy)
#     REQUIRED_TEENSY_RELEASE = 1.53
#     TEENSY_RELEASE = $(shell if [ -f $(t001) ] ; then cat $(t001) ; fi)
#     ifeq ($(shell if [[ '$(TEENSY_RELEASE)' > '$(REQUIRED_TEENSY_RELEASE)' ]] || [[ '$(TEENSY_RELEASE)' = '$(REQUIRED_TEENSY_RELEASE)' ]]; then echo 1 ; else echo 0 ; fi ),0)
#         $(error Teensyduino release $(REQUIRED_TEENSY_RELEASE) or later is required, $(TEENSY_RELEASE) installed.)
#     endif
#     PLATFORM_VERSION := $(TEENSY_RELEASE) for Arduino $(MODIFIED_ARDUINO_VERSION)
# endif

# Complicated menu system for Arduino 1.5
#
# BOARD_TAGS_LIST includes all the BOARD_TAGs
# BOARD_OPTION_TAGS_LIST includes the BOARD_TAG options onmy
#
BOARD_OPTION_TAGS_LIST = $(BOARD_TAG1) $(BOARD_TAG2) $(BOARD_TAG3) $(BOARD_TAG4)

# SEARCH_FOR = $(strip $(foreach t,$(1),$(call PARSE_BOARD,$(t),$(2))))

# Automatic Teensy2 or Teensy 3 selection based on build.core
#
# BOARDS_TXT := $(APPLICATION_PATH)/hardware/teensy/avr/boards.txt
BOARDS_TXT := $(TEENSY_BOARDS)
BUILD_SUBCORE = $(call PARSE_BOARD,$(BOARD_TAG),build.core)

FLAGS_D = $(call PARSE_BOARD,$(BOARD_TAG),build.flags.defs)

ifeq ($(BUILD_SUBCORE),teensy)

    include $(MAKEFILE_PATH)/Teensy2.mk

else ifeq ($(BUILD_SUBCORE),teensy3)

    include $(MAKEFILE_PATH)/Teensy3.mk

else ifeq ($(BUILD_SUBCORE),teensy4)

    include $(MAKEFILE_PATH)/Teensy3.mk

else # BUILD_SUBCORE

    $(info ERROR             $(BUILD_SUBCORE) unknown)
    $(info .)
    $(call MESSAGE_GUI_ERROR,$(BUILD_SUBCORE) unknown)
    $(error Stop)

endif # BUILD_SUBCORE

# One single location for Teensyduino application libraries
# $(APPLICATION_PATH)/libraries aren't compatible
#
APP_LIB_PATH := $(APPLICATION_PATH)/hardware/avr/$(TEENSY_RELEASE)/libraries

ifeq ($(APP_LIBS_LIST),0)
#     APP_LIBS_LIST :=
else 

#     a1000 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
#     a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(APP_LIBS_LIST)))
#     a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src,$(APP_LIBS_LIST)))
#     a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(APP_LIBS_LIST)))
#     a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/arch/$(BUILD_SUBCORE),$(APP_LIBS_LIST)))
#     a1000 += $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%/src/$(BUILD_SUBCORE),$(APP_LIBS_LIST)))
    a1000 = $(foreach dir,$(APP_LIB_PATH),$(patsubst %,$(dir)/%,$(APP_LIBS_LIST)))
    a1000 += $(foreach dir,$(APP_LIBS_LIST),$(shell find $(APP_LIB_PATH)/$(dir) -type d  | egrep -v 'examples' | egrep -v 'extras' ))

    APP_LIB_CPP_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.cpp))
    APP_LIB_C_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.c))
    APP_LIB_H_SRC = $(foreach dir,$(a1000),$(wildcard $(dir)/*.h))
    APP_LIB_H_SRC += $(foreach dir,$(a1000),$(wildcard $(dir)/*.hpp))
    APP_LIB_AS1_SRC = $(wildcard $(patsubst %,%/*.s,$(APP_LIBS)))
    APP_LIB_AS2_SRC = $(wildcard $(patsubst %,%/*.S,$(APP_LIBS)))

    APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%.cpp,$(OBJDIR)/%.cpp.o,$(APP_LIB_CPP_SRC))
    APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.c,$(OBJDIR)/%.c.o,$(APP_LIB_C_SRC))
    APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.s,$(OBJDIR)/%.s.o,$(APP_LIB_AS1_SRC))
    APP_LIB_OBJS += $(patsubst $(APPLICATION_PATH)/%.S,$(OBJDIR)/%.S.o,$(APP_LIB_AS2_SRC))

    BUILD_APP_LIBS_LIST = $(subst $(BUILD_APP_LIB_PATH)/, ,$(APP_LIB_CPP_SRC))
endif

# Teensy USB kind, layout, PID and VID
#
ifndef TEENSY_USB
    TEENSY_USB = USB_SERIAL
endif # TEENSY_USB

ifndef TEENSY_LAYOUT
    TEENSY_LAYOUT = LAYOUT_US_ENGLISH
endif # TEENSY_LAYOUT

USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)

ifneq ($(USB_PID),)
ifneq ($(USB_VID),)
    USB_FLAGS = -DUSB_VID=$(USB_VID)
    USB_FLAGS += -DUSB_PID=$(USB_PID)
endif # USB_PID 
endif # USB_VID

ifeq ($(USB_FLAGS),)
    USB_FLAGS = -DUSB_VID=null -DUSB_PID=null
endif # USB_FLAGS

USB_FLAGS += $(addprefix -D,$(TEENSY_USB) $(TEENSY_LAYOUT))

MAX_RAM_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),upload.maximum_ram_size)

# Specific FLAGS_OBJCOPY for objcopy only
# objcopy uses FLAGS_OBJCOPY only
#
FLAGS_OBJCOPY = -R .eeprom -O ihex

# Target
#
TARGET_HEXBIN = $(TARGET_HEX)

# Copy command
#
COMMAND_COPY = $(OBJCOPY) -O ihex -R .eeprom $< $@

# Link command
#
## COMMAND_LINK = $(CC) $(OUT_PREPOSITION)$@ $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_A) $(FLAGS_LD)
# COMMAND_LINK = $(CC) $(OUT_PREPOSITION)$@ $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_CORE_A) $(TARGET_A) $(FLAGS_LD)
# Teensy seems to dislike archives unless using --start-group and --end-group
COMMAND_LINK = $(CC) $(OUT_PREPOSITION)$@ -Wl,--start-group $(OBJS_NON_CORE) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_CORE_A) -Wl,--end-group $(FLAGS_LD)

endif # BOARD_CHECK

endif # MAKEFILE_NAME

