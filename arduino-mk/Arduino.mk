########################################################################
#
# Makefile for compiling Arduino sketches from command line
# System part (i.e. project independent)
#
# Copyright (C) 2012 Sudar <http://sudarmuthu.com>, based on
# - M J Oldfield work: https://github.com/mjoldfield/Arduino-Makefile
#
# Copyright (C) 2010,2011,2012 Martin Oldfield <m@mjo.tc>, based on
# work that is copyright Nicholas Zambetti, David A. Mellis & Hernando
# Barragan.
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
# Current version: 0.10.5
#
# Refer to HISTORY.md file for complete history of changes
#
########################################################################
#
# PATHS YOU NEED TO SET UP
#
# We need to worry about three different sorts of file:
#
# 1. Things which are included in this distribution e.g. ard-parse-boards
#    => ARDMK_DIR
#
# 2. Things which are always in the Arduino distribution e.g.
#    boards.txt, libraries, &c.
#    => ARDUINO_DIR
#
# 3. Things which might be bundled with the Arduino distribution, but
#    might come from the system. Most of the toolchain is like this:
#    on Linux it's supplied by the system.
#    => AVR_TOOLS_DIR
#
# Having set these three variables, we can work out the rest assuming
# that things are canonically arranged beneath the directories defined
# above.
#
# On the Mac you might want to set:
#
#   ARDUINO_DIR   = /Applications/Arduino.app/Contents/Resources/Java
#   ARDMK_DIR     = /usr/local
#
# On Linux, you might prefer:
#
#   ARDUINO_DIR   = /usr/share/arduino
#   ARDMK_DIR     = /usr/local
#   AVR_TOOLS_DIR = /usr
#
# You can either set these up in the Makefile, or put them in your
# environment e.g. in your .bashrc
#
# If you don't specify these, we can try to guess, but that might not work
# or work the way you want it to.
#
# If you don't install the ard-... binaries to /usr/local/bin, but
# instead copy them to e.g. /home/mjo/arduino.mk/bin then set
#   ARDML_DIR = /home/mjo/arduino.mk
#
# If you'd rather not see the configuration output, define ARDUINO_QUIET.
#
########################################################################
#
# DEPENDENCIES
#
# The Perl programs need a couple of libraries:
#    YAML
#    Device::SerialPort
#
########################################################################
#
# STANDARD ARDUINO WORKFLOW
#
# Given a normal sketch directory, all you need to do is to create
# a small Makefile which defines a few things, and then includes this one.
#
# For example:
#
#       ARDUINO_LIBS = Ethernet Ethernet/utility SPI
#       BOARD_TAG    = uno
#       ARDUINO_PORT = /dev/cu.usb*
#
#       include /usr/local/share/Arduino.mk
#
# Hopefully these will be self-explanatory but in case they're not:
#
#    ARDUINO_LIBS - A list of any libraries used by the sketch (we
#                   assume these are in $(ARDUINO_DIR)/hardware/libraries
#                   or your sketchbook's libraries directory)
#
#    ARDUINO_PORT - The port where the Arduino can be found (only needed
#                   when uploading)
#
#    BOARD_TAG    - The ard-parse-boards tag for the board e.g. uno or mega
#                   'make show_boards' shows a list
#
# If you have your additional libraries relative to your source, rather
# than in your "sketchbook", also set USER_LIB_PATH, like this example:
#
#        USER_LIB_PATH := $(realpath ../../libraries)
#
# If you've added the Arduino-Makefile repository to your git repo as a
# submodule (or other similar arrangement), you might have lines like this
# in your Makefile:
#
#        ARDMK_DIR := $(realpath ../../tools/Arduino-Makefile)
#        include $(ARDMK_DIR)/arduino-mk/Arduino.mk
#
# In any case, once this file has been created the typical workflow is just
#
#   $ make upload
#
# All of the object files are created in the build-{BOARD_TAG} subdirectory
# All sources should be in the current directory and can include:
#  - at most one .pde or .ino file which will be treated as C++ after
#    the standard Arduino header and footer have been affixed.
#  - any number of .c, .cpp, .s and .h files
#
# Included libraries are built in the build-{BOARD_TAG}/libs subdirectory.
#
# Besides make upload you can also
#   make             - no upload
#   make clean       - remove all our dependencies
#   make depends     - update dependencies
#   make reset       - reset the Arduino by tickling DTR on the serial port
#   make raw_upload  - upload without first resetting
#   make show_boards - list all the boards defined in boards.txt
#   make monitor     - connect to the Arduino's serial port
#   make size        - show the size of the compiled output (relative to
#                      resources, if you have a patched avr-size)
#   make disasm      - generate a .lss file in build-cli that contains
#                      disassembly of the compiled file interspersed
#                      with your original source code.
#   make verify_size - Verify that the size of the final file is less than
#   				   the capacity of the micro controller.
#   make eeprom      - upload the eep file
#	make raw_eeprom  - upload the eep file without first resetting
#
########################################################################
#
# SERIAL MONITOR
#
# The serial monitor just invokes the GNU screen program with suitable
# options. For more information see screen (1) and search for
# 'character special device'.
#
# The really useful thing to know is that ^A-k gets you out!
#
# The fairly useful thing to know is that you can bind another key to
# escape too, by creating $HOME{.screenrc} containing e.g.
#
#    bindkey ^C kill
#
# If you want to change the baudrate, just set MONITOR_BAUDRATE. If you
# don't set it, it tries to read from the sketch. If it couldn't read
# from the sketch, then it defaults to 9600 baud.
#
########################################################################
#
# ARDUINO WITH ISP
#
# You need to specify some details of your ISP programmer and might
# also need to specify the fuse values:
#
#     ISP_PROG	   = stk500v2
#     ISP_PORT     = /dev/ttyACM0
#
# You might also need to set the fuse bits, but typically they'll be
# read from boards.txt, based on the BOARD_TAG variable:
#
#     ISP_LOCK_FUSE_PRE  = 0x3f
#     ISP_LOCK_FUSE_POST = 0xcf
#     ISP_HIGH_FUSE      = 0xdf
#     ISP_LOW_FUSE       = 0xff
#     ISP_EXT_FUSE       = 0x01
#
# You can specify to also upload the EEPROM file:
#     ISP_EEPROM   = 1
#
# I think the fuses here are fine for uploading to the ATmega168
# without bootloader.
#
# To actually do this upload use the ispload target:
#
#    make ispload
#
#
########################################################################

# Useful functions
# Returns the first argument (typically a directory), if the file or directory
# named by concatenating the first and optionally second argument
# (directory and optional filename) exists
dir_if_exists = $(if $(wildcard $(1)$(2)),$(1))

# For message printing: pad the right side of the first argument with spaces to
# the number of bytes indicated by the second argument.
space_pad_to = $(shell echo $(1) "                                                      " | head -c$(2))

arduino_output =
# When output is not suppressed and we're in the top-level makefile,
# running for the first time (i.e., not after a restart after
# regenerating the dependency file), then output the configuration.
ifndef ARDUINO_QUIET
    ifeq ($(MAKE_RESTARTS),)
        ifeq ($(MAKELEVEL),0)
            arduino_output = $(info $(1))
        endif
    endif
endif

# Call with some text, and a prefix tag if desired (like [AUTODETECTED]),
show_config_info = $(call arduino_output,- $(call space_pad_to,$(2),20) $(1))

# Call with the name of the variable, a prefix tag if desired (like [AUTODETECTED]),
# and an explanation if desired (like (found in $$PATH)
show_config_variable = $(call show_config_info,$(1) = $($(1)) $(3),$(2))

# Just a nice simple visual separator
show_separator = $(call arduino_output,-------------------------)

$(call show_separator)
$(call arduino_output,Arduino.mk Configuration:)

ifndef ARDUINO_DIR
    AUTO_ARDUINO_DIR := $(firstword \
        $(call dir_if_exists,/usr/share/arduino) \
        $(call dir_if_exists,/Applications/Arduino.app/Contents/Resources/Java) )
    ifdef AUTO_ARDUINO_DIR
       ARDUINO_DIR = $(AUTO_ARDUINO_DIR)
       $(call show_config_variable,ARDUINO_DIR,[AUTODETECTED])
    endif

else
    $(call show_config_variable,ARDUINO_DIR,[USER])
endif

########################################################################
#
# Default TARGET to pwd (ex Daniele Vergini)
ifndef TARGET
    TARGET  = $(notdir $(CURDIR))
endif

########################################################################
# Arduino version number
ifndef ARDUINO_VERSION
    # Remove all the decimals, and right-pad with zeros, and finally grab the first 3 bytes.
    # Works for 1.0 and 1.0.1
    VERSION_FILE := $(ARDUINO_DIR)/lib/version.txt
    AUTO_ARDUINO_VERSION := $(shell [ -e $(VERSION_FILE) ] && cat $(VERSION_FILE) | sed -e 's/[.]//g' -e 's/$$/0000/' | head -c3)
    ifdef AUTO_ARDUINO_VERSION
        ARDUINO_VERSION = $(AUTO_ARDUINO_VERSION)
        $(call show_config_variable,ARDUINO_VERSION,[AUTODETECTED])
    else
        ARDUINO_VERSION = 100
        $(call show_config_variable,ARDUINO_VERSION,[DEFAULT])
    endif
else
    $(call show_config_variable,ARDUINO_VERSION,[USER])
endif

########################################################################
# Arduino and system paths
#
ifdef ARDUINO_DIR

    ifndef AVR_TOOLS_DIR

        BUNDLED_AVR_TOOLS_DIR := $(call dir_if_exists,$(ARDUINO_DIR)/hardware/tools/avr)
        ifdef BUNDLED_AVR_TOOLS_DIR
            AVR_TOOLS_DIR     = $(BUNDLED_AVR_TOOLS_DIR)
            # The avrdude bundled with Arduino can't find it's config
            AVRDUDE_CONF	  = $(AVR_TOOLS_DIR)/etc/avrdude.conf
            $(call show_config_variable,AVR_TOOLS_DIR,[BUNDLED],(in Arduino distribution))

        else

            SYSTEMPATH_AVR_TOOLS_DIR := $(call dir_if_exists,$(abspath $(dir $(shell which avr-gcc))/..))
            ifdef SYSTEMPATH_AVR_TOOLS_DIR
                AVR_TOOLS_DIR     = $(SYSTEMPATH_AVR_TOOLS_DIR)
                $(call show_config_variable,AVR_TOOLS_DIR,[AUTODETECTED],(found in $$PATH))
            endif # SYSTEMPATH_AVR_TOOLS_DIR

        endif # BUNDLED_AVR_TOOLS_DIR

    else
        $(call show_config_variable,AVR_TOOLS_DIR,[USER])
    endif #ndef AVR_TOOLS_DIR

    ARDUINO_LIB_PATH  = $(ARDUINO_DIR)/libraries
    $(call show_config_variable,ARDUINO_LIB_PATH,[COMPUTED],(from ARDUINO_DIR))
    ARDUINO_CORE_PATH = $(ARDUINO_DIR)/hardware/arduino/cores/arduino

    ifndef ARDUINO_VAR_PATH
        ARDUINO_VAR_PATH  = $(ARDUINO_DIR)/hardware/arduino/variants
        $(call show_config_variable,ARDUINO_VAR_PATH,[COMPUTED],(from ARDUINO_DIR))
    else
        $(call show_config_variable,ARDUINO_VAR_PATH,[USER])
    endif

else

    echo $(error "ARDUINO_DIR is not defined")

endif

ifdef AVR_TOOLS_DIR
    ifndef AVR_TOOLS_PATH
        AVR_TOOLS_PATH    = $(AVR_TOOLS_DIR)/bin
    endif
endif

########################################################################
# Makefile distribution path
#
ifndef ARDMK_DIR
    # presume it's a level above the path to our own file
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/..)
    $(call show_config_variable,ARDMK_DIR,[COMPUTED],(relative to $(notdir $(lastword $(MAKEFILE_LIST)))))
else
    $(call show_config_variable,ARDMK_DIR,[USER])
endif

ifdef ARDMK_DIR
    ifndef ARDMK_PATH
        ARDMK_PATH = $(ARDMK_DIR)/bin
        $(call show_config_variable,ARDMK_PATH,[COMPUTED],(relative to ARDMK_DIR))
    else
        $(call show_config_variable,ARDMK_PATH,[USER])
    endif
else
    echo $(error "ARDMK_DIR is not defined")
endif


########################################################################
# Miscellaneous
#
ifndef ARDUINO_SKETCHBOOK
    ifneq ($(wildcard $(HOME)/.arduino/preferences.txt),)
	ARDUINO_SKETCHBOOK = $(shell grep --max-count=1 --regexp="sketchbook.path=" \
                                          $(HOME)/.arduino/preferences.txt | \
                                     sed -e 's/sketchbook.path=//' )
    endif

	# on mac
    ifneq ($(wildcard $(HOME)/Library/Arduino/preferences.txt),)
	ARDUINO_SKETCHBOOK = $(shell grep --max-count=1 --regexp="sketchbook.path=" \
                                          $(HOME)/Library/Arduino/preferences.txt | \
                                     sed -e 's/sketchbook.path=//' )
    endif

    ifneq ($(ARDUINO_SKETCHBOOK),)
        $(call show_config_variable,ARDUINO_SKETCHBOOK,[AUTODETECTED],(in arduino preferences file))
    else
        ARDUINO_SKETCHBOOK = $(HOME)/sketchbook
        $(call show_config_variable,ARDUINO_SKETCHBOOK,[DEFAULT])
    endif
else
    $(call show_config_variable,ARDUINO_SKETCHBOOK)
endif

ifndef USER_LIB_PATH
    USER_LIB_PATH = $(ARDUINO_SKETCHBOOK)/libraries
    $(call show_config_variable,USER_LIB_PATH,[DEFAULT],(in user sketchbook))
else
    $(call show_config_variable,USER_LIB_PATH,[USER])
endif

########################################################################
# Reset
#
ifndef RESET_CMD
    ifeq ($(BOARD_TAG),leonardo)
       RESET_CMD = $(ARDMK_PATH)/ard-reset-leonardo \
          $(ARD_RESET_OPTS) $(call get_arduino_port)
    else
       RESET_CMD = $(ARDMK_PATH)/ard-reset-arduino \
          $(ARD_RESET_OPTS) $(call get_arduino_port)
    endif
endif

ifndef WAIT_CONNECTION_CMD
    ifeq ($(BOARD_TAG),leonardo)
       WAIT_CONNECTION_CMD = \
         $(ARDMK_PATH)/wait-connection-leonardo $(call get_arduino_port)
    else
       WAIT_CONNECTION_CMD =
    endif
endif

ifeq ($(BOARD_TAG),leonardo)
    ERROR_ON_LEONARDO = $(error On leonardo, raw_xxx operation is not supported)
else
    ERROR_ON_LEONARDO =
endif


########################################################################
# boards.txt parsing
#
ifndef BOARD_TAG
    BOARD_TAG   = uno
    $(call show_config_variable,BOARD_TAG,[DEFAULT])
else
	# Strip the board tag of any extra whitespace, since it was causing the makefile to fail
	# https://github.com/sudar/Arduino-Makefile/issues/57
	BOARD_TAG := $(strip $(BOARD_TAG))
    $(call show_config_variable,BOARD_TAG,[USER])
endif

ifndef BOARDS_TXT
    BOARDS_TXT  = $(ARDUINO_DIR)/hardware/arduino/boards.txt
endif

ifndef PARSE_BOARD
    PARSE_BOARD = $(ARDMK_PATH)/ard-parse-boards
endif

ifndef PARSE_BOARD_OPTS
    PARSE_BOARD_OPTS = --boards_txt=$(BOARDS_TXT)
endif

ifndef PARSE_BOARD_CMD
    PARSE_BOARD_CMD = $(PARSE_BOARD) $(PARSE_BOARD_OPTS)
endif

# Which variant ? This affects the include path
ifndef VARIANT
    VARIANT = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) build.variant)
endif

# processor stuff
ifndef MCU
    MCU   = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) build.mcu)
endif

ifndef F_CPU
    F_CPU = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) build.f_cpu)
endif

ifeq ($(VARIANT),leonardo)
    # USB IDs for the Leonardo
    ifndef USB_VID
        USB_VID = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) build.vid 2>/dev/null)
    endif

    ifndef USB_PID
        USB_PID = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) build.pid 2>/dev/null)
    endif
endif

# normal programming info
ifndef AVRDUDE_ARD_PROGRAMMER
    AVRDUDE_ARD_PROGRAMMER = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) upload.protocol)
endif

ifndef AVRDUDE_ARD_BAUDRATE
    AVRDUDE_ARD_BAUDRATE   = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) upload.speed)
endif

# fuses if you're using e.g. ISP
ifndef ISP_LOCK_FUSE_PRE
    ISP_LOCK_FUSE_PRE  = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) bootloader.unlock_bits)
endif

ifndef ISP_LOCK_FUSE_POST
    ISP_LOCK_FUSE_POST = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) bootloader.lock_bits)
endif

ifndef ISP_HIGH_FUSE
    ISP_HIGH_FUSE      = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) bootloader.high_fuses)
endif

ifndef ISP_LOW_FUSE
    ISP_LOW_FUSE       = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) bootloader.low_fuses)
endif

ifndef ISP_EXT_FUSE
    ISP_EXT_FUSE       = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) bootloader.extended_fuses)
endif

# Everything gets built in here (include BOARD_TAG now)
ifndef OBJDIR
	OBJDIR  	  = build-$(BOARD_TAG)
endif

ifndef HEX_MAXIMUM_SIZE
	HEX_MAXIMUM_SIZE  = $(shell $(PARSE_BOARD_CMD) $(BOARD_TAG) upload.maximum_size)
endif

########################################################################
# Local sources
#
LOCAL_C_SRCS    ?= $(wildcard *.c)
LOCAL_CPP_SRCS  ?= $(wildcard *.cpp)
LOCAL_CC_SRCS   ?= $(wildcard *.cc)
LOCAL_PDE_SRCS  ?= $(wildcard *.pde)
LOCAL_INO_SRCS  ?= $(wildcard *.ino)
LOCAL_AS_SRCS   ?= $(wildcard *.S)
LOCAL_SRCS      = $(LOCAL_C_SRCS)   $(LOCAL_CPP_SRCS) \
		$(LOCAL_CC_SRCS)   $(LOCAL_PDE_SRCS) \
		$(LOCAL_INO_SRCS) $(LOCAL_AS_SRCS)
LOCAL_OBJ_FILES = $(LOCAL_C_SRCS:.c=.o)   $(LOCAL_CPP_SRCS:.cpp=.o) \
		$(LOCAL_CC_SRCS:.cc=.o)   $(LOCAL_PDE_SRCS:.pde=.o) \
		$(LOCAL_INO_SRCS:.ino=.o) $(LOCAL_AS_SRCS:.S=.o)
LOCAL_OBJS      = $(patsubst %,$(OBJDIR)/%,$(LOCAL_OBJ_FILES))

ifneq ($(words $(LOCAL_PDE_SRCS) $(LOCAL_INO_SRCS)), 1)
    #TODO: Support more than one file. https://github.com/sudar/Arduino-Makefile/issues/49
    $(error Need exactly one .pde or .ino file)
endif

# core sources
ifeq ($(strip $(NO_CORE)),)
    ifdef ARDUINO_CORE_PATH
        CORE_C_SRCS     = $(wildcard $(ARDUINO_CORE_PATH)/*.c)
        CORE_CPP_SRCS   = $(wildcard $(ARDUINO_CORE_PATH)/*.cpp)

        ifneq ($(strip $(NO_CORE_MAIN_CPP)),)
            CORE_CPP_SRCS := $(filter-out %main.cpp, $(CORE_CPP_SRCS))
            $(call show_config_info,NO_CORE_MAIN_CPP set so core library will not include main.cpp,[MANUAL])
        endif

        CORE_OBJ_FILES  = $(CORE_C_SRCS:.c=.o) $(CORE_CPP_SRCS:.cpp=.o)
        CORE_OBJS       = $(patsubst $(ARDUINO_CORE_PATH)/%,  \
                $(OBJDIR)/%,$(CORE_OBJ_FILES))
    endif
else
    $(call show_config_info,NO_CORE set so core library will not be built,[MANUAL])
endif

########################################################################
# Determine ARDUINO_LIBS automatically
#
ifndef ARDUINO_LIBS
    # automatically determine included libraries
    ARDUINO_LIBS += $(filter $(notdir $(wildcard $(ARDUINO_DIR)/libraries/*)), \
        $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(LOCAL_SRCS)))
    ARDUINO_LIBS += $(filter $(notdir $(wildcard $(ARDUINO_SKETCHBOOK)/libraries/*)), \
        $(shell sed -ne "s/^ *\# *include *[<\"]\(.*\)\.h[>\"]/\1/p" $(LOCAL_SRCS)))
endif

########################################################################
# Serial monitor (just a screen wrapper)
#
# Quite how to construct the monitor command seems intimately tied
# to the command we're using (here screen). So, read the screen docs
# for more information (search for 'character special device').
#
ifndef MONITOR_BAUDRATE
    # This works only in linux. TODO: Port it to MAC OS also
    # https://github.com/sudar/Arduino-Makefile/issues/52
    SPEED = $(shell grep --max-count=1 --regexp="Serial.begin" $(LOCAL_PDE_SRCS) $(LOCAL_INO_SRCS) | sed -e 's/\t//g' -e 's/\/\/.*$$//g' -e 's/(/\t/' -e 's/)/\t/' | awk -F '\t' '{print $$2}' )
    MONITOR_BAUDRATE = $(findstring $(SPEED),300 1200 2400 4800 9600 14400 19200 28800 38400 57600 115200)

    ifeq ($(MONITOR_BAUDRATE),)
        MONITOR_BAUDRATE = 9600
        $(call show_config_variable,MONITOR_BAUDRATE,[ASSUMED])
    else
        $(call show_config_variable,MONITOR_BAUDRATE,[DETECTED], (in sketch))
    endif
else
    $(call show_config_variable,MONITOR_BAUDRATE, [USER])
endif

ifndef MONITOR_CMD
    MONITOR_CMD = screen
endif

########################################################################
# Include file to use for old .pde files
#
ifndef ARDUINO_HEADER
    # We should check for Arduino version, if the file is .pde because a
    # .pde file might be used in Arduino 1.0
    ifeq ($(shell expr $(ARDUINO_VERSION) '<' 100), 1)
        ARDUINO_HEADER=WProgram.h
    else
        ARDUINO_HEADER=Arduino.h
    endif
endif

########################################################################
# Rules for making stuff
#

# The name of the main targets
TARGET_HEX = $(OBJDIR)/$(TARGET).hex
TARGET_ELF = $(OBJDIR)/$(TARGET).elf
TARGET_EEP = $(OBJDIR)/$(TARGET).eep
TARGETS    = $(OBJDIR)/$(TARGET).*
CORE_LIB   = $(OBJDIR)/libcore.a

# Names of executables
CC      = $(AVR_TOOLS_PATH)/avr-gcc
CXX     = $(AVR_TOOLS_PATH)/avr-g++
AS      = $(AVR_TOOLS_PATH)/avr-as
OBJCOPY = $(AVR_TOOLS_PATH)/avr-objcopy
OBJDUMP = $(AVR_TOOLS_PATH)/avr-objdump
AR      = $(AVR_TOOLS_PATH)/avr-ar
SIZE    = $(AVR_TOOLS_PATH)/avr-size
NM      = $(AVR_TOOLS_PATH)/avr-nm
REMOVE  = rm -rf
MV      = mv -f
CAT     = cat
ECHO    = echo

# General arguments
USER_LIBS     = $(wildcard $(patsubst %,$(USER_LIB_PATH)/%,$(ARDUINO_LIBS)))
USER_LIB_NAMES= $(patsubst $(USER_LIB_PATH)/%,%,$(USER_LIBS))

# Let user libraries override system ones.
SYS_LIBS      = $(wildcard $(patsubst %,$(ARDUINO_LIB_PATH)/%,$(filter-out $(USER_LIB_NAMES),$(ARDUINO_LIBS))))
SYS_LIB_NAMES = $(patsubst $(ARDUINO_LIB_PATH)/%,%,$(SYS_LIBS))

# Error here if any are missing.
LIBS_NOT_FOUND = $(filter-out $(USER_LIB_NAMES) $(SYS_LIB_NAMES),$(ARDUINO_LIBS))
ifneq (,$(strip $(LIBS_NOT_FOUND)))
    $(error The following libraries specified in ARDUINO_LIBS could not be found (searched USER_LIB_PATH and ARDUINO_LIB_PATH): $(LIBS_NOT_FOUND))
endif

SYS_LIBS     := $(wildcard $(SYS_LIBS) $(addsuffix /utility,$(SYS_LIBS)))
USER_LIBS    := $(wildcard $(USER_LIBS) $(addsuffix /utility,$(USER_LIBS)))
SYS_INCLUDES  = $(patsubst %,-I%,$(SYS_LIBS))
USER_INCLUDES = $(patsubst %,-I%,$(USER_LIBS))
LIB_C_SRCS    = $(wildcard $(patsubst %,%/*.c,$(SYS_LIBS)))
LIB_CPP_SRCS  = $(wildcard $(patsubst %,%/*.cpp,$(SYS_LIBS)))
USER_LIB_CPP_SRCS   = $(wildcard $(patsubst %,%/*.cpp,$(USER_LIBS)))
USER_LIB_C_SRCS     = $(wildcard $(patsubst %,%/*.c,$(USER_LIBS)))
LIB_OBJS      = $(patsubst $(ARDUINO_LIB_PATH)/%.c,$(OBJDIR)/libs/%.o,$(LIB_C_SRCS)) \
        $(patsubst $(ARDUINO_LIB_PATH)/%.cpp,$(OBJDIR)/libs/%.o,$(LIB_CPP_SRCS))
USER_LIB_OBJS = $(patsubst $(USER_LIB_PATH)/%.cpp,$(OBJDIR)/libs/%.o,$(USER_LIB_CPP_SRCS)) \
        $(patsubst $(USER_LIB_PATH)/%.c,$(OBJDIR)/libs/%.o,$(USER_LIB_C_SRCS))

# Dependency files
DEPS            = $(LOCAL_OBJS:.o=.d) $(LIB_OBJS:.o=.d) $(USER_LIB_OBJS:.o=.d) $(CORE_OBJS:.o=.d)

# Using += instead of =, so that CPPFLAGS can be set per sketch level
CPPFLAGS      += -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DARDUINO=$(ARDUINO_VERSION) \
        -I. -I$(ARDUINO_CORE_PATH) -I$(ARDUINO_VAR_PATH)/$(VARIANT) \
        $(SYS_INCLUDES) $(USER_INCLUDES) -g -Os -Wall \
        -ffunction-sections -fdata-sections

# USB IDs for the Leonardo
ifeq ($(VARIANT),leonardo)
    CPPFLAGS += -DUSB_VID=$(USB_VID) -DUSB_PID=$(USB_PID)
endif

CFLAGS        += -std=gnu99 $(EXTRA_FLAGS) $(EXTRA_CFLAGS)
CXXFLAGS      += -fno-exceptions $(EXTRA_FLAGS) $(EXTRA_CXXFLAGS)
ASFLAGS       += -mmcu=$(MCU) -I. -x assembler-with-cpp
LDFLAGS       += -mmcu=$(MCU) -Wl,--gc-sections -Os $(EXTRA_FLAGS) $(EXTRA_CXXFLAGS)
SIZEFLAGS     ?= --mcu=$(MCU) -C

# Returns the Arduino port (first wildcard expansion) if it exists, otherwise it errors.
get_arduino_port = $(if $(wildcard $(ARDUINO_PORT)),$(firstword $(wildcard $(ARDUINO_PORT))),$(error Arduino port $(ARDUINO_PORT) not found!))

# Returns the ISP port (first wildcard expansion) if it exists, otherwise it errors.
get_isp_port = $(if $(wildcard $(ISP_PORT)),$(firstword $(wildcard $(ISP_PORT))),$(error ISP port $(ISP_PORT) not found!))

# Command for avr_size: do $(call avr_size,elffile,hexfile)
ifneq (,$(findstring AVR,$(shell $(SIZE) --help)))
    # We have a patched version of binutils that mentions AVR - pass the MCU
    # and the elf to get nice output.
    avr_size = $(SIZE) $(SIZEFLAGS) --format=avr $(1)
    $(call show_config_info,Size utility: AVR-aware for enhanced output,[AUTODETECTED])
else
    # We have a plain-old binutils version - just give it the hex.
    avr_size = $(SIZE) $(2)
    $(call show_config_info,Size utility: Basic (not AVR-aware),[AUTODETECTED])
endif

ifneq (,$(strip $(ARDUINO_LIBS)))
    $(call arduino_output,-)
    $(call show_config_info,ARDUINO_LIBS =)
endif

ifneq (,$(strip $(USER_LIB_NAMES)))
    $(foreach lib,$(USER_LIB_NAMES),$(call show_config_info,  $(lib),[USER]))
endif

ifneq (,$(strip $(SYS_LIB_NAMES)))
    $(foreach lib,$(SYS_LIB_NAMES),$(call show_config_info,  $(lib),[SYSTEM]))
endif

# end of config output
$(call show_separator)

# Implicit rules for building everything (needed to get everything in
# the right directory)
#
# Rather than mess around with VPATH there are quasi-duplicate rules
# here for building e.g. a system C++ file and a local C++
# file. Besides making things simpler now, this would also make it
# easy to change the build options in future

# library sources
$(OBJDIR)/libs/%.o: $(ARDUINO_LIB_PATH)/%.c | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/libs/%.o: $(ARDUINO_LIB_PATH)/%.cpp | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/libs/%.o: $(USER_LIB_PATH)/%.cpp | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/libs/%.o: $(USER_LIB_PATH)/%.c | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

ifdef COMMON_DEPS
	COMMON_DEPS := $(COMMON_DEPS) Makefile
else
	COMMON_DEPS := Makefile
endif

# normal local sources
$(OBJDIR)/%.o: %.c $(COMMON_DEPS) | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/%.o: %.cc $(COMMON_DEPS) | $(OBJDIR)
	$(CXX) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.o: %.cpp $(COMMON_DEPS) | $(OBJDIR)
	$(CXX) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.o: %.S $(COMMON_DEPS) | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(ASFLAGS) $< -o $@

$(OBJDIR)/%.o: %.s $(COMMON_DEPS) | $(OBJDIR)
	$(CC) -c $(CPPFLAGS) $(ASFLAGS) $< -o $@

# the pde -> o file
$(OBJDIR)/%.o: %.pde | $(OBJDIR)
	$(CXX) -x c++ -include $(ARDUINO_HEADER) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

# the ino -> o file
$(OBJDIR)/%.o: %.ino | $(OBJDIR)
	$(CXX) -x c++ -include Arduino.h -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

# generated assembly
$(OBJDIR)/%.s: $(OBJDIR)/%.cpp $(COMMON_DEPS) | $(OBJDIR)
	$(CXX) -S -fverbose-asm $(CPPFLAGS) $(CXXFLAGS) $< -o $@

#$(OBJDIR)/%.lst: $(OBJDIR)/%.s
#	$(AS) -mmcu=$(MCU) -alhnd $< > $@

# core files
$(OBJDIR)/%.o: $(ARDUINO_CORE_PATH)/%.c $(COMMON_DEPS) | $(OBJDIR)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/%.o: $(ARDUINO_CORE_PATH)/%.cpp $(COMMON_DEPS) | $(OBJDIR)
	$(CXX) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

# various object conversions
$(OBJDIR)/%.hex: $(OBJDIR)/%.elf $(COMMON_DEPS)
	$(OBJCOPY) -O ihex -R .eeprom $< $@
	@$(ECHO)
	@$(ECHO)
	$(call avr_size,$<,$@)

$(OBJDIR)/%.eep: $(OBJDIR)/%.elf $(COMMON_DEPS)
	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
		--change-section-lma .eeprom=0 -O ihex $< $@

$(OBJDIR)/%.lss: $(OBJDIR)/%.elf $(COMMON_DEPS)
	$(OBJDUMP) -h --source --demangle --wide $< > $@

$(OBJDIR)/%.sym: $(OBJDIR)/%.elf $(COMMON_DEPS)
	$(NM) --size-sort --demangle --reverse-sort --line-numbers $< > $@

########################################################################
#
# Avrdude
#
ifndef AVRDUDE
    AVRDUDE          = $(AVR_TOOLS_PATH)/avrdude
endif

ifndef AVRDUDE_CONF
    ifndef AVR_TOOLS_DIR
        # The avrdude bundled with Arduino can't find its config
        AVRDUDE_CONF  = $(AVR_TOOLS_DIR)/etc/avrdude.conf
    endif
    # If avrdude is installed separately, it can find its own config file
endif

AVRDUDE_COM_OPTS = -q -V -p $(MCU)
ifdef AVRDUDE_CONF
    AVRDUDE_COM_OPTS += -C $(AVRDUDE_CONF)
endif

AVRDUDE_ARD_OPTS = -c $(AVRDUDE_ARD_PROGRAMMER) -b $(AVRDUDE_ARD_BAUDRATE) -P $(call get_arduino_port)

ifndef ISP_PROG
    ISP_PROG   = stk500v1
endif

ifndef AVRDUDE_ISP_BAUDRATE
    AVRDUDE_ISP_BAUDRATE = 19200
endif

AVRDUDE_ISP_OPTS = -c $(ISP_PROG) -b $(AVRDUDE_ISP_BAUDRATE) -P $(call get_isp_port)

ifndef ISP_EEPROM
    ISP_EEPROM  = 0
endif

AVRDUDE_UPLOAD_HEX = -U flash:w:$(TARGET_HEX):i
AVRDUDE_UPLOAD_EEP = -U eeprom:w:$(TARGET_EEP):i
AVRDUDE_ISPLOAD_OPTS = $(AVRDUDE_UPLOAD_HEX)

ifneq ($(ISP_EEPROM), 0)
    AVRDUDE_ISPLOAD_OPTS += $(AVRDUDE_UPLOAD_EEP)
endif

########################################################################
#
# Explicit targets start here
#

all: 		$(TARGET_EEP) $(TARGET_HEX) verify_size

# Rule to create $(OBJDIR) automatically. All rules with recipes that
# create a file within it, but do not already depend on a file within it
# should depend on this rule. They should use a "order-only
# prerequisite" (e.g., put "| $(OBJDIR)" at the end of the prerequisite
# list) to prevent remaking the target when any file in the directory
# changes.
$(OBJDIR):
		mkdir $(OBJDIR)

$(TARGET_ELF): 	$(LOCAL_OBJS) $(CORE_LIB) $(OTHER_OBJS)
		$(CC) $(LDFLAGS) -o $@ $(LOCAL_OBJS) $(CORE_LIB) $(OTHER_OBJS) -lc -lm

$(CORE_LIB):	$(CORE_OBJS) $(LIB_OBJS) $(USER_LIB_OBJS)
		$(AR) rcs $@ $(CORE_OBJS) $(LIB_OBJS) $(USER_LIB_OBJS)

error_on_leonardo:
		$(ERROR_ON_LEONARDO)

# Use submake so we can guarantee the reset happens
# before the upload, even with make -j
upload:		$(TARGET_HEX) verify_size
		$(MAKE) reset
		$(MAKE) do_upload

raw_upload:	$(TARGET_HEX) verify_size
		$(MAKE) error_on_leonardo
		$(MAKE) do_upload

do_upload:
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ARD_OPTS) \
			$(AVRDUDE_UPLOAD_HEX)

do_eeprom:	$(TARGET_EEP) $(TARGET_HEX)
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ARD_OPTS) \
			$(AVRDUDE_UPLOAD_EEP)

eeprom:		$(TARGET_HEX) verify_size
		$(MAKE) reset
		$(MAKE) do_eeprom

raw_eeprom:	$(TARGET_HEX) verify_size
		$(MAKE) error_on_leonardo
		$(MAKE) do_eeprom

# the last part is for leonardo.
# wait until leonardo reboots and establish a new connection.
reset:
		$(call arduino_output,Resetting Arduino...)
		$(RESET_CMD)
		$(WAIT_CONNECTION_CMD)

# stty on MacOS likes -F, but on Debian it likes -f redirecting
# stdin/out appears to work but generates a spurious error on MacOS at
# least. Perhaps it would be better to just do it in perl ?
reset_stty:
		for STTYF in 'stty -F' 'stty --file' 'stty -f' 'stty <' ; \
		  do $$STTYF /dev/tty >/dev/null 2>&1 && break ; \
		done ; \
		$$STTYF $(call get_arduino_port)  hupcl ; \
		(sleep 0.1 2>/dev/null || sleep 1) ; \
		$$STTYF $(call get_arduino_port) -hupcl

ispload:	$(TARGET_EEP) $(TARGET_HEX) verify_size
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) -e \
			-U lock:w:$(ISP_LOCK_FUSE_PRE):m \
			-U hfuse:w:$(ISP_HIGH_FUSE):m \
			-U lfuse:w:$(ISP_LOW_FUSE):m \
			-U efuse:w:$(ISP_EXT_FUSE):m
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) -D \
			$(AVRDUDE_ISPLOAD_OPTS)
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) \
			-U lock:w:$(ISP_LOCK_FUSE_POST):m

clean:
		$(REMOVE) $(LOCAL_OBJS) $(CORE_OBJS) $(LIB_OBJS) $(CORE_LIB) $(TARGETS) $(DEPS) $(USER_LIB_OBJS) ${OBJDIR}

size:		$(TARGET_HEX)
		$(call avr_size,$(TARGET_ELF),$(TARGET_HEX))

show_boards:
		$(PARSE_BOARD_CMD) --boards

monitor:
		$(MONITOR_CMD) $(call get_arduino_port) $(MONITOR_BAUDRATE)

disasm: $(OBJDIR)/$(TARGET).lss
	@$(ECHO) The compiled ELF file has been disassembled to $(OBJDIR)/$(TARGET).lss

symbol_sizes: $(OBJDIR)/$(TARGET).sym
	@$(ECHO) A symbol listing sorted by their size have been dumped to $(OBJDIR)/$(TARGET).sym

$(TARGET_HEX).sizeok: $(TARGET_HEX)
		$(ARDMK_PATH)/ard-verify-size $(TARGET_HEX) $(HEX_MAXIMUM_SIZE)
		touch $@

verify_size:	$(TARGET_HEX) $(TARGET_HEX).sizeok

generated_assembly: $(OBJDIR)/$(TARGET).s
	@$(ECHO) Compiler-generated assembly for the main input source has been dumped to $(OBJDIR)/$(TARGET).s

.PHONY:	all upload raw_upload raw_eeprom error_on_leonardo reset reset_stty ispload clean depends size show_boards monitor disasm symbol_sizes generated_assembly verify_size

# added - in the beginning, so that we don't get an error if the file is not present
-include $(DEPS)
