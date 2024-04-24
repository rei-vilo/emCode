#
# emCode
# ----------------------------------
# Embedded computing with make
#
# Copyright © Rei Vilo, 2010-2024
# All rights reserved
#
# Last update: 02 Apr 2024 release 14.3.7
#

# General table of messages
# ----------------------------------
#
# 1- Build Hardware
# 2- Build Application
# 3- Build User
# 4- Build Local
# 5- Link
# 6- Copy
# 7- Archive
# 8- Debug - managed by VSC
# 9-
# 10- Upload
# 11- Serial
#

# Serial port check and selection
# ----------------------------------
#
ifdef PLATFORM
ifneq ($(PLATFORM),mbed)
    include $(MAKEFILE_PATH)/Avrdude.mk
endif # PLATFORM mbed
endif # PLATFORM

# Task message
# 
MESSAGE_TASK := $(shell echo $(MAKECMDGOALS) | sed -r 's/\b(.)/\u\1/g')
# $(info MAKECMDGOALS .$(MAKECMDGOALS).)
# $(info MESSAGE_TASK .$(MESSAGE_TASK).)

# Some utilities manage paths with spaces
#
# UTILITIES_PATH_SPACE := $(CURRENT_DIR_SPACE)/Utilities
CONFIGURATIONS_PATH_SPACE := $(CURRENT_DIR_SPACE)/Configurations
EMCODE_REFERENCE = emCode

# Executables
#
REMOVE = rm
MV = mv -f
CAT = cat
ECHO = echo

# Core archives
# 
TARGET_CORE_A = $(EMCODE_TOOLS)/Cores/$(SELECTED_BOARD)_$(RELEASE_CORE).a

ifeq ($(BOOL_SELECT_BOARD),1)
ifneq ($(READY_FOR_EMCODE_NEXT),1)
    $(error $(MAKEFILE_NAME) not yet ready for emCode Next)
endif # READY_FOR_EMCODE_NEXT
endif # BOOL_SELECT_BOARD

# Clean build folder for target Build
#
ifeq ($(MAKECMDGOALS),build)
ifneq ($(wildcard $(OBJDIR)/*),)
    $(shell $(REMOVE) -rf $(OBJDIR)/*)
endif # OBJDIR
endif # MAKECMDGOALS

$(shell mkdir -p $(BUILDS_PATH))
$(shell echo > $(BUILDS_PATH)/serial.txt)

# Multiple XDS110 management
# ----------------------------------
# Requires lsusb or xdsdfu, and openocd
#
ifeq ($(BOOL_SELECT_SERIAL),1)
ifeq ($(UPLOADER),xds110)

# lsusb -d 0451: 2> /dev/null | rev | cut -d\  -f1 | rev
#   XDS110_USB := $(shell $(UTILITIES_PATH)/lsusb -d 0451: 2> /dev/null | rev | cut -d\  -f1 | rev)
# xdsdfu -e | grep "Serial Num" | rev | cut -d\  -f1 | rev
# Use XDS EmuPack from https://software-dl.ti.com/ccs/esd/documents/xdsdebugprobes/emu_xds_software_package_download.html
# Place xdsdfu under UTILITIES_PATH
  XDS110_USB := $(shell $(UTILITIES_PATH)/xdsdfu -e | grep "Serial Num" | xargs | rev | cut -d\  -f1 | rev)

  ifeq ($(XDS110_SERIAL),)

    XDS110_FIRST = $(firstword $(XDS110_USB))
    XDS110_NUMBER = $(words $(XDS110_USB))

    XDS110_LIST := {"$(shell echo $(XDS110_USB) | sed 's: :", ":g')"}

    ifeq ($(XDS110_NUMBER),0)
        $(error No XDS110 connected)
    else ifneq ($(XDS110_NUMBER),1)
        XDS110_SERIAL := $(shell zenity --width=240 --list --title="emCode" --column="XDS110" $(XDS110_LIST) -text=="Multiple programmers: choose one.")
    else
        XDS110_SERIAL := $(XDS110_FIRST)
    endif # XDS110_NUMBER

    ifeq ($(XDS110_SERIAL),false)
        $(error No XDS110 selected)
    endif # XDS110_SERIAL false

  else

    ifeq ($(filter $(XDS110_SERIAL),$(XDS110_USB)),)
        $(error XDS110 $(XDS110_SERIAL) not found among connected $(XDS110_USB))
    endif # XDS110_USB

  endif # XDS110_SERIAL

    BOARD_PORT := /dev/cu.usbmodem$(XDS110_SERIAL)*

endif # UPLOADER
endif # BOOL_SELECT_SERIAL

ifeq ($(filter %*, $(BOARD_PORT)),)

# Specific serial port defined in main Makefile
# BOARD_PORT = /dev/tty.usbmodem142101
#
    $(shell echo $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

else

# Generic serial port defined in board configuration
# BOARD_PORT = /dev/tty.usbmodem*
#

ifeq ($(AVRDUDE_NO_SERIAL_PORT),1)
#    No serial port

else ifeq ($(UPLOADER),teensy_flash)
#    Teensy uploader in charge
#    $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

else ifeq ($(UPLOADER),lightblue_loader)
#    Lightblue uploader in charge

else
#    General case
    ifneq ($(MAKECMDGOALS),boards)
        ifeq ($(BOOL_SELECT_SERIAL),1)

            ifeq ($(UPLOADER),DSLite)
                $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

#             else ifeq ($(UPLOADER),lightblue_loader_cli)
# #    lightblue CLI uploader in charge
#                 $(eval BOARD_FILE = $(shell grep -rl $(CURRENT_DIR)/Configurations -e '$(BOARD_TAG)$$'))
#                 $(eval BEAN_NAME = $(shell grep ^BEAN_NAME '$(BOARD_FILE)' | cut -d= -f 2- | sed 's/^ //'))
#                 ifeq ($(BEAN_NAME),)
#                     $(info .)
#                     $(info ---- Scanning for LightBlue boards ----)
#                     $(shell bean scan | grep Name | cut -d: -f2 > $(BUILDS_PATH)/serial.txt)
#                     $(eval TEXT = $(shell cat '$(BUILDS_PATH)/serial.txt'))
#                     $(info $(TEXT))
#                     $(info ---- LightBlue boards scanned ----)
#                 else
#                     $(shell echo $(BEAN_NAME) > $(BUILDS_PATH)/serial.txt)
#                 endif

            else ifeq ($(UPLOADER),cp_uf2)
                ifneq ($(BEFORE_VOLUME_PORT),)
                    $(shell "screen -X kill")
                    $(shell stty -F $(AVRDUDE_PORT) 1200)
                    ifneq ($(DELAY_BEFORE_UPLOAD),)
                       $(shell sleep 5)
                    endif
                endif

                    $(info USB_RESET 2 '$(USB_RESET)')
                    $(info DELAY_BEFORE_UPLOAD 2 '$(DELAY_BEFORE_UPLOAD)')
                ifneq ($(USB_RESET),)
                    $(info AVRDUDE_PORT '$(AVRDUDE_PORT)')
                    $(shell stty -F $(AVRDUDE_PORT) 1200)
                    ifneq ($(DELAY_BEFORE_UPLOAD),)
                        $(shell sleep $(DELAY_BEFORE_UPLOAD))
                    endif # DELAY_BEFORE_UPLOAD
                endif # USB_RESET

                USED_VOLUME_PORT = $(shell ls -d $(BOARD_VOLUME))
                ifeq ($(USED_VOLUME_PORT),)
                    $(error Volume not available)
                endif
                $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

            else ifeq ($(UPLOADER),stlink)
                $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

            else ifeq ($(UPLOADER),spark_usb)
#                        $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)
# To be commented for initial scan of serial port

            else ifeq ($(UPLOADER),jlink)

            else ifeq ($(UPLOADER),nrfutil)
                ifeq ($(wildcard $(BOARD_PORT)),)
                    $(error Serial port of kind '$(BOARD_PORT)' not found)
                endif
                $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

            else ifeq ($(UPLOADER),spark_wifi)
#                        $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)
            else ifeq ($(BOARD_PORT),ssh)
                $(shell echo 'ssh' > $(BUILDS_PATH)/serial.txt)
                BACK_ADDRESS = $(shell ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\ -f 2-)

            else ifeq ($(BOARD_PORT),pgm)

            else ifeq ($(UPLOADER),espota)
                $(shell if [ -f $(BOARD_PORT) ] ; then ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt ; fi)

            else ifeq ($(AVRDUDE_PORT),)
                ifneq ($(AVRDUDE_PORT),)
                    $(error Serial port '$(AVRDUDE_PORT)' not available)
                else
                    $(error Serial port of kind '$(BOARD_PORT)' not found)
                endif # AVRDUDE_PORT
            else
                $(shell ls -1 $(BOARD_PORT) > $(BUILDS_PATH)/serial.txt)

            endif # UPLOADER
        endif # BOOL_SELECT_SERIAL
#    else
#        ifneq ($(wildcard $(MAKEFILE_PATH)/Cosa.mk),)
#            include $(MAKEFILE_PATH)/Cosa.mk
#        endif # Cosa.mk
    endif # MAKECMDGOALS boards
endif # AVRDUDE_NO_SERIAL_PORT
endif # BOARD_PORT

ifndef UPLOADER
    UPLOADER = avrdude
endif # UPLOADER

ifndef BOARD_NAME
    BOARD_NAME = $(call PARSE_BOARD,$(BOARD_TAG),name)
endif # BOARD_NAME

# Functions
# ----------------------------------
#

# Function TRACE action target source to ~/Library/Logs/emCode.log
# result = $(shell echo 'action',$(BOARD_TAG),'target','source' >> ~/Library/Logs/emCode.log)
#
# TRACE = $(shell echo $(1)': '$(suffix $(2))' < '$(suffix $(3))'	'$(BOARD_TAG)'	'$(dir $(2))'	'$(notdir $(3)) >> ~/Library/Logs/emCode.log)

# Function SHOW action target source
# result = $(shell echo 'action',$(BOARD_TAG),'target','source')
#
# SHOW = @echo $(1)'\t'$(suffix $(3))$(suffix $(2))' < '$(suffix $(3))'\t'$(BOARD_TAG)'	'$(dir $(2))'	'$(notdir $(3))
# SHOW = @echo $(1)'\t'$(2)
ifneq ($(HIDE_NUMBER),true)
#    SHOW = @printf '%-24s\t%s\r\n' $(1) $(2)
    SHOW = @printf '%-18s%s\r\n' $(1) $(subst $(BUILDS_PATH)/,,$(2))
endif # HIDE_NUMBER

ifeq ($(HIDE_COMMAND),true)
    QUIET = @
endif # HIDE_COMMAND

# Find version of the platform
#
ifneq ($(UNKNOWN_BOARD),1)
ifeq ($(PLATFORM_VERSION),)
ifeq ($(BOOL_SELECT_BOARD),1)
    ifeq ($(PLATFORM),MapleIDE)
        PLATFORM_VERSION := $(shell cat $(APPLICATION_PATH)/lib/build-version.txt)
    else ifeq ($(PLATFORM),mbed)
        PLATFORM_VERSION := $(shell cat $(APPLICATION_PATH)/version.txt)
    else ifeq ($(PLATFORM),IntelEdisonYocto)
        PLATFORM_VERSION := $(shell cat $(APPLICATION_PATH)/version.txt)
    else ifeq ($(PLATFORM),IntelEdisonMCU)
        PLATFORM_VERSION := $(shell cat $(EDISONMCU_PATH)/version.txt)
    else ifeq ($(PLATFORM),BeagleBoneDebian)
        PLATFORM_VERSION := $(shell cat $(APPLICATION_PATH)/version.txt)
    else ifeq ($(PLATFORM),Spark)
        PLATFORM_VERSION := $(shell cat $(SPARK_PATH)/version.txt)
    else
        PLATFORM_VERSION := $(shell cat $(APPLICATION_PATH)/lib/version.txt)
    endif # PLATFORM
endif # BOOL_SELECT_BOARD
endif # PLATFORM_VERSION
endif # UNKNOWN_BOARD

# Clean if new BOARD_TAG
# ----------------------------------
#
BOARD_FILE_TAG := $(BOARD_TAG)
ifeq ($(PLATFORM),Teensy)
ifneq ($(TEENSY_F_CPU),)
    BOARD_FILE_TAG := $(BOARD_FILE_TAG)-$(TEENSY_F_CPU)
endif # TEENSY_F_CPU
endif # PLATFORM

NEW_TAG := $(strip $(OBJDIR)/$(BOARD_FILE_TAG).board)
#
OLD_TAG := $(strip $(wildcard $(OBJDIR)/*.board))
# */

ifneq ($(OLD_TAG),$(NEW_TAG))
    BOOL_CHANGED_BOARD := 1
else
    BOOL_CHANGED_BOARD := 0
endif # OLD_TAG

# Libraries selection is only required is board involved
# ----------------------------------
#
ifeq ($(BOOL_SELECT_BOARD),1)

# CORE libraries
# ----------------------------------
#
ifndef CORE_LIB_PATH
    CORE_LIB_PATH = $(APPLICATION_PATH)/hardware/arduino/cores/arduino
endif # CORE_LIB_PATH

ifndef CORE_LIBS_LIST
    s205 = $(subst .h,,$(subst $(CORE_LIB_PATH)/,,$(wildcard $(CORE_LIB_PATH)/*.h $(CORE_LIB_PATH)/*/*.h)))
    s205 += $(subst .hpp,,$(subst $(CORE_LIB_PATH)/,,$(wildcard $(CORE_LIB_PATH)/*.hpp $(CORE_LIB_PATH)/*/*.hpp)))
    CORE_LIBS_LIST = $(subst $(CORE_LIB_PATH)/,,$(filter-out $(EXCLUDE_LIST),$(s205)))
endif # CORE_LIBS_LIST

# List of sources
# ----------------------------------
#
# CORE sources
#
ifeq ($(CORE_LIBS_LOCK),)
ifdef CORE_LIB_PATH
#    CORE_C_SRCS = $(wildcard $(CORE_LIB_PATH)/*.c $(CORE_LIB_PATH)/*/*.c)
    CORE_C_SRCS = $(shell find $(CORE_LIB_PATH) -name \*.c)
#    s210 = $(filter-out %main.cpp, $(wildcard $(CORE_LIB_PATH)/*.cpp $(CORE_LIB_PATH)/*/*.cpp $(CORE_LIB_PATH)/*/*/*.cpp $(CORE_LIB_PATH)/*/*/*/*.cpp))
    s210 = $(shell find $(CORE_LIB_PATH) -name \*.cpp)

    s210b = $(filter-out %/main.cpp,$(s210))
    CORE_CPP_SRCS = $(filter-out %/$(EXCLUDE_LIST),$(s210b))
    CORE_AS1_SRCS_OBJ = $(patsubst %.S,%.S.o,$(filter %S, $(CORE_AS_SRCS)))
    CORE_AS2_SRCS_OBJ = $(patsubst %.s,%.s.o,$(filter %s, $(CORE_AS_SRCS)))

    CORE_OBJ_FILES += $(CORE_C_SRCS:.c=.c.o) $(CORE_CPP_SRCS:.cpp=.cpp.o) $(CORE_AS1_SRCS_OBJ) $(CORE_AS2_SRCS_OBJ)
#    CORE_OBJS += $(patsubst $(CORE_LIB_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
    CORE_OBJS += $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
#    CORE_OBJS += $(patsubst $(HARDWARE_PATH)/%,$(OBJDIR)/%,$(CORE_OBJ_FILES))
endif # CORE_LIB_PATH
endif # CORE_LIBS_LOCK

# $(info >>> SELECTED_BOARD $(SELECTED_BOARD))
# $(info >>> CORE_OBJ_FILES $(CORE_OBJ_FILES))
# $(info >>> CORE_OBJS $(CORE_OBJS))

# APPlication standard IDE sources
#
ifndef APP_LIB_PATH
    APP_LIB_PATH = $(APPLICATION_PATH)/libraries
endif # APP_LIB_PATH

ifeq ($(APP_LIBS_LIST),)
#    s201 = $(realpath $(sort $(dir $(wildcard $(APP_LIB_PATH)/*/*.h $(APP_LIB_PATH)/*/*/*.h))))
#    s201 += $(realpath $(sort $(dir $(wildcard $(APP_LIB_PATH)/*/*.hpp $(APP_LIB_PATH)/*/*/*.hpp))))
    s201 = $(realpath $(sort $(dir $(shell find $(APP_LIB_PATH) -name \*.h -o -name \*.hpp))))
    APP_LIBS_LIST = $(subst $(APP_LIB_PATH)/,,$(filter-out $(EXCLUDE_LIST),$(s201)))
endif # APP_LIBS_LIST

ifeq ($(APP_LIBS_LOCK),)
    ifndef APP_LIBS
    ifneq ($(strip $(APP_LIBS_LIST)),0)
        s204 = $(patsubst %,$(APP_LIB_PATH)/%,$(APP_LIBS_LIST))
#        APP_LIBS = $(realpath $(sort $(dir $(foreach dir,$(s204),$(wildcard $(dir)/*.h $(dir)/*/*.h $(dir)/*/*/*.h $(dir)/*.hpp $(dir)/*/*.hpp $(dir)/*/*/*.hpp)))))
        APP_LIBS = $(realpath $(sort $(dir $(foreach dir,$(s204),$(shell find $(dir) -name \*.h -o -name \*.hpp)))))
    endif # APP_LIBS_LIST
    endif # APP_LIBS
endif # APP_LIBS_LOCK

ifndef APP_LIB_OBJS
    APP_LIB_C_SRC = $(wildcard $(patsubst %,%/*.c,$(APP_LIBS)))
    APP_LIB_CPP_SRC = $(wildcard $(patsubst %,%/*.cpp,$(APP_LIBS)))
    APP_LIB_AS1_SRC = $(wildcard $(patsubst %,%/*.s,$(APP_LIBS)))
    APP_LIB_AS2_SRC = $(wildcard $(patsubst %,%/*.S,$(APP_LIBS)))
    APP_LIB_OBJ_FILES = $(APP_LIB_C_SRC:.c=.c.o) $(APP_LIB_CPP_SRC:.cpp=.cpp.o) $(APP_LIB_AS1_SRC:.s=.s.o) $(APP_LIB_AS2_SRC:.S=.S.o)
    APP_LIB_OBJS = $(patsubst $(APPLICATION_PATH)/%,$(OBJDIR)/%,$(APP_LIB_OBJ_FILES))
endif # APP_LIB_OBJS

# USER sources
# wildcard required for ~ management
# ?ibraries required for libraries and Libraries
#
ifndef USER_LIB_PATH
    USER_LIB_PATH ?= $(wildcard $(SKETCHBOOK_DIR)/?ibraries)
endif # USER_LIB_PATH

ifndef USER_LIBS_LIST
	s202 = $(realpath $(sort $(dir $(wildcard $(USER_LIB_PATH)/*/*.h))))
    s202 += $(realpath $(sort $(dir $(wildcard $(USER_LIB_PATH)/*/*.hpp))))
#    s202 = $(realpath $(sort $(dir $$(find $(USER_LIB_PATH) -name \*.h))))
#    s202 += $(realpath $(sort $(dir $$(find $(USER_LIB_PATH) -name \*.hpp))))
    USER_LIBS_LIST = $(subst $(USER_LIB_PATH)/,,$(filter-out $(EXCLUDE_LIST),$(s202)))
endif # USER_LIBS_LIST

# From https://arduino.github.io/arduino-cli/0.20/library-specification/
# before 1.50: take top folder and utility sub-fodler
# 1.50 and after: take src and all recursive sub-folders inside
# 
ifneq ($(MAKECMDGOALS),clean)
ifeq ($(USER_LIBS_LOCK),)
ifneq ($(strip $(USER_LIBS_LIST)),0)
# Before, find was too large
#    s203 = $(patsubst %,$(USER_LIB_PATH)/%,$(USER_LIBS_LIST))
#    EXCLUDE_LIST_GREP = $(shell echo $(strip $(EXCLUDE_PATHS)) | sed "s/ /|/g" )
#    USER_LIBS := $(sort $(foreach dir,$(s203),$(shell find $(dir) -type d | egrep -v '$(EXCLUDE_LIST_GREP)' )))

# Horrible mess caused by non-compliant libraries
# 1. Same procedure as for application libraries
    s203 = $(foreach dir,$(USER_LIB_PATH),$(patsubst %,$(dir)/%,$(USER_LIBS_LIST)))
    s203 += $(foreach dir,$(USER_LIB_PATH),$(patsubst %,$(dir)/%/utility,$(USER_LIBS_LIST)))
    s203 += $(foreach dir,$(USER_LIB_PATH),$(patsubst %,$(dir)/%/src,$(USER_LIBS_LIST)))

# 2. But parse all sub-folders below src for compliant libraries
    s203a = $(foreach dir,$(USER_LIB_PATH),$(patsubst %,$(dir)/%/src,$(USER_LIBS_LIST)))
    s203b := $(foreach dir,$(s203a),$(shell if [ -d $(dir) ] ; then find $(dir) -type d ; fi))
    s203 += $(s203b)

    s203 += $(foreach dir,$(USER_LIB_PATH),$(patsubst %,$(dir)/%/src/utility,$(USER_LIBS_LIST)))

    # s203c = $(addsuffix /,$(s203))
    # USER_LIBS := $(filter-out $(EXCLUDE_LIST),$(s203c))

    EXCLUDE_LIST_GREP = $(shell echo $(strip $(EXCLUDE_PATHS)) | sed "s/ /|/g" )
    USER_LIBS := $(sort $(shell echo $(s203) | egrep -v '$$(EXCLUDE_LIST_GREP)' ))

    USER_LIB_CPP_SRC = $(foreach dir,$(USER_LIBS),$(wildcard $(dir)/*.cpp))
    USER_LIB_C_SRC = $(foreach dir,$(USER_LIBS),$(wildcard $(dir)/*.c))
    USER_LIB_H_SRC = $(foreach dir,$(USER_LIBS),$(wildcard $(dir)/*.h))
    USER_LIB_H_SRC += $(foreach dir,$(USER_LIBS),$(wildcard $(dir)/*.hpp))

#    USER_LIB_CPP_SRC = $(wildcard $(patsubst %,%/*.cpp,$(USER_LIBS)))
#    USER_LIB_C_SRC = $(wildcard $(patsubst %,%/*.c,$(USER_LIBS)))
#    USER_LIB_H_SRC = $(wildcard $(patsubst %,%/*.h,$(USER_LIBS)))

    RAW_USER_OBJS = $(patsubst $(USER_LIB_PATH)/%.cpp,$(OBJDIR)/user/%.cpp.o,$(USER_LIB_CPP_SRC))
    RAW_USER_OBJS += $(patsubst $(USER_LIB_PATH)/%.c,$(OBJDIR)/user/%.c.o,$(USER_LIB_C_SRC))
endif # USER_LIBS_LIST
endif # USER_LIBS_LOCK
endif # MAKECMDGOALS

# USER archives
# List user libraries with archives
USER_ARCHIVES = $(foreach dir,$(USER_LIBS_LIST),$(wildcard $(USER_LIB_PATH)/$(dir)/src/$(MCU)/*.a))
#  Get the paths of user libraries with archives
WORK1 = $(patsubst %/src/$(MCU)/,%,$(foreach dir,$(USER_ARCHIVES),$(dir $(dir))))
USER_LIBS_LIST_TOP = $(subst $(USER_LIB_PATH)/,,$(WORK1))
# Generate the filter with ending %
ARCHIVE_USER_OBJS = $(foreach lib,$(USER_LIBS_LIST_TOP),$(OBJDIR)/user/$(lib)/%)
#  Filter
USER_OBJS = $(filter-out $(ARCHIVE_USER_OBJS),$(RAW_USER_OBJS))

INFO_USER_ARCHIVES_LIST = $(USER_LIBS_LIST_TOP)
INFO_USER_UNARCHIVES_LIST = $(filter-out $(INFO_USER_ARCHIVES_LIST),$(USER_LIBS_LIST))

# LOCAL sources
#
LOCAL_LIB_PATH = .
# LOCAL_LIB_PATH = $(CURRENT_DIR)

# ifneq ($(strip $(LOCAL_LIBS_LIST)),0)
# 
#     s220a := $(shell find $(LOCAL_LIB_PATH) -maxdepth 1 -type d)
#     s220b := $(subst ./,,$(s220a))
#     s220c := $(filter-out $(s220b),$(LOCAL_LIBS_LIST))
#     $(info s220a $(s220a))
#     $(info s220b $(s220b))
#     $(info s220c $(s220c))
# 
# ifneq ($(strip $(s220c)),)
#     $(error Missing local libraries $(s220c))
# endif
# 
#     $(info .)
#     $(error STOP)
# endif

ifndef LOCAL_LIBS_LIST
    s206 = $(dir $(shell find $(LOCAL_LIB_PATH) -name \*.h -o -name \*.hpp))
    s212 = $(subst $(LOCAL_LIB_PATH)/,,$(filter-out $(EXCLUDE_LIST)/,$(sort $(s206))))
    LOCAL_LIBS_LIST = $(shell echo $(s212)' ' | sed 's://:/:g' | sed 's:/ : :g')
    s213 = $(s212)
endif # LOCAL_LIBS_LIST

ifneq ($(strip $(LOCAL_LIBS_LIST)),0)
    s207 = $(patsubst %,$(LOCAL_LIB_PATH)/%,$(LOCAL_LIBS_LIST))
    # s208 = $(sort $(dir $(foreach dir,$(s207),$(shell find $(dir) -name \*.h -o -name \*.hpp))))
    s208 = $(dir $(foreach dir,$(s207),$(shell find $(dir) -name \*.h -o -name \*.hpp)))
    # s213 = $(subst $(LOCAL_LIB_PATH)/,,$(filter-out $(EXCLUDE_LIST)/,$(sort $(s207))))
    s213 = $(subst $(LOCAL_LIB_PATH)/,,$(filter-out $(EXCLUDE_LIST)/,$(s207)))
    LOCAL_LIBS = $(shell echo $(s208)' ' | sed 's://:/:g' | sed 's:/ : :g')
endif # LOCAL_LIBS_LIST

# LOCAL_LIBS_LIST_TOP = $(s212)
LOCAL_LIBS_LIST_TOP = $(foreach dir,$(s213),$(shell echo $(dir) | cut -d/ -f1))
# LOCAL_LIBS_LIST_TOP = $(foreach dir,$(s212),$(addprefix $(CURRENT_DIR)/,$(shell echo $(dir) | cut -d/ -f1)))

# $(info >>> LOCAL_LIBS_LIST= '$(LOCAL_LIBS_LIST)')
# $(info >>> LOCAL_LIBS= '$(LOCAL_LIBS)')
# $(info >>> s212= $(s212))
# $(info >>> LOCAL_LIBS_LIST_TOP= $(LOCAL_LIBS_LIST_TOP))

# $(info >>> LOCAL_LIBS_LIST '$(LOCAL_LIBS_LIST)')
# $(info >>> LOCAL_LIBS '$(LOCAL_LIBS)')

# Core main check function
#
s209 = $(wildcard $(patsubst %,%/*.cpp,$(LOCAL_LIBS))) $(wildcard $(LOCAL_LIB_PATH)/*.cpp)
LOCAL_CPP_SRCS = $(filter-out %/$(PROJECT_NAME_AS_IDENTIFIER).cpp, $(s209))
LOCAL_CC_SRCS = $(wildcard $(patsubst %,%/*.cc,$(LOCAL_LIBS))) $(wildcard $(LOCAL_LIB_PATH)/*.cc)
LOCAL_C_SRCS = $(wildcard $(patsubst %,%/*.c,$(LOCAL_LIBS))) $(wildcard $(LOCAL_LIB_PATH)/*.c)

# Use of implicit rule for LOCAL_PDE_SRCS
#
# LOCAL_PDE_SRCS = $(wildcard *.$(SKETCH_EXTENSION))
LOCAL_AS1_SRCS = $(wildcard $(patsubst %,%/*.S,$(LOCAL_LIBS))) $(wildcard $(LOCAL_LIB_PATH)/*.S)
LOCAL_AS2_SRCS = $(wildcard $(patsubst %,%/*.s,$(LOCAL_LIBS))) $(wildcard $(LOCAL_LIB_PATH)/*.s)

LOCAL_OBJ_FILES = $(LOCAL_C_SRCS:.c=.c.o) $(LOCAL_CPP_SRCS:.cpp=.cpp.o) $(LOCAL_PDE_SRCS:.$(SKETCH_EXTENSION)=.$(SKETCH_EXTENSION).o) $(LOCAL_CC_SRCS:.cc=.cc.o) $(LOCAL_AS1_SRCS:.S=.S.o) $(LOCAL_AS2_SRCS:.s=.s.o)
RAW_LOCAL_OBJS = $(sort $(patsubst $(LOCAL_LIB_PATH)/%,$(OBJDIR)/%,$(filter-out %/$(PROJECT_NAME_AS_IDENTIFIER).o,$(LOCAL_OBJ_FILES))))

# Local archives
#
# Old
# LOCAL_ARCHIVES = $(wildcard $(patsubst %,%/*.a,$(LOCAL_LIBS_LIST_TOP))) $(wildcard $(LOCAL_LIB_PATH)/*.a)
# New
USE_ARCHIVES ?= true
ifeq ($(USE_ARCHIVES),true)
    # List local libraries with archives
    LOCAL_ARCHIVES = $(wildcard $(patsubst %,%/src/$(MCU)/*.a,$(LOCAL_LIBS_LIST_TOP))) $(wildcard $(LOCAL_LIB_PATH)/*.a)
    #  Get the paths of local libraries with archives
    WORK2 = $(patsubst %/src/$(MCU)/,%,$(foreach dir,$(LOCAL_ARCHIVES),$(dir $(dir))))
    # Generate the filter with ending %
    ARCHIVE_LOCAL_OBJS = $(foreach lib,$(WORK2),$(OBJDIR)/$(lib)/%)
    #  Filter
    LOCAL_OBJS = $(filter-out $(ARCHIVE_LOCAL_OBJS),$(RAW_LOCAL_OBJS))
    INFO_LOCAL_ARCHIVES_LIST = $(WORK2)
    INFO_LOCAL_UNARCHIVES_LIST = $(filter-out $(INFO_LOCAL_ARCHIVES_LIST),$(LOCAL_LIBS_LIST_TOP))
else
    LOCAL_OBJS = $(RAW_LOCAL_OBJS)
    INFO_LOCAL_UNARCHIVES_LIST = $(LOCAL_LIBS_LIST_TOP)
endif # USE_ARCHIVES

# $(info >>> LOCAL_ARCHIVES $(LOCAL_ARCHIVES))

# All the objects
# ??? Does order matter?
#
# $(info >>> REMOTE_OBJS-1 $(REMOTE_OBJS))
# $(info >>> CORE_OBJS-1 $(CORE_OBJS))
# $(info >>> VARIANT_OBJS-1 $(VARIANT_OBJS))
# $(info >>> BUILD_CORE_OBJS-1 $(BUILD_CORE_OBJS))
# $(info >>> APP_LIB_OBJS-1 $(APP_LIB_OBJS))
# $(info >>> BUILD_APP_LIB_OBJS-1 $(BUILD_APP_LIB_OBJS))
# $(info >>> USER_OBJS-1 $(USER_OBJS))
# $(info >>> REMOTE_NON_A_OBJS-1 $(REMOTE_NON_A_OBJS))
# $(info >>> LOCAL_OBJS-1 $(LOCAL_OBJS))

ifeq ($(REMOTE_OBJS),)
# # WAS VARIANT_OBJS in OBJS_CORE 
#     OBJS_CORE = $(CORE_OBJS) $(BUILD_CORE_OBJS)  
#     REMOTE_OBJS = $(sort $(APP_LIB_OBJS) $(BUILD_APP_LIB_OBJS) $(USER_OBJS)) 
# NOW VARIANT_OBJS in REMOTE_OBJS 
# Option 1 - Works
    OBJS_CORE = $(CORE_OBJS) $(BUILD_CORE_OBJS) 
    # OBJS_CORE = $(filter-out %/main.cpp.o,$(CORE_OBJS))) $(BUILD_CORE_OBJS) 

    REMOTE_OBJS = $(sort $(APP_LIB_OBJS) $(BUILD_APP_LIB_OBJS) $(USER_OBJS) $(VARIANT_OBJS)) 
# # Option 2 - No impact
#     OBJS_CORE = $(CORE_OBJS) $(BUILD_CORE_OBJS) $(BUILD_APP_LIB_OBJS)
#     REMOTE_OBJS = $(sort $(APP_LIB_OBJS) $(USER_OBJS) $(VARIANT_OBJS)) 
# End of options
    # REMOTE_OBJS = $(sort $(CORE_OBJS) $(BUILD_CORE_OBJS) $(APP_LIB_OBJS) $(BUILD_APP_LIB_OBJS) $(VARIANT_OBJS) $(USER_OBJS))
endif # REMOTE_OBJS
OBJS = $(OBJS_CORE) $(REMOTE_OBJS) $(REMOTE_NON_A_OBJS) $(LOCAL_OBJS)
OBJS_NON_CORE = $(REMOTE_OBJS) $(REMOTE_NON_A_OBJS) $(LOCAL_OBJS)

# $(info >>> REMOTE_OBJS-2 $(REMOTE_OBJS))
# $(info >>> OBJS_CORE-2 $(OBJS_CORE))
# $(info >>> OBJS_NON_CORE-2 $(OBJS_NON_CORE))
# $(info >>> FIRST_O_IN_A $(FIRST_O_IN_A))
# $(info >>>)
# $(info >>> CORE_OBJS $(CORE_OBJS))
# $(info >>> BUILD_CORE_OBJS $(BUILD_CORE_OBJS))
# $(info >>> APP_LIB_OBJS $(APP_LIB_OBJS))
# $(info >>> BUILD_APP_LIB_OBJS $(BUILD_APP_LIB_OBJS))
# $(info >>> LOCAL_OBJS $(LOCAL_OBJS))
# $(info >>> USER_OBJS $(USER_OBJS))
# $(info >>> VARIANT_OBJS $(VARIANT_OBJS))
# $(info >>>)
# $(info >>> OBJS $(OBJS))
# $(info >>> OBJS_CORE $(OBJS_CORE))
# $(info >>> OBJS_NON_CORE $(OBJS_NON_CORE))
# $(info >>>)

# 
# $(info >>> HARDWARE_PATH $(HARDWARE_PATH))
# $(info >>> APPLICATION_PATH $(APPLICATION_PATH))

# End of libraries selection
endif # BOOL_SELECT_BOARD

# Dependency files
#
DEPS = $(OBJS:.o=.d)

# Processor model and frequency
# ----------------------------------
#
ifndef MCU
    MCU = $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
endif # MCU

ifndef F_CPU
    F_CPU = $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)
endif # F_CPU

ifeq ($(OUT_PREPOSITION),)
    OUT_PREPOSITION = -o # end of line
endif # OUT_PREPOSITION

# Chronometer utility and calls
#
STARTCHRONO = $(shell $(UTILITIES_PATH)/emCode_chrono $(BUILDS_PATH))
STOPCHRONO = $(shell $(UTILITIES_PATH)/emCode_chrono $(BUILDS_PATH) -s)

# Serial monitoring
# ----------------------------------
#
ifeq ($(BOOL_SELECT_BOARD),1)

    ifndef SERIAL_BAUDRATE
        SERIAL_BAUDRATE = 115200
    endif # SERIAL_BAUDRATE

    ifndef SERIAL_EXEC
        SERIAL_EXEC = screen
    endif # SERIAL_EXEC

    ifeq ($(PLATFORM),LinkIt)
        ifeq ($(SUB_PLATFORM),arm)
            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
        else
            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | tail -1)
        endif # SUB_PLATFORM

    else ifeq ($(PLATFORM),Energia)

        ifneq ($(DUAL_USB),)
             USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | $(DUAL_USB) -1)

#        ifeq ($(BUILD_CORE),msp432red)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#        else ifeq ($(BUILD_CORE),msp432e)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#        else ifeq ($(BUILD_CORE),msp432)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#        else ifeq ($(BUILD_CORE),cc3220emt)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#        else ifeq ($(BUILD_CORE),cc2600emt)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#        else ifeq ($(BUILD_CORE),cc1310emt)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#        else ifeq ($(BUILD_CORE),cc1310)
#            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#		else ifeq ($(BUILD_CORE),cc13x2)
#			USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#
        else
            USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | tail -1)
        endif # DUAL_USB

#    $(shell ls -1 $(BOARD_PORT) | tail -1 > $(BUILDS_PATH)/serial.txt)
#    $(shell ls -1 $(BOARD_PORT) | head -1 > $(BUILDS_PATH)/serial.txt)
# # else ifeq ($(PLATFORM),linkitone)
#    USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt | head -1)
#
    else
        USED_SERIAL_PORT = $(shell cat $(BUILDS_PATH)/serial.txt)

    endif # PLATFORM

    ifneq ($(SERIAL_PORT),)
        USED_SERIAL_PORT := $(SERIAL_PORT)
    endif

endif # BOOL_SELECT_BOARD

ifneq ($(MAKECMDGOALS),upload)

# Work before building and linking
# ----------------------------------
#
# Info for debugging
#
$(info ==== Initial tasks ====)

# FLAG_LEGACY = $(shell find $(CURRENT_DIR)/.. -name WorkspaceSettings.xcsettings)
ifneq ($(wildcard $(UTILITIES_PATH)/emCode_check),)
    # $(info ==== GCC_PREPROCESSOR_DEFINITIONS $(GCC_PREPROCESSOR_DEFINITIONS))
    # $(info ==== ENERGIA_MT $(filter ENERGIA_MT,GCC_PREPROCESSOR_DEFINITIONS))
ifneq ($(filter ENERGIA_MT,$(GCC_PREPROCESSOR_DEFINITIONS)),)
    # $(info $(UTILITIES_PATH)/emCode_check $(CURRENT_DIR) $(PROJECT_NAME_AS_IDENTIFIER))
    $(info $(shell $(UTILITIES_PATH)/emCode_check $(CURRENT_DIR) $(PROJECT_NAME_AS_IDENTIFIER)))
    # $(info $(shell export PROJECT_DIR=$(CURRENT_DIR) ; export PROJECT_NAME=$(PROJECT_NAME_AS_IDENTIFIER) ; export UPLOADER=$(UPLOADER) ; export BUILDS_PATH=$(BUILDS_PATH) ; export CONFIG_NAME="$(CONFIG_NAME)" ; $(UTILITIES_PATH)/emCode_check))
else
endif # ENERGIA_MT
#    ifeq ($(FLAG_LEGACY),)
#        $(error Build system set to legacy. Launch a new build.)
#    endif
endif # UTILITIES_PATH
# $(shell $(UTILITIES_PATH)/emCode_chrono)
$(shell $(STARTCHRONO))

ifneq ($(wildcard $(UTILITIES_PATH)/emCode_prepare),)
    # $(info $(UTILITIES_PATH)/emCode_prepare $(CURRENT_DIR))
    $(info $(shell $(UTILITIES_PATH)/emCode_prepare $(CURRENT_DIR)))
    # DUMMY = $(shell $(UTILITIES_PATH)/emCode_prepare $(CURRENT_DIR))
endif # UTILITIES_PATH
$(info ==== End of initial tasks ====)

endif # MAKECMDGOALS upload

ifeq ($(MAKECMDGOALS),upload)
    HIDE_INFO ?= true
endif # MAKECMDGOALS upload

ifneq ($(MESSAGE_CRITICAL),)
    $(info CRITICAL         $(MESSAGE_CRITICAL))
    $(shell zenity --width=240 --title "emCode" --text "$(MESSAGE_CRITICAL)" --warning)

# $(shell export SUBTITLE='Warning' ; export MESSAGE='$(MESSAGE_WARNING)' ; $(UTILITIES_PATH)/Notify.app/Contents/MacOS/applet)
endif # MESSAGE_CRITICAL

ifneq ($(HIDE_INFO),true)
ifeq ($(UNKNOWN_BOARD),1)
    $(info .)
    $(info ==== Info ====)
    $(error 'ERROR	$(BOARD_TAG) board is unknown')
    $(info ==== Info done ====)
endif # UNKNOWN_BOARD

ifeq ($(BOOL_SELECT_BOARD),1)
    $(info .)
    $(info ==== Info ====)
    $(info Date Time         $(shell date '+%F %T'))
    $(info ---- Project ----)
    $(info Target            $(MAKECMDGOALS))
    $(info Name              $(PROJECT_NAME_AS_IDENTIFIER) ($(SKETCH_EXTENSION)))

    ifneq ($(MESSAGE_WARNING),)
        $(info WARNING           $(MESSAGE_WARNING))
    endif # MESSAGE_WARNING
    ifneq ($(MESSAGE_INFO),)
        $(info Information       $(MESSAGE_INFO))
    endif # MESSAGE_INFO

    ifneq ($(USB_VID),)
        $(info USB               VID = $(USB_VID), PID = $(USB_PID))
    endif # USB_VID

    $(info ---- Port ----)
    $(info Uploader          $(UPLOADER))

    ifeq ($(UPLOADER),avrdude)
        ifeq ($(AVRDUDE_NO_SERIAL_PORT),1)
            $(info AVRdude       no serial port)
        else
            $(info AVRdude       $(AVRDUDE_PORT))
        endif # AVRDUDE_NO_SERIAL_PORT
        ifneq ($(AVRDUDE_PROGRAMMER),)
            $(info Programmer    $(AVRDUDE_PROGRAMMER))
        endif # AVRDUDE_PROGRAMMER
        ifneq ($(BOOTLOADER),)
            $(info Boot-loader   $(BOOTLOADER))
        endif # BOOTLOADER
    endif # UPLOADER
    ifeq ($(UPLOADER),mspdebug)
        $(info Protocol          $(UPLOADER_PROTOCOL))
    endif # UPLOADER

    ifeq ($(AVRDUDE_NO_SERIAL_PORT),1)
        $(info Serial            no serial port)
    else ifeq ($(BOARD_PORT),ssh)
        $(info Serial            $(SSH_ADDRESS))
    else
        $(info Serial            $(USED_SERIAL_PORT))
    endif # AVRDUDE_NO_SERIAL_PORT

    ifeq ($(UPLOADER),xds110)
    ifneq ($(XDS110_SERIAL),)
        $(info XDS110            $(XDS110_SERIAL))
    endif # XDS110_SERIAL
    endif # UPLOADER

    ifeq ($(UPLOADER),jlink)
    ifneq ($(JLINK_SERIAL),)
        $(info J-Link            $(JLINK_SERIAL))
    endif # JLINK_SERIAL
    endif # UPLOADER

    $(info ---- Core libraries ----)
    $(info From              $(CORE_LIB_PATH)) # | cut -d. -f1,2
    $(info List              $(notdir $(CORE_LIBS_LIST)))
    # $(foreach file,$(CORE_LIBS_LIST),$(info . $(file) release $(shell grep version $(CORE_LIB_PATH)/$(file)/library.properties | cut -d= -f2)))

    ifneq ($(strip $(APP_LIBS_LIST)),0)
        $(info ---- Application libraries ----)
        $(info From              $(basename $(APP_LIB_PATH))) # | cut -d. -f1,2
        ifneq ($(strip $(APP_LIBS_LIST)),)
            $(info List              $(filter-out 0,$(sort $(basename $(APP_LIBS_LIST)) $(basename $(notdir $(BUILD_APP_LIBS_LIST))))))
            # $(foreach file,$(APP_LIBS_LIST),$(info . $(file) release $(shell grep version $(APP_LIB_PATH)/$(file)/library.properties | cut -d= -f2)))
            $(foreach file,$(APP_LIBS_LIST),$(info Library           $(call VERSION,$(file),$(APP_LIB_PATH))))

        endif # APP_LIBS_LIST
    endif # APP_LIBS_LIST

    $(info ---- User libraries and archives ----)
#    $(info From              $(SKETCHBOOK_DIR))
    $(info From              $(USER_LIB_PATH))

    ifneq ($(strip $(USER_LIBS_LIST)),0) # none
    ifneq ($(strip $(USER_LIBS_LIST)),) # all

        # s230a := $(shell find $(LOCAL_LIB_PATH) -maxdepth 1 -type d)
        s230a := $(shell find $(USER_LIB_PATH) -type d)
        s230b := $(subst $(USER_LIB_PATH)/,,$(s230a))
        s230c := $(filter-out $(s230b),$(USER_LIBS_LIST))

        ifneq ($(strip $(s230c)),)
            $(info Missing folders   $(s230c))
            $(info .)
            $(error Stop)            
        endif
    endif # USER_LIBS_LIST
    endif # USER_LIBS_LIST

    ifneq ($(strip $(INFO_USER_UNARCHIVES_LIST)),)
        ifeq ($(strip $(USER_LIBS_LIST)),0)
            $(info Libraries         None)
        else
            $(info Libraries         $(INFO_USER_UNARCHIVES_LIST))
            # $(foreach file,$(INFO_USER_UNARCHIVES_LIST),$(info . $(file) release $(shell grep version $(USER_LIB_PATH)/$(file)/library.properties | cut -d= -f2)))
            $(foreach file,$(INFO_USER_UNARCHIVES_LIST),$(info Library           $(call VERSION,$(file),$(USER_LIB_PATH))))

        endif # USER_LIBS_LIST
    endif # INFO_USER_UNARCHIVES_LIST
    ifneq ($(strip $(INFO_USER_ARCHIVES_LIST)),)
        $(info Archives          $(INFO_USER_ARCHIVES_LIST))
        # $(foreach file,$(INFO_USER_ARCHIVES_LIST),$(info . $(file) release $(shell grep version $(USER_LIB_PATH)/$(file)/library.properties | cut -d= -f2)))
        $(foreach file,$(INFO_USER_ARCHIVES_LIST),$(info Archive           $(call VERSION,$(file),$(USER_LIB_PATH))))
    endif # INFO_USER_ARCHIVES_LIST

#     $(info ---- Local libraries ----)
#     $(info From              $(CURRENT_DIR))
# 
#     ifneq ($(wildcard $(LOCAL_LIB_PATH)/*.h),)
#         $(info List              $(subst .h,,$(notdir $(wildcard $(LOCAL_LIB_PATH)/*.h))))
#     endif # LOCAL_LIB_PATH
#     ifneq ($(wildcard $(LOCAL_LIB_PATH)/*.hpp),)
#         $(info List              $(subst .hpp,,$(notdir $(wildcard $(LOCAL_LIB_PATH)/*.hpp))))
#     endif # LOCAL_LIB_PATH
#     ifneq ($(strip $(LOCAL_LIBS_LIST)),)
#         $(info List              $(subst / , ,$(LOCAL_LIBS_LIST) ))
# #        $(shell "echo  . $(LOCAL_LIBS_LIST) | sed 's/\/ / /g'")
#     endif # LOCAL_LIBS_LIST
#     ifeq ($(wildcard $(LOCAL_LIB_PATH)/*.h),)
#     ifeq ($(wildcard $(LOCAL_LIB_PATH)/*.hpp),)
#     ifeq ($(strip $(LOCAL_LIBS_LIST)),)
#         $(info List              (empty))
#     endif # LOCAL_LIBS_LIST
#     endif # LOCAL_LIB_PATH
#     endif # LOCAL_LIB_PATH
# 
#     ifneq ($(strip $(INFO_LOCAL_UNARCHIVES_LIST)),)
#         $(info List*             $(INFO_LOCAL_UNARCHIVES_LIST))
#     endif # INFO_LOCAL_UNARCHIVES_LIST
# 
#     ifneq ($(strip $(LOCAL_ARCHIVES)),)
#         $(info ---- Local archives ----)
#         $(info From              $(CURRENT_DIR))
# #        ifneq ($(wildcard $(LOCAL_LIB_PATH)/*.a),)
# # Old
# # New
#         $(info List              $(subst lib,,$(subst .a,,$(notdir $(LOCAL_ARCHIVES)))))
# #        $(info List              $(subst lib,,$(subst .a,,$(notdir $(foreach dir,$(LOCAL_LIBS_LIST),$(wildcard $(dir)/src/$(MCU)/*.a))))))
# #        endif
# #        ifneq ($(strip $(LOCAL_LIBS_LIST)),)
# #			@echo '$(LOCAL_LIBS_LIST) ' | sed 's/\/ / /g'
# #        endif
#     endif # LOCAL_ARCHIVES
#     ifneq ($(strip $(INFO_LOCAL_ARCHIVES_LIST)),)
#         $(info List*             $(INFO_LOCAL_ARCHIVES_LIST))
#     endif # INFO_LOCAL_ARCHIVES_LIST

    $(info ---- Local libraries and archives ----)
    $(info From              $(CURRENT_DIR))

    ifneq ($(strip $(LOCAL_LIBS_LIST)),0) # none
    ifneq ($(strip $(LOCAL_LIBS_LIST)),) # all

        # s220a := $(shell find $(LOCAL_LIB_PATH) -maxdepth 1 -type d)
        s220a := $(shell find $(LOCAL_LIB_PATH) -type d)
        s220b := $(subst ./,,$(s220a))
        s220c := $(filter-out $(s220b),$(LOCAL_LIBS_LIST))

        ifneq ($(strip $(s220c)),)
            $(info Missing folders   $(s220c))
            $(info .)
            $(error Stop)            
        endif
    endif # LOCAL_LIBS_LIST
    endif # LOCAL_LIBS_LIST

    ifneq ($(strip $(INFO_LOCAL_UNARCHIVES_LIST)),)
        $(info Libraries         $(INFO_LOCAL_UNARCHIVES_LIST))

        # $(foreach file,$(INFO_LOCAL_UNARCHIVES_LIST),$(info $(CURRENT_DIR)/$(file)/library.properties))
        # $(foreach file,$(INFO_LOCAL_UNARCHIVES_LIST),$(info . $(file) release $(shell grep version $(CURRENT_DIR)/$(file)/library.properties | cut -d= -f2)))
        $(foreach file,$(INFO_LOCAL_UNARCHIVES_LIST),$(info Library           $(call VERSION,$(file),$(CURRENT_DIR))))

        # $(foreach file,$(INFO_LOCAL_UNARCHIVES_LIST),$(shell printf '%-18s %s\n' $(file) $(shell grep version $(CURRENT_DIR)/$(file)/library.properties | cut -d= -f2)))

    endif # INFO_USER_UNARCHIVES_LIST
    ifneq ($(strip $(INFO_LOCAL_ARCHIVES_LIST)),)
        $(info Archives          $(INFO_LOCAL_ARCHIVES_LIST))
        # $(foreach file,$(INFO_LOCAL_ARCHIVES_LIST),$(info . $(file) release $(shell grep version $(CURRENT_DIR)/$(file)/library.properties | cut -d= -f2)))
        $(foreach file,$(INFO_LOCAL_ARCHIVES_LIST),$(info Archive           $(call VERSION,$(file),$(CURRENT_DIR))))
    endif # INFO_USER_ARCHIVES_LIST

    $(info ==== Info done ====)
    $(info .)
    $(info ==== Tools ====)
    $(info ---- Platform ----)
    $(info Platform          $(PLATFORM) $(PLATFORM_VERSION))
    $(info Board             $(BOARD_NAME) ($(BOARD_TAG)))

    $(info ---- emCode ----)
    $(info Edition           $(EMCODE_REFERENCE) release $(EMCODE_RELEASE))

    $(info Template          $(EMCODE_EDITION) release $(shell grep $(CURRENT_DIR)/Makefile -e 'Last update' | xargs | rev | cut -d' ' -f1 | rev) )
    $(info Makefile          $(MAKEFILE_NAME) $(MAKEFILE_RELEASE))

    $(info Configuration     $(CONFIG_NAME) release $(shell if [ -f '$(CONFIGURATIONS_PATH)/$(SELECTED_BOARD).mk' ] ; then grep '$(CONFIGURATIONS_PATH)/$(SELECTED_BOARD).mk' -e 'Last update' | xargs | rev | cut -d' ' -f1 | rev ; else echo '?'; fi))

#    endif
#   $(info $(shell if [ -f '$(CONFIGURATIONS_PATH_SPACE)/$(CONFIG_NAME).mk' ] ; then echo '. Configuration $(CONFIG_NAME) release' $$(grep '$(CONFIGURATIONS_PATH_SPACE)/$(CONFIG_NAME).mk' -e 'Last update' | rev | cut -d' ' -f1 | rev) ; fi) )))

    $(info ---- Tools ----)
    $(info Make              $(shell make -version | head -1 ))
# 
#     ifeq ($(BUILD_CORE),c2000)
#         $(info Tool-chain        $(shell $(CC) -version | head -1 ))
#     else
        $(info Tool-chain        $(shell $(CC) --version | head -1 ))
#     endif # BUILD_CORE c2000
# 
    ifeq ($(BUILD_CORE),msp430)
        $(info Support files     msp430-gcc-support-files $(shell if [ -f $(TOOL_CHAIN_PATH)/msp430-gcc-support-files/Revisions_Header.txt ] ; then grep $(TOOL_CHAIN_PATH)/include/devices.csv -e Version | head -1 | cut -d, -f2 ; fi))
    endif # BUILD_CORE msp430
    ifeq ($(BUILD_CORE),msp430elf)
        $(info Support files     msp430-gcc-support-files $(shell if [ -f $(TOOL_CHAIN_PATH)/msp430-gcc-support-files/Revisions_Header.txt ] ; then grep $(TOOL_CHAIN_PATH)/msp430-gcc-support-files/Revisions_Header.txt -e ^Build | head -1 | sed 's:^Build ::' ; fi))
    endif # BUILD_CORE msp430elf

    ifeq ($(MAKECMDGOALS),debug)
    ifneq ($(UPLOADER),ozone)
        ifneq (,$(wildcard $(GDB)))
            $(info GDB               $(shell $(GDB) --version | head -1 ))
        endif
    endif # UPLOADER
    endif # MAKECMDGOALS

    $(info ---- Configuration ----)
    $(info OS                $(shell uname -a))
    $(info IDE               Visual Studio Code $(shell code -v))
# #    $(info $(shell if [ -d /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj ] ; then defaults read /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj/SIMachineAttributes.plist $$(sysctl hw.model | cut -d: -f2) | grep marketingModel | cut -d\" -f2-3 | sed 's/\\//g' ; fi ))
# # \"
# #    $(info $(shell if [ -d /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/en.lproj ] ; then defaults read /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/en.lproj/SIMachineAttributes.plist $$(sysctl hw.model | cut -d: -f2) | grep marketingModel | cut -d\" -f2-3 | sed 's/\\//g' ; fi ))
#     $(info Hardware		$(shell if [ -d /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj/SIMachineAttributes.plist ] ; then defaults read /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/English.lproj/SIMachineAttributes.plist $$(sysctl hw.model | cut -d: -f2) | grep marketingModel | cut -d\" -f2-3 | sed 's/\\//g' ; elif [ -d /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/en.lproj ] ; then defaults read /System/Library/PrivateFrameworks/ServerInformation.framework/Versions/A/Resources/en.lproj/SIMachineAttributes.plist $$(sysctl hw.model | cut -d: -f2) | grep marketingModel | cut -d\" -f2-3 | sed 's/\\//g' ; fi ))
# # \"

#     $(info macOS 		$(shell sw_vers -productName) $(shell sw_vers -productVersion) ($(shell sw_vers -buildVersion)) )

# #        @echo Xcode $$(system_profiler SPDeveloperToolsDataType | grep "Version" | cut -d: -f2) $$(echo on Mac $$(system_profiler SPSoftwareDataType | grep "System Version" | cut -d: -f2))
# #        @echo Mac $$(system_profiler SPSoftwareDataType | grep "System Version" | cut -d: -f2)
#     $(info IDE			Xcode$(shell system_profiler SPDeveloperToolsDataType | grep "Version" | cut -d: -f2))
# #        @echo Xcode $(XCODE_VERSION_ACTUAL)' ('$(XCODE_PRODUCT_BUILD_VERSION)')' | sed "s/\( ..\)/\1\./"

    $(info ---- Environment ----)
    ifneq (,$(wildcard $(UTILITIES_PATH)/emCode_check))
        $(info Check             $(shell $(UTILITIES_PATH)/emCode_check -v ))
    endif # UTILITIES_PATH
    ifneq (,$(wildcard $(UTILITIES_PATH)/emCode_prepare))
        $(info Prepare           $(shell $(UTILITIES_PATH)/emCode_prepare -v ))
    endif # UTILITIES_PATH
#     ifneq (,$(wildcard $(UTILITIES_PATH)/emCode_debug))
#         $(info Debug		$(shell $(UTILITIES_PATH)/emCode_debug -v ))
#     endif # UTILITIES_PATH

    $(info ---- Arduino ----)
    ifneq ($(ARDUINO_FLATPAK_RELEASE),)
        $(info Arduino IDE       FlatPak release $(ARDUINO_FLATPAK_RELEASE))
    endif # ARDUINO_CLI_RELEASE
    ifneq ($(ARDUINO_APPIMAGE_RELEASE),)
        $(info Arduino IDE       AppImage release $(ARDUINO_APPIMAGE_RELEASE))
    endif # ARDUINO_APPIMAGE_RELEASE
    ifneq ($(ARDUINO_CLI_RELEASE),)
        $(info Arduino CLI       release $(ARDUINO_CLI_RELEASE))
    endif # ARDUINO_APPIMAGE_RELEASE

    $(info ---- Other ----)
#    $(info Check new release	$(shell grep $(EMCODE_APP)/parameters.txt -e allowCheck.newRelease | cut -d= -f2))
    $(info Project folder    $(CURRENT_DIR))
    $(info Build folder      $(BUILDS_PATH))
    $(info Binary name       $(BINARY_SPECIFIC_NAME))

    ifneq ($(strip $(KEEP_MAIN)),true)
        $(info main.cpp          updated)
    else
        $(info main.cpp          unchanged)
    endif # KEEP_MAIN

    ifeq ($(wildcard $(TARGET_CORE_A)),)
        $(info Generate          $(SELECTED_BOARD)_$(RELEASE_CORE).a)
    else
        $(info Use               $(SELECTED_BOARD)_$(RELEASE_CORE).a)
    endif

    $(info ==== Tools done ====)
endif # BOOL_SELECT_BOARD
endif # HIDE_INFO

# $(info ==== SERIAL_EXEC $(SERIAL_EXEC))
ifneq ($(SERIAL_EXEC),)
    CURRENT_EXEC := $(shell /usr/bin/pgrep $(SERIAL_EXEC))
endif # SERIAL_EXEC

# $(info ==== CURRENT_EXEC $(CURRENT_EXEC))
# $(info ==== BOARD_PORT $(BOARD_PORT))

ifneq ($(strip $(OLD_TAG)),)
    OLD_USED_SERIAL_PORT = $(shell if [ -f $(OLD_TAG) ] ; then cat $(OLD_TAG) ; fi )
endif
# $(info ==== OLD_USED_SERIAL_PORT $(OLD_USED_SERIAL_PORT))
ifneq ($(USED_SERIAL_PORT),$(OLD_USED_SERIAL_PORT))
	CURRENT_EXEC :=#
endif # USED_SERIAL_PORT

$(shell mkdir -p $(EMCODE_TOOLS)/Cores)

# Rules
# ----------------------------------
#
# Main targets
#
TARGET_A = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).a
TARGET_HEX = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).hex
TARGET_UF2 = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).uf2
TARGET_ELF = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).elf
TARGET_BIN = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).bin
TARGET_BIN2 = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).bin2
TARGET_OUT = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).out
TARGET_DOT = $(OBJDIR)/$(BINARY_SPECIFIC_NAME)
TARGET_TXT = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).txt
TARGETS = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).*
TARGET_MCU = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).mcu
TARGET_VXP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).vxp
TARGET_ZIP = $(OBJDIR)/$(BINARY_SPECIFIC_NAME).zip
TARGET_AXF = $(OBJDIR)/application.axf

ifndef TARGET_HEXBIN
    TARGET_HEXBIN = $(TARGET_HEX)
endif # TARGET_HEXBIN

ifndef TARGET_EEP
    TARGET_EEP =
endif # TARGET_EEP

# List of dependencies
#
DEP_FILE = $(OBJDIR)/depends.mk

# General arguments
#
# ifeq ($(APP_LIBS_LOCK),)
    SYS_INCLUDES = $(patsubst %,-I%,$(APP_LIBS))
    SYS_INCLUDES += $(patsubst %,-I%,$(BUILD_APP_LIBS))
    SYS_INCLUDES += $(patsubst %,-I%,$(USER_LIBS))
    SYS_INCLUDES += $(patsubst %,-I%,$(LOCAL_LIBS))
    SYS_INCLUDES += -I.
# endif

# Horrible patch for Seeed_Arduino_rpcUnified/src/lwip
ifneq ($(findstring Seeed_Arduino_rpcUnified,$(USER_LIBS_LIST)),)
    SYS_INCLUDES := $(filter-out %/Seeed_Arduino_rpcUnified/src/lwip,$(SYS_INCLUDES))
endif # USER_LIBS_LIST

SYS_OBJS = $(wildcard $(patsubst %,%/*.o,$(APP_LIBS)))
SYS_OBJS += $(wildcard $(patsubst %,%/*.o,$(BUILD_APP_LIBS)))
SYS_OBJS += $(wildcard $(patsubst %,%/*.o,$(USER_LIBS)))

ifeq ($(WARNING_OPTIONS),)
    FLAGS_WARNING = -Wall
else
    ifeq ($(strip $(WARNING_OPTIONS)),0)
        FLAGS_WARNING = -w
    else
        FLAGS_WARNING = $(addprefix -W, $(WARNING_OPTIONS))
    endif
endif # WARNING_OPTIONS

ifneq ($(strip $(COMPILER_OPTIONS)),0)
    ifneq ($(COMPILER_OPTIONS),)
        FLAGS_ALL += $(COMPILER_OPTIONS)
        FLAGS_LD += $(COMPILER_OPTIONS)
    endif
endif # COMPILER_OPTIONS

ifneq ($(strip $(LINKER_OPTIONS)),0)
    ifneq ($(LINKER_OPTIONS),)
        FLAGS_LD += $(LINKER_OPTIONS)
    endif
endif # LINKER_OPTIONS

ifeq ($(OPTIMISATION),)
    OPTIMISATION = -Os -g
endif # OPTIMISATION

ifeq ($(FLAGS_ALL),)
    FLAGS_ALL = -$(MCU_FLAG_NAME)=$(MCU) -DF_CPU=$(F_CPU)
    FLAGS_ALL += $(SYS_INCLUDES) -g $(OPTIMISATION) $(FLAGS_WARNING) -ffunction-sections -fdata-sections
    FLAGS_ALL += $(FLAGS_ALL_EXTRA) -I$(CORE_LIB_PATH)
else
    FLAGS_ALL += $(SYS_INCLUDES)
endif # FLAGS_ALL

ifdef USB_FLAGS
    FLAGS_ALL += $(USB_FLAGS)
endif # USB_FLAGS

ifdef USE_GNU99
    FLAGS_C += -std=gnu99
endif # USE_GNU99

# FLAGS_CPP = flags for C++ only
# FLAGS_ALL = flags for both C and C++
#
ifeq ($(FLAGS_CPP),)
    FLAGS_CPP = -fno-exceptions
else
    FLAGS_CPP += $(FLAGS_CPP_EXTRA)
endif # FLAGS_CPP

ifeq ($(FLAGS_AS),)
    FLAGS_AS = -$(MCU_FLAG_NAME)=$(MCU) -x assembler-with-cpp
endif # FLAGS_AS

ifeq ($(FLAGS_LD),)
    FLAGS_LD = -$(MCU_FLAG_NAME)=$(MCU) -Wl,--gc-sections $(OPTIMISATION) $(FLAGS_LD_EXTRA)
endif # FLAGS_LD

ifndef FLAGS_OBJCOPY
    FLAGS_OBJCOPY = -O ihex -R .eeprom
endif # FLAGS_OBJCOPY

# Build
# ----------------------------------
#
# 1- APP and BUILD_APP, CORE and VARIANT libraries
#
# ifeq ($(wildcard $(TARGET_CORE_A)),)

$(OBJDIR)/%.cpp.o: $(HARDWARE_PATH)/%.cpp
	$(call SHOW,"1.1-CORE CPP","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -c $(FLAGS_ALL) $(FLAGS_CPP) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.c.o: $(HARDWARE_PATH)/%.c
	$(call SHOW,"1.2-CORE C","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_C)  "$<"  $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.s.o: $(HARDWARE_PATH)/%.s
	$(call SHOW,"1.3-CORE AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_AS) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.S.o: $(HARDWARE_PATH)/%.S
	$(call SHOW,"1.4-CORE AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_AS) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.d: $(HARDWARE_PATH)/%.c
	$(call SHOW,"1.5-CORE D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_C) "$<" -MF $@ -MT $(@:.d=.c.o)

$(OBJDIR)/%.d: $(HARDWARE_PATH)/%.cpp
	$(call SHOW,"1.6-CORE D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -MM $(FLAGS_ALL) $(FLAGS_CPP) "$<" -MF $@ -MT $(@:.d=.cpp.o)

$(OBJDIR)/%.d: $(HARDWARE_PATH)/%.S
	$(call SHOW,"1.7-CORE D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_AS) "$<" -MF $@ -MT $(@:.d=.S.o)

$(OBJDIR)/%.d: $(HARDWARE_PATH)/%.s
	$(call SHOW,"1.8-CORE D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_AS) "$<" -MF $@ -MT $(@:.d=.s.o)

# endif # TARGET_CORE_A

# 2- APP and BUILD_APP, CORE and VARIANT libraries
#
$(OBJDIR)/%.cpp.o: $(APPLICATION_PATH)/%.cpp
	$(call SHOW,"2.1-APP CPP","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -c $(FLAGS_ALL) $(FLAGS_CPP) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.c.o: $(APPLICATION_PATH)/%.c
	$(call SHOW,"2.2-APP C","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_C) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.s.o: $(APPLICATION_PATH)/%.s
	$(call SHOW,"2.3-APP AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_AS) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.S.o: $(APPLICATION_PATH)/%.S
	$(call SHOW,"2.4-APP AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_AS) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.d: $(APPLICATION_PATH)/%.c
	$(call SHOW,"2.5-APP D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_C) "$<" -MF $@ -MT $(@:.d=.c.o)

$(OBJDIR)/%.d: $(APPLICATION_PATH)/%.cpp
	$(call SHOW,"2.6-APP D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -MM $(FLAGS_ALL) $(FLAGS_CPP) "$<" -MF $@ -MT $(@:.d=.cpp.o)

$(OBJDIR)/%.d: $(APPLICATION_PATH)/%.S
	$(call SHOW,"2.7-APP D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_AS) "$<" -MF $@ -MT $(@:.d=.S.o)

$(OBJDIR)/%.d: $(APPLICATION_PATH)/%.s
	$(call SHOW,"2.8-APP D","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_AS) "$<" -MF $@ -MT $(@:.d=.s.o)

# 3- USER library sources
#
$(OBJDIR)/user/%.cpp.o: $(USER_LIB_PATH)/%.cpp
	$(call SHOW,"3.1-USER CPP","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -c $(FLAGS_ALL) $(FLAGS_CPP) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/user/%.c.o: $(USER_LIB_PATH)/%.c
	$(call SHOW,"3.2-USER C","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_C) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/user/%.d: $(USER_LIB_PATH)/%.cpp
	$(call SHOW,"3.3-USER CPP","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -MM $(FLAGS_ALL) $(FLAGS_CPP) "$<" -MF $@ -MT $(@:.d=.cpp.o)

$(OBJDIR)/user/%.d: $(USER_LIB_PATH)/%.c
	$(call SHOW,"3.4-USER C","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_C) "$<" -MF $@ -MT $(@:.d=.c.o)

# 4- LOCAL library sources
# .o rules are for objects, .d for dependency tracking
#
$(OBJDIR)/%.c.o: %.c
	$(call SHOW,"4.1-LOCAL C","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_C) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.cc.o: %.cc
	$(call SHOW,"4.2-LOCAL CC","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -c $(FLAGS_ALL) $(FLAGS_CPP) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.cpp.o: %.cpp
	$(call SHOW,"4.3-LOCAL CPP",$@,$(patsubst $<,$(BUILDS_PATH),))

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -c $(FLAGS_ALL) $(FLAGS_CPP) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.S.o: %.S
	$(call SHOW,"4.4-LOCAL AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_AS) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.s.o: %.s
	$(call SHOW,"4.5-LOCAL AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -c $(FLAGS_ALL) $(FLAGS_AS) "$<" $(OUT_PREPOSITION)"$@"

$(OBJDIR)/%.d: %.c
	$(call SHOW,"4.6-LOCAL C","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_C) "$<" -MF $@ -MT $(@:.d=.c.o)

$(OBJDIR)/%.d: %.cpp
	$(call SHOW,"4.7-LOCAL CPP","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CXX) -MM $(FLAGS_ALL) $(FLAGS_CPP) "$<" -MF $@ -MT $(@:.d=.cpp.o)

$(OBJDIR)/%.d: %.S
	$(call SHOW,"4.8-LOCAL AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_AS) "$<" -MF $@ -MT $(@:.d=.S.o)

$(OBJDIR)/%.d: %.s
	$(call SHOW,"4.9-LOCAL AS","$@","$<")

	@mkdir -p "$(dir $@)"
	$(QUIET)$(CC) -MM $(FLAGS_ALL) $(FLAGS_AS) "$<" -MF $@ -MT $(@:.d=.s.o)

# 5- Archive and Link
# ----------------------------------
#
ifeq ($(wildcard $(TARGET_CORE_A)),)

$(TARGET_CORE_A): $(OBJS_CORE) 
	@echo "---- Core ----"
	$(call SHOW,"5.8-ARCHIVE",$(TARGET_CORE_A),.)
#	@echo OBJS_CORE $(OBJS_CORE) 

ifneq ($(FIRST_O_IN_CORE_A),)
	$(QUIET)$(AR) rcs $(TARGET_CORE_A) $(FIRST_O_IN_CORE_A)
endif # FIRST_O_IN_CORE_A

	$(QUIET)$(AR) rcs $(TARGET_CORE_A) $(patsubst %,"%",$(OBJS_CORE))

endif # TARGET_CORE_A

$(TARGET_A): $(OBJS_NON_CORE)
	@echo "---- Link ----"
	$(call SHOW,"5.1-ARCHIVE",$(TARGET_A),.)

ifneq ($(FIRST_O_IN_A),)
	$(QUIET)$(AR) rcs $(TARGET_A) $(FIRST_O_IN_A)
endif # FIRST_O_IN_A

ifneq ($(COMMAND_ARCHIVE),)
	$(QUIET)$(COMMAND_ARCHIVE)
else
ifeq ($(PLATFORM),IntelEdisonYocto)
    ifneq ($(REMOTE_OBJS),)
		$(QUIET)$(AR) rcs $(TARGET_A) $(patsubst %,"%",$(REMOTE_OBJS))
    endif # REMOTE_OBJS
else
	$(QUIET)$(AR) rcs $(TARGET_A) $(patsubst %,"%",$(REMOTE_OBJS))
endif # PLATFORM
endif # COMMAND_ARCHIVE

ifneq ($(COMMAND_EXTRA),)
	$(call SHOW,"5.2-EXTRA",$@,.)

	$(QUIET)$(COMMAND_EXTRA)
endif # COMMAND_EXTRA

$(TARGET_ELF): $(TARGET_CORE_A) $(TARGET_A)
ifneq ($(COMMAND_LINK),)
	$(call SHOW,"5.3-LINK",$@,.)

	$(QUIET)$(COMMAND_LINK)

else
	$(call SHOW,"5.4-LINK default",$@,.)

	$(QUIET)$(CXX) $(OUT_PREPOSITION)"$@" $(LOCAL_OBJS) $(LOCAL_ARCHIVES) $(USER_ARCHIVES) $(TARGET_CORE_A) $(TARGET_A) $(FLAGS_LD)
endif # COMMAND_LINK

$(TARGET_OUT): $(OBJS_CORE) $(OBJ_NON_CORE)
# ifeq ($(BUILD_CORE),c2000)
# 	$(call SHOW,"5.5-ARCHIVE",$@,.)
# 
# 	$(QUIET)$(AR) r $(TARGET_A) $(FIRST_O_IN_A)
# 	$(QUIET)$(AR) r $(TARGET_A) $(REMOTE_OBJS)
# 
# 	$(call SHOW,"5.6-LINK",$@,.)
# 
# 	$(QUIET)$(CC) $(FLAGS_ALL) $(FLAGS_LD) $(OUT_PREPOSITION)"$@" $(LOCAL_OBJS) $(TARGET_A) $(COMMAND_FILES) -l$(LDSCRIPT)
# 
# else
	$(call SHOW,"5.7-LINK",$@,.)

# endif # BUILD_CORE

# 6- Final conversions
# ----------------------------------
#
$(OBJDIR)/%.hex: $(OBJDIR)/%.elf
	$(call SHOW,"6.1-COPY HEX","$@","$<")

ifneq ($(COMMAND_COPY),)
	$(QUIET)$(COMMAND_COPY)
    ifneq ($(COMMAND_POST_COPY),)
		$(call SHOW,"6.2-POST HEX","$@","$<")
		$(QUIET)$(COMMAND_POST_COPY)

    endif # COMMAND_COPY_POST
else
	$(QUIET)$(OBJCOPY) -O ihex -R .eeprom "$<" $@

endif # COMMAND_COPY

ifneq ($(SOFTDEVICE),)
	$(call SHOW,"6.3-COPY HEX","$@","$<")

	$(QUIET)$(MERGE_PATH)/$(MERGE_EXEC) $(SOFTDEVICE_HEX) -intel $(CURRENT_DIR)/$@ -intel $(OUT_PREPOSITION)$(CURRENT_DIR)/combined.hex $(MERGE_OPTS)
	$(QUIET)mv $(CURRENT_DIR)/combined.hex $(CURRENT_DIR)/$@
endif # SOFTDEVICE

$(OBJDIR)/%.bin: $(OBJDIR)/%.elf
	$(call SHOW,"6.4-COPY BIN","$@","$<")

ifneq ($(COMMAND_COPY),)
	$(QUIET)$(COMMAND_COPY)
    ifneq ($(COMMAND_POST_COPY),)
		$(call SHOW,"6.5-POST BIN","$@","$<")
		$(QUIET)$(COMMAND_POST_COPY)
    endif # COMMAND_POST_COPY
else
	$(QUIET)$(OBJCOPY) -O binary "$<" $@
endif # COMMAND_COPY

$(OBJDIR)/%.bin2: $(OBJDIR)/%.elf
	$(call SHOW,"6.6-COPY BIN","$@","$<")

#	$(QUIET)$(ESP_POST_COMPILE) -eo $(BOOTLOADER_ELF) -bo $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)_$(ADDRESS_BIN1).bin -bm $(FLAGS_OBJCOPY) -bf $(BUILD_FLASH_FREQ) -bz $(BUILD_FLASH_SIZE) -bs .text -bp 4096 -ec -eo "$<" -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec
	$(QUIET)$(POST_COMPILE_COMMAND)

	$(QUIET)cp $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)_$(ADDRESS_BIN1).bin $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).bin

$(OBJDIR)/%.eep: $(OBJDIR)/%.elf
	$(call SHOW,"6.7-COPY EEP","$@","$<")

	-$(QUIET)$(OBJCOPY) -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 "$<" $@

$(OBJDIR)/%.lss: $(OBJDIR)/%.elf
	$(call SHOW,"6.8-COPY LSS","$@","$<")

	$(QUIET)$(OBJDUMP) -h -S "$<" > $@

$(OBJDIR)/%.sym: $(OBJDIR)/%.elf
	$(call SHOW,"6.9-COPY SYM","$@","$<")

	$(QUIET)$(NM) -n "$<" > $@

# $(OBJDIR)/%.txt: $(OBJDIR)/%.out
# 	$(call SHOW,"6.8-COPY","$@","$<")
# 
# 	echo ' -boot -sci8 -a "$<" -o $@'
# 	$(QUIET)$(OBJCOPY) -boot -sci8 -a "$<" -o $@

$(OBJDIR)/%.mcu: $(OBJDIR)/%.elf
	$(call SHOW,"6.10-COPY MCU","$@","$<")

	@$(REMOVE) -f $(OBJDIR)/intel_mcu.*
	@cp $(OBJDIR)/$(BINARY_SPECIFIC_NAME).elf $(OBJDIR)/intel_mcu.elf
	@cd $(OBJDIR) ; export TOOLCHAIN_PATH=$(APP_TOOLS_PATH) ; $(UTILITIES_PATH)/generate_mcu.sh

$(OBJDIR)/%.vxp: $(OBJDIR)/%.elf
	$(call SHOW,"6.11-COPY VXP","$@","$<")

	$(QUIET)cp $(OBJDIR)/$(BINARY_SPECIFIC_NAME).elf $(OBJDIR)/$(BINARY_SPECIFIC_NAME)2.elf
	$(QUIET)$(OBJCOPY) -i $<
	$(QUIET)mv $(OBJDIR)/$(BINARY_SPECIFIC_NAME)2.elf $(OBJDIR)/$(BINARY_SPECIFIC_NAME).elf

$(OBJDIR)/%: $(OBJDIR)/%.elf
	$(call SHOW,"6.12-COPY","$@","$<")

	$(QUIET)cp "$<" $@

$(OBJDIR)/%.iap: $(OBJDIR)/%.elf
	$(call SHOW,"6.13-COPY IAP","$@","$<")

	$(QUIET)$(OBJCOPY) -O binary -R .boot "$<" $@

$(TARGET_AXF): $(TARGET_ELF)
#$(OBJDIR)/%.axf: $(OBJDIR)/%.elf
	$(call SHOW,"6.14-COPY AXF","$@","$<")
	$(QUIET)$(POST_COMPILE_COMMAND)
	$(QUIET)$(COMMAND_COPY)

$(TARGET_UF2): $(TARGET_ELF)
$(OBJDIR)/%.uf2: $(OBJDIR)/%.elf
ifneq ($(COMMAND_UF2),)
	$(call SHOW,"6.15-COPY UF2",$@,.)

	$(QUIET)$(COMMAND_UF2)
endif # COMMAND_UF2

# Size of file
# ----------------------------------
#
ifeq ($(BOOL_SELECT_BOARD),1)

#    ifeq ($(TARGET_HEXBIN),$(TARGET_AXF))
    ifneq ($(COMMAND_SIZE),)
        FLASH_SIZE = $(COMMAND_SIZE)
        MAX_FLASH_BYTES = 'bytes used ('$(shell echo "scale=1; (100.0* $(shell $(FLASH_SIZE)))/$(MAX_FLASH_SIZE)" | bc)'% of '$(MAX_FLASH_SIZE)' maximum), '$(shell echo "$(MAX_FLASH_SIZE) - $(shell $(FLASH_SIZE))"|bc) 'bytes free ('$(shell echo "scale=1; 100-(100.0* $(shell $(FLASH_SIZE)))/$(MAX_FLASH_SIZE)"|bc)'%)'

        RAM_SIZE = 0 #

    else ifeq ($(TARGET_HEXBIN),$(TARGET_HEX))
#    FLASH_SIZE = $(SIZE) --target=ihex --totals $(TARGET_HEX) | grep TOTALS | tr '\t' . | cut -d. -f2 | tr -d ' '
        FLASH_SIZE = $(SIZE) --target=ihex --totals $(TARGET_HEX) | grep TOTALS | awk '{t=$$3 + $$2} END {print t}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3 + $$2} END {print t}'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_VXP))
        FLASH_SIZE = $(SIZE) $(TARGET_ELF) | sed '1d' | awk '{t=$$1 + $$2} END {print t}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3} END {print t}'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_BIN))
        FLASH_SIZE = $(SIZE) --target=binary --totals $(TARGET_BIN) | grep TOTALS | tr '\t' . | cut -d. -f2 | tr -d ' '
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3 + $$2} END {print t}'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_BIN2))
        FLASH_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$1 + $$2} END {print t}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3 + $$2} END {print t}'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_OUT))
        FLASH_SIZE = cat $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map | grep '^.text' | awk 'BEGIN { OFS = "" } {print "0x",$$4}' | xargs printf '%d'
        RAM_SIZE = cat $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME).map | grep '^.ebss' | awk 'BEGIN { OFS = "" } {print "0x",$$4}' | xargs printf '%d'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_DOT))
        FLASH_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$1} END {print t}'
#    FLASH_SIZE = ls -all $(TARGET_DOT) | awk '{print $$5}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3 + $$2} END {print t}'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_ELF))
        FLASH_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$1} END {print t}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3 + $$2} END {print t}'

# For uf2, check size on required elf 
    else ifeq ($(TARGET_HEXBIN),$(TARGET_UF2))
        FLASH_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$1} END {print t}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$3 + $$2} END {print t}'

    else ifeq ($(TARGET_HEXBIN),$(TARGET_MCU))
        FLASH_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$4} END {print t}'
        RAM_SIZE = $(SIZE) --totals $(TARGET_ELF) | sed '1d' | awk '{t=$$4} END {print t}'
    endif # COMMAND_SIZE

# Horrendous patch for non-standard ESP32 sizes
    ifeq ($(PLATFORM),esp32)
        RAM_SIZE = $(SIZE) -A $(TARGET_ELF) | grep -e ^.dram0 | awk '{t += $$2} END { print t }'
    endif # PLATFORM esp32
# Horrendous patch for Teensy 4.1 external SRAM
    ifeq ($(BOARD_TAG),teensy41)
        FLASH_SIZE = $(COMMAND_SIZE_FLASH)
        RAM_SIZE = $(COMMAND_SIZE_RAM)
    endif # BOARD_TAG teensy41

    ifeq ($(COMMAND_SIZE),)

    ifeq ($(MAX_FLASH_SIZE),)
        MAX_FLASH_SIZE = $(firstword $(call PARSE_BOARD,$(BOARD_TAG),upload.maximum_size))
    endif # MAX_FLASH_SIZE
    ifeq ($(MAX_RAM_SIZE),)
        MAX_RAM_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),upload.maximum_data_size)
    endif # MAX_RAM_SIZE
    ifeq ($(MAX_RAM_SIZE),)
        MAX_RAM_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),upload.maximum_ram_size)
    endif # MAX_RAM_SIZE
    ifeq ($(MAX_RAM_SIZE),)
        MAX_RAM_SIZE = $(call PARSE_BOARD,$(BOARD_TAG),upload.ram.maximum_size)
    endif # MAX_RAM_SIZE

    ifneq ($(MAX_FLASH_SIZE),)
#     MAX_FLASH_BYTES = 'bytes (of a '$(MAX_FLASH_SIZE)' byte maximum)'
        MAX_FLASH_BYTES = 'bytes used ('$(shell echo "scale=1; (100.0* $(shell $(FLASH_SIZE)))/$(MAX_FLASH_SIZE)" | bc)'% of '$(MAX_FLASH_SIZE)' maximum), '$(shell echo "$(MAX_FLASH_SIZE) - $(shell $(FLASH_SIZE))"|bc) 'bytes free ('$(shell echo "scale=1; 100-(100.0* $(shell $(FLASH_SIZE)))/$(MAX_FLASH_SIZE)"|bc)'%)'
    else
        MAX_FLASH_BYTES = bytes used
    endif # MAX_FLASH_BYTES

    ifneq ($(MAX_RAM_SIZE),)
#    MAX_RAM_BYTES = 'bytes (of a '$(MAX_RAM_SIZE)' byte maximum)'
        MAX_RAM_BYTES = 'bytes used ('$(shell echo "scale=1; (100.0* $(shell $(RAM_SIZE)))/$(MAX_RAM_SIZE)" | bc)'% of '$(MAX_RAM_SIZE)' maximum), '$(shell echo "$(MAX_RAM_SIZE) - $(shell $(RAM_SIZE))"|bc) 'bytes free ('$(shell echo "scale=1; 100-(100.0* $(shell $(RAM_SIZE)))/$(MAX_RAM_SIZE)"|bc)'%)'
    else
        MAX_RAM_BYTES = bytes used
    endif # MAX_RAM_BYTES

    endif # COMMAND_SIZE
endif # BOOL_SELECT_BOARD

# Additional features
# ----------------------------------
#
ifeq ($(MAKECMDGOALS),document)
    include $(MAKEFILE_PATH)/Doxygen.mk
endif # MAKECMDGOALS document

ifeq ($(MAKECMDGOALS),distribute)
    include $(MAKEFILE_PATH)/Doxygen.mk
endif # MAKECMDGOALS distribute

# ifeq ($(MAKECMDGOALS),debug)
#     include $(MAKEFILE_PATH)/Debug.mk
# endif # MAKECMDGOALS debug

ifeq ($(MAKECMDGOALS),style)
    include $(MAKEFILE_PATH)/Doxygen.mk
endif # MAKECMDGOALS style

ifeq ($(MAKECMDGOALS),share)
    include $(MAKEFILE_PATH)/Doxygen.mk
endif # MAKECMDGOALS share

# Release management
# ----------------------------------
#
include $(MAKEFILE_PATH)/About.mk

# List all variables
# ----------------------------------
# 
# $(info --- All old variables)
# $(foreach v, $(VARIABLES_OLD), $(info $(v) = $($(v))))
# 
# $(info --- All new variables)
# # In main makefile on the project, add 
# # VARIABLES_OLD := $(.VARIABLES)
# VARIABLES_NEW := $(.VARIABLES)
# $(foreach v, $(filter-out $(VARIABLES_OLD) VARIABLES_OLD,$(VARIABLES_NEW)), $(info $(v) = $($(v))))
# $(info ===)

# $(info >>> LOCAL_OBJS $(LOCAL_OBJS))
# $(info >>> LOCAL_ARCHIVES $(LOCAL_ARCHIVES))
# $(info >>> USER_ARCHIVES $(USER_ARCHIVES)) 
# $(info >>> TARGET_CORE_A $(TARGET_CORE_A)) 
# $(info >>> TARGET_A $(TARGET_A))

# Rules
# ----------------------------------
#
all: start_message clean before_compile compile after_compile reset raw_upload serial
	@echo "==== $(MESSAGE_TASK) done ===="

build: start_message before_compile compile after_compile
	@echo "==== $(MESSAGE_TASK) done ===="

compile: message_compile $(OBJDIR) $(TARGET_HEXBIN) $(TARGET_EEP) size
	@echo $(BOARD_TAG) > $(NEW_TAG)

    ifneq ($(TEENSY_F_CPU),)
		@echo $(TEENSY_F_CPU) >> $(NEW_TAG)
    endif # TEENSY_F_CPU

    ifeq ($(COMMAND_SIZE),)

		@echo '---- Size ----'
		@echo 'Estimated Flash  ' $(shell $(FLASH_SIZE)) $(MAX_FLASH_BYTES);
		@echo 'Estimated SRAM   ' $(shell $(RAM_SIZE)) $(MAX_RAM_BYTES);

#		@if [ $(shell $(FLASH_SIZE)) -gt $(MAX_FLASH_SIZE) ] ; then osascript -e 'tell application "System Events" to display dialog "Flash: $(shell $(FLASH_SIZE)) bytes used > $(MAX_FLASH_SIZE) available" buttons {"OK"} default button {"OK"} with icon POSIX file ("$(UTILITIES_PATH)/TemplateIcon.icns") with title "emCode" giving up after 5'; exit 2 ; fi
#		@if [ $(shell $(RAM_SIZE)) -gt $(MAX_RAM_SIZE) ] ; then osascript -e 'tell application "System Events" to display dialog "RAM: $(shell $(RAM_SIZE)) bytes used > $(MAX_RAM_SIZE) available " buttons {"OK"} default button {"OK"} with icon POSIX file ("$(UTILITIES_PATH)/TemplateIcon.icns") with title "emCode" giving up after 5'; exit 2 ; fi

    else

		@echo '---- Size ----'
		@echo 'Estimated Flash    ' $(shell $(FLASH_SIZE)) $(MAX_FLASH_BYTES);

    endif # COMMAND_SIZE

	@echo 'Elapsed time     ' $(shell $(UTILITIES_PATH)/emCode_chrono $(BUILDS_PATH) -s)

    ifneq ($(COMMAND_FINAL),)
		@echo '---- Final ----'
		$(QUIET)$(COMMAND_FINAL)
    endif # COMMAND_FINAL

$(OBJDIR):
	@echo "---- Build ----"
	@mkdir $(OBJDIR)

$(DEP_FILE): $(OBJDIR) $(DEPS)
	@echo "9-" $<
	@cat $(DEPS) > $(DEP_FILE)

# upload: start_message reset raw_upload
upload: reset raw_upload
	@echo "==== upload done ==== "

reset:
	@echo "---- Reset ----"
	@echo UPLOADER $(UPLOADER)

ifeq ($(BOARD_PORT),pgm)
else ifeq ($(UPLOADER),lightblue_loader_cli)
	-if [[ $$(ps aux | grep bin/bean) == *node* ]] ; then killall node ; fi

else ifeq ($(BOARD_PORT),ssh)
	-killall ssh

else
#		-killall screen
#		-pkill screen
    ifeq ($(DUAL_USB),)
		-screen -X kill
		-screen -wipe
		sleep 1
    else
		@echo Dual USB available
    endif # DUAL_USB
	
    ifeq ($(UPLOADER),stlink)

    else ifeq ($(UPLOADER),ozone)

    else ifeq ($(UPLOADER),dfu-util)
		$(call SHOW,"9.1-RESET",$(UPLOADER_RESET))

		$(UPLOADER_RESET)
		@sleep 1
    endif # UPLOADER

    ifneq ($(UPLOADER),ozone)
      ifdef USB_RESET
        ifneq ($(AVRDUDE_PORT),) 
			$(call SHOW,"9.2-RESET","USB 1200")
			-stty -F $(AVRDUDE_PORT) 1200
        endif # AVRDUDE_PORT
#		$(USB_RESET) $(USED_SERIAL_PORT)
        ifneq ($(DELAY_BEFORE_UPLOAD),)
		$(QUIET)sleep $(DELAY_BEFORE_UPLOAD)
        endif # DELAY_BEFORE_UPLOAD
#		@ls $(USED_SERIAL_PORT)
      endif # USB_RESET
    endif # UPLOADER
endif # BOARD_PORT

# stty on Mac OS likes -F, but on Debian it likes -f redirecting
# stdin/out appears to work but generates a spurious error on MacOS at
# least. Perhaps it would be better to just do it in perl ?
#		@if [ -z "$(AVRDUDE_PORT)" ]; then \
#			echo "No Arduino-compatible TTY device found -- exiting"; exit 2; \
#			fi
#		for STTYF in 'stty --file' 'stty -F' 'stty <' ; \
#		  do $$STTYF /dev/tty >/dev/null 2>/dev/null && break ; \
#		done ;\
#		$$STTYF $(AVRDUDE_PORT)  hupcl ;\
#		(sleep 0.1 || sleep 1)     ;\
#		$$STTYF $(AVRDUDE_PORT) -hupcl

raw_upload:
	@echo "---- Upload ----"

# ifneq ($(USB_RESET),)
#		$(call SHOW,"10.0-UPLOAD")
#
#		$(QUIET)$(USB_RESET)
# endif

# ifeq ($(UPLOADER),jlink)
# ifneq ($(COMMAND_PREPARE),)
# 	$(call SHOW,"10.42-PREPARE",$(UPLOADER))
# 
# 	@$(COMMAND_PREPARE)
# endif # COMMAND_PREPARE

ifneq ($(COMMAND_POWER),)
	@echo '. Board powered by J-Link'
	$(COMMAND_POWER)
	@sleep 1
endif # COMMAND_POWER
# endif # UPLOADER jlink

ifeq ($(MESSAGE_RESET),1)
	$(call SHOW,"10.1-UPLOAD",$(UPLOADER))

	@zenity --width=240 --title "emCode" --text "Press the RESET button on the board $(CONFIG_NAME) and then click OK." --info
#        --notification --window-icon="$(UTILITIES_PATH)/TemplateIcon.icns"
#		@osascript -e 'tell application "System Events" to display dialog "Press the RESET button on the board $(CONFIG_NAME) and then click OK." buttons {"OK"} default button {"OK"} with icon POSIX file ("$(UTILITIES_PATH)/TemplateIcon.icns") with title "emCode"'
# Give Mac OS X enough time for enumerating the USB ports
	@sleep 3
endif # MESSAGE_RESET

ifneq ($(COMMAND_PREPARE),)
	$(call SHOW,"10.70-PREPARE",$(UPLOADER))

	$(QUIET)$(COMMAND_PREPARE)
endif # COMMAND_PREPARE

ifeq ($(UPLOADER),lightblue_loader_cli)
# 	$(call SHOW,"10.2-UPLOAD",$(UPLOADER))
#     ifeq ($(BEAN_NAME),)
# 		$(eval BEAN_NAME = $(shell grep ^BEAN_NAME '$(BOARD_FILE)' | cut -d= -f 2- | sed 's/^ //'))
#     endif # BEAN_NAME
# 	$(QUIET)$(COMMAND_UPLOAD)

else ifeq ($(strip $(COMMAND_UPLOAD)),0)
	$(call SHOW,"10.0-UPLOAD",$(UPLOADER))

else ifneq ($(COMMAND_UPLOAD),)
	$(call SHOW,"10.80-UPLOAD",$(UPLOADER))

    ifneq ($(DELAY_BEFORE_UPLOAD),)
		$(QUIET)sleep $(DELAY_BEFORE_UPLOAD)
    endif # DELAY_BEFORE_UPLOAD

    ifneq ($(MESSAGE_UPLOAD),)
		@$(MESSAGE_UPLOAD)
    endif # MESSAGE_UPLOAD

	$(QUIET)$(COMMAND_UPLOAD)

    ifneq ($(DELAY_AFTER_UPLOAD),)
		$(QUIET)sleep $(DELAY_AFTER_UPLOAD)
    endif # DELAY_AFTER_UPLOAD

else ifeq ($(BOARD_PORT),pgm)
	$(call SHOW,"10.3-UPLOAD",$(UPLOADER))

	@if [ -f $(UTILITIES_PATH)/emCode_debug ]; then export PROJECT_EXTENSION=$(PROJECT_EXTENSION) ; export UPLOADER=$(UPLOADER) ; export JLINK_POWER=$(JLINK_POWER) ; export BUILDS_PATH='$(BUILDS_PATH_SPACE)' ; $(UTILITIES_PATH)/emCode_debug '$(BUILDS_PATH_SPACE)' ; fi;
	@osascript -e 'tell application "Terminal" to do script "$(MDB) \"$(BUILDS_PATH_SPACE)/mdb.txt\""'

else ifeq ($(BOARD_PORT),ssh)
	$(call SHOW,"10.4-UPLOAD",$(UPLOADER))

    ifeq ($(SSH_ADDRESS),)
		$(eval SSH_ADDRESS = $(shell grep ^SSH_ADDRESS '$(CURRENT_DIR)/Makefile' | cut -d= -f 2- | sed 's/^ //'))
    endif # SSH_ADDRESS

    ifeq ($(SSH_ADDRESS),)
    SSH_ADDRESS := $(shell zenity --width=240 --entry --title "emCode" --text "Enter IP address" --entry-text "192.168.1.11")
    endif # SSH_ADDRESS

    ifeq ($(SSH_PASSWORD),)
		$(eval SSH_ADDRESS = $(shell grep ^SSH_PASSWORD '$(CURRENT_DIR)/Makefile' | cut -d= -f 2- | sed 's/^ //'))
    endif # SSH_PASSWORD

    ifeq ($(SSH_ADDRESS),)
		@echo 'SSH_ADDRESS not defined'
		exit 2
    endif # SSH_ADDRESS

    ifeq ($(SSH_PASSWORD),)
		@echo 'SSH_PASSWORD not defined'
		exit 2
    endif # SSH_PASSWORD

    ifneq ($(filter $(BOARD_TAG),yun),)
		$(call SHOW,"10.5-UPLOAD",$(UPLOADER))

		@echo "Uploading 1/3"
		@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' scp $(TARGET_HEX) root@$(SSH_ADDRESS):"/tmp/sketch.hex"

		@echo "Uploading 2/3"
		@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' ssh root@$(SSH_ADDRESS) '/usr/bin/merge-sketch-with-bootloader.lua /tmp/sketch.hex'
		@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' ssh root@$(SSH_ADDRESS) '/usr/bin/kill-bridge'

		@echo "Uploading 3/3"
		@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' ssh root@$(SSH_ADDRESS) '/usr/bin/run-avrdude /tmp/sketch.hex';
		@sleep 1

        ifneq ($(wildcard www/*),)
			@echo "Uploading www folder"
			@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' ssh root@$(SSH_ADDRESS) 'mkdir -p /mnt/sda1/arduino/www/$(PROJECT_NAME_AS_IDENTIFIER)'
			@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' scp -r www/* root@$(SSH_ADDRESS):/mnt/sda1/arduino/www/$(PROJECT_NAME_AS_IDENTIFIER)
			@open http://$(SSH_ADDRESS)/sd/$(PROJECT_NAME_AS_IDENTIFIER)
        endif # www/*

    else ifneq ($(filter $(BOARD_TAG),tian),)
		$(call SHOW,"10.5-UPLOAD",$(UPLOADER))

		@echo "Uploading 1/2"
		@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' scp $(TARGET_HEX) root@$(SSH_ADDRESS):"/tmp/sketch.hex"

		@echo "Uploading 2/2"
		@$(UTILITIES_PATH)/sshpass -p '$(SSH_PASSWORD)' ssh root@$(SSH_ADDRESS) '/usr/bin/run-avrdude /tmp/sketch.hex'
		@sleep 1

    else ifeq ($(BOARD_TAG),izmir_ec)
		$(call SHOW,"10.6-UPLOAD",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) -exec"'
		cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) -exec

    else ifeq ($(BOARD_TAG),izmir_ec_yocto)
        ifneq ($(MAKECMDGOALS),debug)

		$(call SHOW,"10.7-UPLOAD",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) -exec"'
		cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) -exec
        endif # MAKECMDGOALS debug

    else ifeq ($(BOARD_TAG),bplus)
        ifneq ($(MAKECMDGOALS),debug)
			$(call SHOW,"10.41-UPLOAD",$(UPLOADER))
#		echo $(UTILITIES_PATH)/uploader_raspi_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) $(BUILDS_PATH) -exec
	ifeq ($(MAKECMDGOALS),upload)
#			osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_raspi_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) $(BUILDS_PATH) -upload"'
				cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_raspi_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) $(BUILDS_PATH) -upload
            else
#			osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_raspi_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) $(BUILDS_PATH) -exec"'
				cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_raspi_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) $(BUILDS_PATH) -exec
            endif # upload
        endif # debug
#    endif

    else ifeq ($(BOARD_TAG),BeagleBoneDebian)
        ifneq ($(MAKECMDGOALS),debug)

		$(call SHOW,"10.8-UPLOAD",$(UPLOADER))

		osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) -exec"'
        endif # MAKECMDGOALS debug

    else ifeq ($(BOARD_TAG),izmir_ec_yocto_MCU)
		$(call SHOW,"10.40-UPLOAD",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); export FIRMWARE_TOOLS_PATH=$(UTILITIES_PATH) ; export SSH_USER=root ; export SSH_IP_ADDR=$(SSH_ADDRESS) ; export SSH_PASSWORD=$(SSH_PASSWORD) ; bash $(UTILITIES_PATH)/download.sh install $(OBJDIR)"'
		echo $(OBJDIR)

		osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_mcu.sh $(SSH_ADDRESS) $(SSH_PASSWORD) /lib/firmware $(OBJDIR)/intel_mcu.bin \"$(MCU_CONFIGURATION)\""'
#		echo "-- 1/3 Preparing"
#		$(UTILITIES_PATH)/ssh_password $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOVE) /lib/firmware/intel_mcu.bin

#		echo "-- 2/3 Uploading"
#		$(UTILITIES_PATH)/scp_password $(SSH_ADDRESS) $(SSH_PASSWORD) $(BUILDS)/intel_mcu.bin /lib/firmware/intel_mcu.bin

#		echo "-- 3/3 Running"
#		$(UTILITIES_PATH)/ssh_password $(SSH_ADDRESS) $(SSH_PASSWORD) $(COMMAND)
#		$(UTILITIES_PATH)/ssh_password $(SSH_ADDRESS) $(SSH_PASSWORD) reboot

#    endif # BOARD_TAG
else ifeq ($(UPLOADER),izmir_tty)
	$(call SHOW,"10.9-UPLOAD",$(UPLOADER))

		bash $(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_ELF) $(USED_SERIAL_PORT)

else ifeq ($(UPLOADER),micronucleus)
		$(call SHOW,"10.10-UPLOAD",$(UPLOADER))

		@zenity --width=240 --title "emCode" --text "Click OK and plug the Digispark board into the USB port." --info
#		osascript -e 'tell application "System Events" to display dialog "Click OK and plug the Digispark board into the USB port." buttons {"OK"} with icon POSIX file ("$(UTILITIES_PATH)/TemplateIcon.icns") with title "emCode"'

		$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -P$(USED_SERIAL_PORT) -Uflash:w:$(TARGET_HEX):i

else ifeq ($(PLATFORM),RedBearLab)
		$(call SHOW,"10.11-UPLOAD",$(UPLOADER))

		sleep 2
        ifeq ($(UPLOADER),spark_wifi)

            ifeq ($(SPARK_NAME),)
				$(eval SPARK_NAME = $(shell $(UPLOADER_EXEC) list | tr '\[' '\n' | grep 'online' | cut -d\] -f1 ))
            endif # SPARK_NAME

			@if [ -z '$(SPARK_NAME)' ] ; then echo 'ERROR No core found' ; echo 'Have you run Particle cloud login?'; exit 1 ; fi

			@echo 'Found core $(SPARK_NAME)'

			$(UPLOADER_EXEC) $(UPLOADER_OPTS) "$(TARGET_BIN)"
        else
			$(QUIET)$(OBJCOPY) -O ihex -I binary $(TARGET_BIN) $(TARGET_HEX)
			$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -P$(USED_SERIAL_PORT) -Uflash:w:$(TARGET_HEX):i
        endif # UPLOADER
	sleep 2

    else ifeq ($(UPLOADER),avrdude)

        ifeq ($(AVRDUDE_SPECIAL),1)
			$(call SHOW,"10.12-UPLOAD",$(UPLOADER) $(AVRDUDE_PROGRAMMER))

            ifeq ($(AVR_FUSES),1)
				$(AVRDUDE_EXEC) -p$(AVRDUDE_MCU) -C$(AVRDUDE_CONF) -c$(AVRDUDE_PROGRAMMER) -e -U lock:w:$(ISP_LOCK_FUSE_PRE):m -U hfuse:w:$(ISP_HIGH_FUSE):m -U lfuse:w:$(ISP_LOW_FUSE):m -U efuse:w:$(ISP_EXT_FUSE):m
            endif # AVR_FUSES
			$(AVRDUDE_EXEC) -p$(AVRDUDE_MCU) -C$(AVRDUDE_CONF) -c$(AVRDUDE_PROGRAMMER) $(AVRDUDE_OTHER_OPTIONS) -U flash:w:$(TARGET_HEX):i
            ifeq ($(AVR_FUSES),1)
            	$(AVRDUDE_EXEC) -p$(AVRDUDE_MCU) -C$(AVRDUDE_CONF) -c$(AVRDUDE_PROGRAMMER) -U lock:w:$(ISP_LOCK_FUSE_POST):m
            endif # AVR_FUSES

        else
			$(call SHOW,"10.13-UPLOAD",$(UPLOADER))

            ifeq ($(USED_SERIAL_PORT),)
				$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -Uflash:w:$(TARGET_HEX):i
            else
				$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_OPTS) -P$(USED_SERIAL_PORT) -Uflash:w:$(TARGET_HEX):i
            endif # USED_SERIAL_PORT
        ifeq ($(AVRDUDE_SPECIAL),avr109)
			sleep 2
        endif # AVRDUDE_SPECIAL

    endif # AVRDUDE_SPECIAL

else ifeq ($(UPLOADER),bossac)
	$(call SHOW,"10.14-UPLOAD",$(UPLOADER))

    ifneq ($(DELAY_BEFORE_UPLOAD),)
		$(QUIET)sleep $(DELAY_BEFORE_UPLOAD)
    endif # DELAY_BEFORE_UPLOAD
	$(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_BIN) -R

else ifeq ($(UPLOADER),openocd)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.15-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) $(UPLOADER_OPTS) -c "program $(TARGET_BIN) $(UPLOADER_COMMAND)"
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),mspdebug)
		$(call SHOW,"10.16-UPLOAD",$(UPLOADER))

    ifeq ($(UPLOADER_PROTOCOL),tilib)
		cd $(UPLOADER_PATH); ./mspdebug $(UPLOADER_OPTS) "$(UPLOADER_COMMAND) $(CURRENT_DIR_SPACE)/$(TARGET_HEX)";

    else
		$(UPLOADER_EXEC) $(UPLOADER_OPTS) "$(UPLOADER_COMMAND) $(TARGET_HEX)"
    endif # UPLOADER_PROTOCOL tilib

else ifeq ($(UPLOADER),lm4flash)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.17-UPLOAD",$(UPLOADER))

		-killall openocd
		$(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_BIN)
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),cc3200serial)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.18-UPLOAD",$(UPLOADER))

		-killall openocd
#		@cp -r $(APP_TOOLS_PATH)/dll ./dll
		$(UPLOADER_EXEC) $(USED_SERIAL_PORT) $(TARGET_BIN)
#		@if [ -d ./dll ]; then $(REMOVE) -r ./dll; fi
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),DSLite)
#    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.19-UPLOAD",$(UPLOADER))

#		-killall openocd
		$(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_ELF)
#		@if [ -d ./dll ]; then $(REMOVE) -r ./dll; fi
#    endif

else ifeq ($(UPLOADER),serial_loader2000)
		$(call SHOW,"10.20-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) -f $(TARGET_TXT) $(UPLOADER_OPTS) -p $(USED_SERIAL_PORT)

else ifeq ($(UPLOADER),dfu-util)
		$(call SHOW,"10.21-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) $(UPLOADER_OPTS) -D $(TARGET_BIN) -R
		sleep 4

else ifeq ($(UPLOADER),teensy_flash)
		$(call SHOW,"10.22-UPLOAD",$(UPLOADER))

		$(TEENSY_POST_COMPILE) -file=$(basename $(notdir $(TARGET_HEX))) -path="$(BUILDS_PATH)" -tools=$(abspath $(TEENSY_FLASH_PATH)) -board=$(call PARSE_BOARD,$(BOARD_TAG),build.board)
		sleep 2
		$(TEENSY_REBOOT)
		sleep 2
		-killall teensy

else ifeq ($(UPLOADER),lightblue_loader)
		$(call SHOW,"10.23-UPLOAD",$(UPLOADER))

		$(LIGHTBLUE_POST_COMPILE) -board="$(BOARD_TAG)" -tools="$(abspath $(LIGHTBLUE_FLASH_PATH))" -path="$(dir $(abspath $(TARGET_HEX)))" -file="$(basename $(notdir $(TARGET_HEX)))"
		sleep 2

else ifeq ($(UPLOADER),izmirdl)
		$(call SHOW,"10.24-UPLOAD",$(UPLOADER))

		bash $(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_ELF) $(USED_SERIAL_PORT)
#		osascript -e 'tell application "Terminal" to do script "cd $(CURRENT_DIR) ; $(UPLOADER_EXEC) $(UPLOADER_OPTS) $(TARGET_ELF) $(USED_SERIAL_PORT)"'

else ifeq ($(UPLOADER),spark_usb)
		$(call SHOW,"10.25-UPLOAD",$(UPLOADER))

		$(eval SPARK_NAME = $(shell $(UPLOADER_EXEC) -l | grep 'serial' | cut -d\= -f8 | sed 's/\"//g' | head -1))

		@if [ -z '$(SPARK_NAME)' ] ; then echo 'ERROR No DFU found' ; exit 1 ; fi
		@echo 'DFU found $(SPARK_NAME)'

		$(PREPARE_EXEC) $(PREPARE_OPTS) "$(TARGET_BIN)"
		$(UPLOADER_EXEC) $(UPLOADER_OPTS) "$(TARGET_BIN)"

else ifeq ($(UPLOADER),jlink)
    ifneq ($(MAKECMDGOALS),debug)
        ifneq ($(COMMAND_PREPARE),)
			$(call SHOW,"10.26-PREPARE",$(UPLOADER))

			@$(COMMAND_PREPARE)
        endif # COMMAND_PREPARE

        ifneq ($(COMMAND_POWER),)
			@echo '. Board powered by J-Link'
			$(COMMAND_POWER)
			@sleep 1
        endif # COMMAND_POWER

		$(call SHOW,"10.27-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) $(UPLOADER_OPTS)
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),ozone)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.38-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) $(UPLOADER_OPTS)
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),spark_wifi)
	$(call SHOW,"10.39-UPLOAD",$(UPLOADER))

    ifeq ($(SPARK_NAME),)
		$(eval SPARK_NAME = $(shell $(UPLOADER_EXEC) list | tr '\[' '\n' | grep 'online' | cut -d\] -f1 ))
    endif # SPARK_NAME

		@if [ -z '$(SPARK_NAME)' ] ; then echo 'ERROR No core found' ; echo 'Have you run Particle cloud login?'; exit 1 ; fi

		@echo 'Found core $(SPARK_NAME)'

		$(UPLOADER_EXEC) $(UPLOADER_OPTS) "$(TARGET_BIN)"
		sleep 60

else ifeq ($(UPLOADER),robotis-loader)
		$(call SHOW,"10.28-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) $(USED_SERIAL_PORT) $(TARGET_BIN)

else ifeq ($(UPLOADER),RFDLoader)
		$(call SHOW,"10.29-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) -q $(USED_SERIAL_PORT) $(TARGET_HEX)

else ifeq ($(UPLOADER),PushTool)
		$(call SHOW,"10.30-UPLOAD",$(UPLOADER))

		$(UPLOADER_EXEC) $(UPLOADER_OPTS) -b $(USED_SERIAL_PORT) -p $(TARGET_VXP)

else ifeq ($(UPLOADER),cp_uf2)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.31-UPLOAD",$(UPLOADER))

        ifneq ($(DELAY_BEFORE_UPLOAD),)
		    $(QUIET)sleep $(DELAY_BEFORE_UPLOAD)
        endif # DELAY_BEFORE_UPLOAD

		cp "$(TARGET_BIN_CP)" "$(BOARD_VOLUME)"

# Waiting for USB enumeration
		@sleep 5
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),cp_hex)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.42-UPLOAD",$(UPLOADER))

        ifneq ($(DELAY_BEFORE_UPLOAD),)
		    $(QUIET)sleep $(DELAY_BEFORE_UPLOAD)
        endif # DELAY_BEFORE_UPLOAD

		cp "$(TARGET_BIN_CP)" "$(BOARD_VOLUME)"
		@sleep 5
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),cp_bin)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.43-UPLOAD",$(UPLOADER))
        
        ifneq ($(DELAY_BEFORE_UPLOAD),)
		    $(QUIET)sleep $(DELAY_BEFORE_UPLOAD)
        endif # DELAY_BEFORE_UPLOAD

		cp "$(TARGET_BIN_CP)" "$(BOARD_VOLUME)"
		@sleep 5
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),stlink)
    ifneq ($(MAKECMDGOALS),debug)
		$(call SHOW,"10.32-UPLOAD",$(UPLOADER))

		$(UPLOADER_PATH)/$(UPLOADER_EXEC) write $(TARGET_BIN) $(UPLOADER_OPTS)
    endif # MAKECMDGOALS debug

else ifeq ($(UPLOADER),BsLoader)
	$(call SHOW,"10.33-UPLOAD",$(UPLOADER))

#	echo 'USED_SERIAL_PORT = '$(USED_SERIAL_PORT)
	$(UPLOADER_EXEC) $(TARGET_HEX) $(USED_SERIAL_PORT) $(UPLOADER_OPTS)

else ifeq ($(UPLOADER),esptool)
	$(call SHOW,"10.34-UPLOAD",$(UPLOADER))

#	echo 'USED_SERIAL_PORT = '$(USED_SERIAL_PORT)
	$(UPLOADER_EXEC) $(UPLOADER_OPTS) -cp $(USED_SERIAL_PORT) -ca 0x$(ADDRESS_BIN1) -cf $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)_$(ADDRESS_BIN1).bin

else ifeq ($(UPLOADER),esptool.py)
	$(call SHOW,"10.35-UPLOAD",$(UPLOADER))

#	echo 'USED_SERIAL_PORT = '$(USED_SERIAL_PORT)
	$(UPLOADER_EXEC) $(UPLOADER_OPTS) --port $(USED_SERIAL_PORT) write_flash 0x00000 $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)_00000.bin 0x$(ADDRESS_BIN2) $(BUILDS_PATH)/$(BINARY_SPECIFIC_NAME)_$(ADDRESS_BIN2).bin
else
	$(error No valid uploader)
endif # UPLOADER

ifeq ($(MESSAGE_POST_RESET),1)
	$(call SHOW,"10.36-UPLOAD",$(UPLOADER))

	@zenity --width=240 --title "emCode" --text "Press the RESET button on the board $(CONFIG_NAME) and then click OK." --info
#		@osascript -e 'tell application "System Events" to display dialog "Press the RESET button on the board $(CONFIG_NAME) and then click OK." buttons {"OK"} default button {"OK"} with icon POSIX file ("$(UTILITIES_PATH)/TemplateIcon.icns") with title "emCode"'
# Give Mac OS X enough time for enumerating the USB ports
	@sleep 3
endif # MESSAGE_POST_RESET

# Command after upload
ifneq ($(COMMAND_CONCLUDE),)
	$(call SHOW,"10.90-CONCLUDE",$(UPLOADER))

	$(QUIET)$(COMMAND_CONCLUDE)
endif # COMMAND_CONCLUDE

ispload: $(TARGET_HEX)
	@echo "---- ISP upload ----"
ifeq ($(UPLOADER),avrdude)
	$(call SHOW,"10.37-UPLOAD",$(UPLOADER))

	$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) -e \
			-U lock:w:$(ISP_LOCK_FUSE_PRE):m \
			-U hfuse:w:$(ISP_HIGH_FUSE):m \
			-U lfuse:w:$(ISP_LOW_FUSE):m \
			-U efuse:w:$(ISP_EXT_FUSE):m
	$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) -D \
			-U flash:w:$(TARGET_HEX):i
	$(AVRDUDE_EXEC) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) \
			-U lock:w:$(ISP_LOCK_FUSE_POST):m
endif # UPLOADER avrdude

serial: reset
ifneq ($(NO_SERIAL_CONSOLE),1)
ifneq ($(NO_SERIAL_CONSOLE),true)
	@echo "---- Serial ----"
    ifneq ($(DELAY_BEFORE_SERIAL),)
		@sleep $(DELAY_BEFORE_SERIAL)
    endif # DELAY_BEFORE_SERIAL

    ifneq ($(COMMAND_SERIAL),)
		$(call SHOW,"11.90-SERIAL",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "$(COMMAND_SERIAL)"' -e 'tell application "Terminal" to activate'
		$(COMMAND_SERIAL)

    else ifeq ($(BOARD_PORT),ssh)
        ifeq ($(BOARD_TAG),yun)
			$(call SHOW,"11.1-SERIAL",$(UPLOADER))

#			osascript -e 'tell application "Terminal" to do script "$(UTILITIES_PATH)/sshpass -p $(SSH_PASSWORD) ssh root@$(SSH_ADDRESS) exec telnet localhost 6571"' -e 'tell application "Terminal" to activate'
			$(UTILITIES_PATH)/sshpass -p $(SSH_PASSWORD) ssh root@$(SSH_ADDRESS) exec telnet localhost 6571
        endif # BOARD_TAG

    else ifeq ($(AVRDUDE_NO_SERIAL_PORT),1)
		@echo "The programmer provides no serial port"

    else ifeq ($(UPLOADER),teensy_flash)
		$(call SHOW,"11.2-SERIAL",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "$(SERIAL_EXEC) $$(ls $(BOARD_PORT)) $(SERIAL_BAUDRATE)"' -e 'tell application "Terminal" to activate'
		$(SERIAL_EXEC) $$(ls $(BOARD_PORT)) $(SERIAL_BAUDRATE)

    else ifeq ($(UPLOADER),lightblue_loader_cli)
		$(call SHOW,"11.71-SERIAL",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "$(SERIAL_EXEC)"' -e 'tell application "Terminal" to activate'
		$(SERIAL_EXEC)  

    else ifeq ($(UPLOADER),lightblue_loader)
		$(call SHOW,"11.3-SERIAL",$(UPLOADER))

#		osascript -e 'tell application "Terminal" to do script "$(SERIAL_EXEC) $$(ls $(BOARD_PORT)) $(SERIAL_BAUDRATE)"' -e 'tell application "Terminal" to activate'
		$(SERIAL_EXEC) $$(ls $(BOARD_PORT)) $(SERIAL_BAUDRATE)

    else ifneq ($(USED_SERIAL_PORT),)
        ifneq ($(DUAL_USB),)
            ifneq ($(CURRENT_EXEC),)
				$(call SHOW,"11.41-SERIAL",$(UPLOADER))

				@echo Dual USB, console $(SERIAL_EXEC) already running
            else
				$(call SHOW,"11.42-SERIAL",$(UPLOADER))

				$(SERIAL_EXEC) $(USED_SERIAL_PORT) $(SERIAL_BAUDRATE)
#				osascript -e 'tell application "Terminal" to do script "$(SERIAL_EXEC) $(USED_SERIAL_PORT) $(SERIAL_BAUDRATE)"' -e 'tell application "Terminal" to activate'
            endif # CURRENT_EXEC
        else
			$(call SHOW,"11.43-SERIAL",$(UPLOADER))

			$(SERIAL_EXEC) $(USED_SERIAL_PORT) $(SERIAL_BAUDRATE)
#			osascript -e 'tell application "Terminal" to do script "$(SERIAL_EXEC) $(USED_SERIAL_PORT) $(SERIAL_BAUDRATE)"' -e 'tell application "Terminal" to activate'
        endif # DUAL_USB
		@echo $(USED_SERIAL_PORT) > $(NEW_TAG)

    else ifeq ($(UPLOADER),jlink)
        ifneq ($(JLINK_SERIAL),)
			$(call SHOW,"11.44-SERIAL",$(UPLOADER))

            $(SERIAL_EXEC) $(JLINK_SERIAL) $(SERIAL_BAUDRATE)
#			osascript -e 'tell application "Terminal" to do script "$(SERIAL_EXEC) $(JLINK_SERIAL) $(SERIAL_BAUDRATE)"' -e 'tell application "Terminal" to activate'
        endif # JLINK_SERIAL
    else
		@echo "No serial port available"
    endif # COMMAND_SERIAL
endif # NO_SERIAL_CONSOLE
endif # NO_SERIAL_CONSOLE

clean:
	@if [ ! -d $(OBJDIR) ]; then mkdir -p $(OBJDIR); fi
	@echo "nil" > $(OBJDIR)/nil
	@echo "---- Clean ----"
	@if [ -f $(OBJDIR)/Serial.txt ] ; then cp $(OBJDIR)/Serial.txt ./Serial.txt ; fi
	-@$(REMOVE) -r $(OBJDIR)/*
	@mkdir -p $(OBJDIR)
	@if [ -f ./Serial.txt ] ; then mv ./Serial.txt $(OBJDIR)/Serial.txt ; fi

changed:
	@echo "---- Clean changed ----"
ifeq ($(BOOL_CHANGED_BOARD),1)
	@if [ ! -d $(OBJDIR) ]; then mkdir $(OBJDIR); fi
	@echo "nil" > $(OBJDIR)/nil
	@if [ -f $(OBJDIR)/Serial.txt ] ; then cp $(OBJDIR)/Serial.txt ./Serial.txt ; fi
	@$(REMOVE) -r $(OBJDIR)/*
	@mkdir -p $(OBJDIR)
	@if [ -f ./Serial.txt ] ; then mv ./Serial.txt $(OBJDIR)/Serial.txt ; fi
	-@killall $(SERIAL_EXEC)
	@echo "Remove all"
else
#		$(REMOVE) $(LOCAL_OBJS)
	@for f in $(LOCAL_OBJS) ; do if [ -f $$f ] ; then $(REMOVE) $$f ; fi ; done
	@for d in $(LOCAL_LIBS_LIST) ; do if [ -d $(BUILDS_PATH)/$$d ] ; then $(REMOVE) -r $(BUILDS_PATH)/$$d ; fi ; done
	@echo "Remove local only"
	@if [ -f $(OBJDIR)/$(BINARY_SPECIFIC_NAME).elf ] ; then $(REMOVE) $(OBJDIR)/$(BINARY_SPECIFIC_NAME).* ; fi ;
endif # BOOL_CHANGED_BOARD

depends: $(DEPS)
	@echo "---- Depends ----"
	@cat $(DEPS) > $(DEP_FILE)

# Archive rules
# ----------------------------------
#
do_archive:
#		@echo .
#		@echo "==== Archive ===="
#		@echo $(LOCAL_LIBS_LIST)
ifneq ($(BOOL_CHANGED_BOARD),0)
	$(call SHOW,"7.0-ARCHIVE","Build required")

	$(QUIET)make build -j SELECTED_BOARD=$(SELECTED_BOARD) HIDE_INFO=true USE_ARCHIVES=false
endif

#		@echo ". LOCAL_LIBS_LIST_TOP= "$(LOCAL_LIBS_LIST_TOP)
#		@echo ". BUILDS_PATH= "$(BUILDS_PATH)
#		@echo ". MCU= "$(MCU)

	@echo "---- Generate ----"
#		@echo .$(LOCAL_LIBS_LIST).
# Old
#		$(QUIET)for f in $(LOCAL_LIBS_LIST_TOP) ; do if [ -d $(BUILDS_PATH)/$$f ] ; then $(AR) rcs $$f/$$f.a $$(find $(BUILDS_PATH)/$$f/ -name *.o) ; printf '%-16s\t%s\r\n' "7.1-ARCHIVE" $$f/$$f.a ; echo $(BOARD_TAG) > $$f/$(BOARD_TAG).board ; fi ; done ;
# New
	$(QUIET)for f in $(LOCAL_LIBS_LIST_TOP) ; do if [ -d $(BUILDS_PATH)/$$f ] ; then mkdir -p $$f/src/$(MCU) ; $(AR) rcs $$f/src/$(MCU)/lib$$f.a $$(find $(BUILDS_PATH)/$$f/ -name *.o) ; printf '%-16s  %s\r\n' "7.1-ARCHIVE" $$f/src/$(MCU) ; fi ; done ;

# Old
#		@echo "---- Rename ----"
#		@for f in $(LOCAL_LIBS_LIST) ; do find $$f -name '*.cpp' -exec sh -c 'printf "%-16s\t%s to %s\r\n" "7.2-RENAME"  "$$0" "$${0%.cpp}._cpp"' {} \; ; done ;
#		@for f in $(LOCAL_LIBS_LIST) ; do find $$f -name '*.cpp' -exec sh -c 'mv "$$0" "$${0%.cpp}._cpp"' {} \; ; done ;
#		@for f in $(LOCAL_LIBS_LIST) ; do find $$f/ -name '*.c' -exec sh -c 'mv "$$0" "$${0%.c}._c"' {} \; ; done ;
# New
	$(QUIET)for f in $(LOCAL_LIBS_LIST_TOP) ; do if [ -d $(BUILDS_PATH)/$$f ] && [ ! -f $$f/library.properties ] ; then printf '%-16s  %s\r\n' "7.2-ARCHIVE" $$f/library.properties ; printf "name=$$f" > $$f/library.properties ; sed -i '/^$$/d' $$f/library.properties ; fi ; done ;
	@echo "---- Update ----"
	$(QUIET)for f in $(LOCAL_LIBS_LIST_TOP) ; do if [ -d $(BUILDS_PATH)/$$f ] ; then printf '%-16s  %s\r\n' "7.3-ARCHIVE" $$f/library.properties ; sed -i -z 's:dot_a_linkage=.*::g' $$f/library.properties ; sed -i -z 's:precompiled=.*::g' $$f/library.properties ; sed -i -z 's:FLAGS_LD=.*::g' $$f/library.properties ; printf "\nprecompiled=true\nldflags=-l$$f" >> $$f/library.properties ; sed -i '/^$$/d' $$f/library.properties ; fi ; done ;
#		@echo "==== Archive done ===="

unarchive:
	@echo .
	@echo "==== Unarchive ===="
# Old
# #		@echo $(LOCAL_LIBS_LIST)
	@echo "---- Remove ----"
# 		@for f in $(LOCAL_LIBS_LIST_TOP) ; do find $$f -name '*.a' -exec printf "%-16s\t%s\r\n" "7.3-UNARCHIVE" '{}' \; ; done ; 
# 		@for f in $(LOCAL_LIBS_LIST_TOP) ; do find $$f -name "*.a" -delete ; done ;
# 		@for f in $(LOCAL_LIBS_LIST_TOP) ; do find $$f/ -name '*.board' -delete ; done ;
#		@echo "---- Rename ----"
# 		@for f in $(LOCAL_LIBS_LIST) ; do find $$f -name '*._cpp' -exec sh -c 'printf "%-16s\t%s to %s\r\n" "7.4-RENAME"  "$$0" "$${0%._cpp}.cpp"' {} \; ; done ;
# #		@for f in $(LOCAL_LIBS_LIST) ; do find $$f -name '*._cpp' -exec sh -c 'echo "$$0" to "$${0%._cpp}.cpp"' {} \; ; done ;
# 		@for f in $(LOCAL_LIBS_LIST) ; do find $$f -name '*._cpp' -exec sh -c 'mv "$$0" "$${0%._cpp}.cpp"' {} \; ; done ;
# #		@for f in $(LOCAL_LIBS_LIST) ; do find $$f/ -name '*._c' -exec sh -c 'echo "$$0" to "$${0%._c}.c"' {} \; ; done ;
# 		@for f in $(LOCAL_LIBS_LIST) ; do find $$f/ -name '*._c' -exec sh -c 'mv "$$0" "$${0%._c}.c"' {} \; ; done ;
# New		
	$(QUIET)for f in $(LOCAL_LIBS_LIST_TOP) ; do if [ -d $$f/src/$(MCU) ] ; then $(REMOVE) -r $$f/src/$(MCU) ; printf '%-16s  %s\r\n' "7.4-UNARCHIVE" $$f/src/$(MCU) ; fi ; done ;
	@echo "---- Update ----"
	$(QUIET)for f in $(LOCAL_LIBS_LIST_TOP) ; do if [ -f $$f/library.properties ] ; then printf '%-16s  %s\r\n' "7.5-UNARCHIVE" $$f/library.properties ; sed -i -z 's:dot_a_linkage=.*::g' $$f/library.properties ; sed -i -z 's:precompiled=.*::g' $$f/library.properties ; sed -i -z 's:FLAGS_LD=.*::g' $$f/library.properties ; sed -i '/^$$/d' $$f/library.properties ; fi ; done ;
	@echo "==== Unarchive done ===="

# boards:
# 		@echo .
# 		@echo "==== Boards ===="
# 		@ls -1 Configurations/ | sed 's/\(.*\)\..*/\1/'
# 		@echo "==== Boards done ===="

message_compile:
	@echo "---- Compile -----"

before_compile:
ifneq ($(COMMAND_BEFORE_COMPILE),)
	$(call SHOW,"1.0-BEFORE",$(MESSAGE_BEFORE))
        
	$(QUIET)$(COMMAND_BEFORE_COMPILE)
endif

after_compile:
ifneq ($(COMMAND_AFTER_COMPILE),)
	$(call SHOW,"1.1-AFTER",$(MESSAGE_AFTER))
        
	$(QUIET)$(COMMAND_AFTER_COMPILE)
endif

fast: start_message changed before_compile compile after_compile reset raw_upload serial
	@echo "==== $(MESSAGE_TASK) done ===="

make: start_message changed before_compile compile after_compile
	@echo "==== $(MESSAGE_TASK) done ===="

# archive: start_message changed compile do_archive
archive: start_message do_archive
	@echo "==== $(MESSAGE_TASK) done ===="

start_message:
	@echo .
	@echo "==== $(MESSAGE_TASK) ===="

update:
	@echo .
	@echo "==== Update and upgrade boards and libraries ===="
	arduino-cli update
	arduino-cli upgrade
	@echo "==== $(MESSAGE_TASK) ===="

message_core:
	@echo "==== Core ===="

#	if [ -f $(TARGET_CORE_A) ] ; then rm $(TARGET_CORE_A) ; fi

changed_core:
	@echo "---- Clean core ----"
	@if [ -d $(OBJDIR) ]; then $(REMOVE) -r $(OBJDIR); fi
	@mkdir $(OBJDIR)
	@echo "---- Compile core -----"

core: message_core changed_core before_compile $(OBJDIR) $(CORE_OBJS) $(BUILD_CORE_OBJS)

ifneq ($(FIRST_O_IN_CORE_A),)
	$(QUIET)$(AR) rcs $(TARGET_CORE_A) $(FIRST_O_IN_CORE_A)
endif # FIRST_O_IN_CORE_A

	@echo "---- Archive core -----"
	$(call SHOW,"1.9-CORE AR",$(TARGET_CORE_A))

	$(QUIET)$(AR) rcs $(TARGET_CORE_A) $(patsubst %,"%",$(OBJS_CORE))
	@echo "==== $(MESSAGE_TASK) done ===="

info:
	@echo "==== $(MESSAGE_TASK) done ===="

# debug:
# 		cd $(CURRENT_DIR); $(UTILITIES_PATH)/uploader_raspi_ssh.sh $(SSH_ADDRESS) $(SSH_PASSWORD) $(REMOTE_FOLDER) $(BINARY_SPECIFIC_NAME) $(BUILDS_PATH) -debug

# arguments:
#		@if [ -f $(UTILITIES_PATH)/emCode_arguments ]; then sleep 2; echo "." ; $(UTILITIES_PATH)/emCode_arguments $(SCOPE_FLAG) "$(USER_LIB_PATH)"; fi;

#.NOTPARALLEL:

# cat Step2.mk | grep -e "^[A-z]\+:" | cut -d: -f1
.PHONY: all after_compile before_compile boards build changed clean compile depends fast info ispload make start_message message_compile raw_upload reset serial size upload archive do_archive unarchive arguments update
