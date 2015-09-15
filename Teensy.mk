########################################################################
#
# Support for Teensy 3.x boards
#
# https://www.pjrc.com/teensy/
#
# You must install teensyduino for this Makefile to work:
#
# http://www.pjrc.com/teensy/teensyduino.html
#
# Copyright (C) 2014 Jeremy Shaw <jeremy@n-heptane.com> based on
# work that is copyright Sudar, Nicholas Zambetti, David A. Mellis
# & Hernando Barragan.
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# Adapted from Arduino 0011 Makefile by M J Oldfield
#
# Original Arduino adaptation by mellis, eighthave, oli.keller
#
# Refer to HISTORY.md file for complete history of changes
#
########################################################################


ifndef ARDMK_DIR
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif

# include Common.mk now we know where it is
include $(ARDMK_DIR)/Common.mk

ARDMK_VENDOR        = teensy
ARDUINO_CORE_PATH   = $(ARDUINO_DIR)/hardware/teensy/cores/teensy3
BOARDS_TXT          = $(ARDUINO_DIR)/hardware/$(ARDMK_VENDOR)/boards.txt

ifndef F_CPU
    F_CPU=96000000
endif

ifndef PARSE_TEENSY
    # result = $(call READ_BOARD_TXT, 'boardname', 'parameter')
    PARSE_TEENSY = $(shell grep -v "^\#" "$(BOARDS_TXT)" | grep $(1).$(2) | cut -d = -f 2,3 )
endif

ARCHITECTURE  = $(call PARSE_TEENSY,$(BOARD_TAG),build.architecture)
AVR_TOOLS_DIR = $(call dir_if_exists,$(ARDUINO_DIR)/hardware/tools/$(ARCHITECTURE))

########################################################################
# command names

ifndef CC_NAME
    CC_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.gcc)
    ifndef CC_NAME
        CC_NAME := arm-none-eabi-gcc
    else
        $(call show_config_variable,CC_NAME,[COMPUTED])
    endif
endif

ifndef CXX_NAME
    CXX_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.g++)
    ifndef CXX_NAME
        CXX_NAME := arm-none-eabi-g++
    else
        $(call show_config_variable,CXX_NAME,[COMPUTED])
    endif
endif

ifndef AS_NAME
    AS_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.as)
    ifndef AS_NAME
        AS_NAME := arm-none-eabi-gcc-as
    else
        $(call show_config_variable,AS_NAME,[COMPUTED])
    endif
endif

ifndef OBJCOPY_NAME
    OBJCOPY_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.objcopy)
    ifndef OBJCOPY_NAME
        OBJCOPY_NAME := arm-none-eabi-objcopy
    else
        $(call show_config_variable,OBJCOPY_NAME,[COMPUTED])
    endif
endif

ifndef OBJDUMP_NAME
    OBJDUMP_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.objdump)
    ifndef OBJDUMP_NAME
        OBJDUMP_NAME := arm-none-eabi-objdump
    else
        $(call show_config_variable,OBJDUMP_NAME,[COMPUTED])
    endif
endif

ifndef AR_NAME
    AR_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.ar)
    ifndef AR_NAME
        AR_NAME := arm-none-eabi-ar
    else
        $(call show_config_variable,AR_NAME,[COMPUTED])
    endif
endif

ifndef SIZE_NAME
    SIZE_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.size)
    ifndef SIZE_NAME
        SIZE_NAME := arm-none-eabi-size
    else
        $(call show_config_variable,SIZE_NAME,[COMPUTED])
    endif
endif

ifndef NM_NAME
    NM_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.nm)
    ifndef NM_NAME
        NM_NAME := arm-none-eabi-gcc-nm
    else
        $(call show_config_variable,NM_NAME,[COMPUTED])
    endif
endif

# processor stuff
ifndef MCU
    MCU := $(call PARSE_TEENSY,$(BOARD_TAG),build.cpu)
endif

ifndef MCU_FLAG_NAME
    MCU_FLAG_NAME=mcpu
endif

########################################################################
# FLAGS
ifndef USB_TYPE
    USB_TYPE = USB_SERIAL
endif

CPPFLAGS += -DLAYOUT_US_ENGLISH -D$(USB_TYPE)

CPPFLAGS += $(call PARSE_TEENSY,$(BOARD_TAG),build.option)

CXXFLAGS += $(call PARSE_TEENSY,$(BOARD_TAG),build.cppoption)
ifeq ("$(call PARSE_TEENSY,$(BOARD_TAG),build.gnu0x)","true")
    CXXFLAGS_STD      += -std=gnu++0x
endif

ifeq ("$(call PARSE_TEENSY,$(BOARD_TAG),build.elide_constructors)", "true")
    CXXFLAGS      += -felide-constructors
endif

LDFLAGS +=  $(call PARSE_TEENSY,$(BOARD_TAG),build.linkoption) $(call PARSE_TEENSY,$(BOARD_TAG),build.additionalobject)

ifneq ("$(call PARSE_TEENSY,$(BOARD_TAG),build.linkscript)",)
    LDFLAGS   += -T$(ARDUINO_CORE_PATH)/$(call PARSE_TEENSY,$(BOARD_TAG),build.linkscript)
endif

########################################################################
# some fairly odd settings so that 'make upload' works
#
# may require additional patches for Windows support

do_upload: override get_monitor_port=""
AVRDUDE=@true
RESET_CMD = nohup $(ARDUINO_DIR)/hardware/tools/teensy_post_compile -board=$(BOARD_TAG) -tools=$(abspath $(ARDUINO_DIR)/hardware/tools) -path=$(abspath $(OBJDIR)) -file=$(TARGET) > /dev/null ; $(ARDUINO_DIR)/hardware/tools/teensy_reboot

########################################################################
# automatially include Arduino.mk for the user

include $(ARDMK_DIR)/Arduino.mk
