#
# chipKIT extensions for Arduino Makefile
# System part (i.e. project independent)
#
# Copyright (C) 2011, 2012, 2013 Christopher Peplin
# <chris.peplin@rhubarbtech.com>, based on work that is Copyright Martin
# Oldfield
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# Modified by John Wallbank for Visual Studio
#
#    Development changes, John Wallbank,
#
#   - made inclusion of WProgram.h optional so that
#    including it in the source doesn't mess up compile error line numbers
#   - parameterised the routine used to reset the serial port
#

########################################################################
# Makefile distribution path
#

# The show_config_variable is unavailable before we include the common makefile,
# so we defer logging the ARDMK_DIR info until it happens in Arduino.mk
ifndef ARDMK_DIR
    # presume it's the same path to our own file
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif

include $(ARDMK_DIR)/Common.mk

ifndef MPIDE_DIR
    AUTO_MPIDE_DIR := $(firstword \
        $(call dir_if_exists,/usr/share/mpide) \
        $(call dir_if_exists,/Applications/Mpide.app/Contents/Resources/Java) )
    ifdef AUTO_MPIDE_DIR
       MPIDE_DIR = $(AUTO_MPIDE_DIR)
       $(call show_config_variable,MPIDE_DIR,[autodetected])
    else
        echo $(error "mpide_dir is not defined")
    endif
else
    $(call show_config_variable,MPIDE_DIR,[USER])
endif

ifeq ($(CURRENT_OS),WINDOWS)
    ifneq ($(shell echo $(ARDUINO_DIR) | egrep '^(/|[a-zA-Z]:\\)'),)
        echo $(error On Windows, MPIDE_DIR must be a relative path)
    endif
endif

ifndef MPIDE_PREFERENCES_PATH
    AUTO_MPIDE_PREFERENCES_PATH := $(firstword \
        $(call dir_if_exists,$(HOME)/.mpide/preferences.txt) \
        $(call dir_if_exists,$(HOME)/Library/Mpide/preferences.txt) )
    ifdef AUTO_MPIDE_PREFERENCES_PATH
       MPIDE_PREFERENCES_PATH = $(AUTO_MPIDE_PREFERENCES_PATH)
       $(call show_config_variable,MPIDE_PREFERENCES_PATH,[autodetected])
    endif
endif

# The same as in Arduino, the Linux distribution contains avrdude and #
# avrdude.conf in a different location, but for chipKIT it's even slightly
# different than the Linux paths for Arduino, so we have to "double override".
ifeq ($(CURRENT_OS),LINUX)
    AVRDUDE_DIR = $(ARDUINO_DIR)/hardware/tools
    AVRDUDE = $(AVRDUDE_DIR)/avrdude
    AVRDUDE_CONF = $(AVRDUDE_DIR)/avrdude.conf
endif

AVR_TOOLS_DIR = $(ARDUINO_DIR)/hardware/pic32/compiler/pic32-tools

ALTERNATE_CORE = pic32
ALTERNATE_CORE_PATH = $(MPIDE_DIR)/hardware/pic32
ARDUINO_CORE_PATH = $(ALTERNATE_CORE_PATH)/cores/$(ALTERNATE_CORE)
ARDUINO_PREFERENCES_PATH = $(MPIDE_PREFERENCES_PATH)
ARDUINO_DIR = $(MPIDE_DIR)

CORE_AS_SRCS = $(ARDUINO_CORE_PATH)/vector_table.S \
			   $(ARDUINO_CORE_PATH)/cpp-startup.S \
			   $(ARDUINO_CORE_PATH)/crti.S \
			   $(ARDUINO_CORE_PATH)/crtn.S \
			   $(ARDUINO_CORE_PATH)/pic32_software_reset.S

ARDUINO_VERSION = 23

TOOL_PREFIX = pic32

LDSCRIPT = $(call PARSE_BOARD,$(BOARD_TAG),ldscript)
LDSCRIPT_FILE = $(ARDUINO_CORE_PATH)/$(LDSCRIPT)

MCU_FLAG_NAME=mprocessor
LDFLAGS  += -mdebugger -mno-peripheral-libs -nostartfiles -Wl,--gc-sections
LINKER_SCRIPTS  += -T $(ARDUINO_CORE_PATH)/$(LDSCRIPT)
LINKER_SCRIPTS  += -T $(ARDUINO_CORE_PATH)/chipKIT-application-COMMON.ld
CPPFLAGS += -mno-smart-io -fno-short-double -fframe-base-loclist \
			-g3 -Wcast-align -D_BOARD_MEGA_
CFLAGS_STD =

include $(ARDMK_DIR)/Arduino.mk
