#
# chipKIT extensions for Arduino Makefile
# System part (i.e. project independent)
#
# Copyright (C) 2011 Christopher Peplin <chris.peplin@rhubarbtech.com>,
# based on work that is Copyright Martin Oldfield
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#

OSTYPE := $(shell uname)

ifeq ($(wildcard $(MPIDE_DIR)),)
$(error "Error: the MPIDE_DIR variable must point to your MPIDE installation")
endif

ARDUINO_DIR = $(MPIDE_DIR)

AVR_TOOLS_PATH = $(ARDUINO_DIR)/hardware/pic32/compiler/pic32-tools/bin/

ifneq ($(OSTYPE),Linux)
AVRDUDE_TOOLS_PATH = $(ARDUINO_DIR)/hardware/tools/avr/bin
else
AVRDUDE_TOOLS_PATH = $(ARDUINO_DIR)/hardware/tools
endif

ifneq ($(OSTYPE),Linux)
AVRDUDE_ETC_PATH = $(ARDUINO_DIR)/hardware/tools/avr/etc
else
AVRDUDE_ETC_PATH = $(AVRDUDE_TOOLS_PATH)
endif

ARDUINO_CORE_PATH = $(ARDUINO_DIR)/hardware/pic32/cores/pic32
ARDUINO_LIB_PATH = $(ARDUINO_DIR)/hardware/pic32/libraries
BOARDS_TXT  = $(ARDUINO_DIR)/hardware/pic32/boards.txt
ARDUINO_VAR_PATH = $(ARDUINO_DIR)/hardware/pic32/variants
ARDUINO_VERSION = 23

CC_NAME = pic32-gcc
CXX_NAME = pic32-g++
AR_NAME = pic32-ar
OBJDUMP_NAME = pic32-objdump
OBJCOPY_NAME = pic32-objcopy

MCU_FLAG_NAME=mprocessor
LDSCRIPT_FILE = $(ARDUINO_CORE_PATH)/$(LDSCRIPT)
EXTRA_LDFLAGS  = -T$(ARDUINO_CORE_PATH)/$(LDSCRIPT)
EXTRA_CPPFLAGS = -mno-smart-io -D$(BOARD)

CHIPKIT_MK_PATH := $(dir $(lastword $(MAKEFILE_LIST)))

include $(CHIPKIT_MK_PATH)/Arduino.mk

ifeq ($(OSTYPE),Linux)
# MPIDE still comes with the compilers on Linux, unlike Arduino
CC      := $(addprefix $(AVR_TOOLS_PATH),$(CC))
CXX     := $(addprefix $(AVR_TOOLS_PATH),$(CXX))
OBJCOPY := $(addprefix $(AVR_TOOLS_PATH),$(OBJCOPY))
OBJDUMP := $(addprefix $(AVR_TOOLS_PATH),$(OBJDUMP))
AR      := $(addprefix $(AVR_TOOLS_PATH),$(AR))
SIZE    := $(addprefix $(AVR_TOOLS_PATH),$(SIZE))
NM      := $(addprefix $(AVR_TOOLS_PATH),$(NM))
endif
