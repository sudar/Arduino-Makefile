########################################################################
#
# Arduino command line tools Makefile
# System part (i.e. project independent)
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
# Version 0.1  17.ii.2009  M J Oldfield
#
#         0.2  22.ii.2009  M J Oldfield
#                          - fixes so that the Makefile actually works!
#                          - support for uploading via ISP
#                          - orthogonal choices of using the Arduino for
#                            tools, libraries and uploading
#
#         0.3  21.v.2010   M J Oldfield
#                          - added proper license statement
#                          - added code from Philip Hands to reset
#                            Arduino prior to upload
#
#         0.4  25.v.2010   M J Oldfield
#                          - tweaked reset target on Philip Hands' advice
#
#         0.5  23.iii.2011 Stefan Tomanek
#                          - added ad-hoc library building
#              17.v.2011   M J Oldfield
#                          - grabbed said version from Ubuntu
#
#         0.6  22.vi.2011  M J Oldfield
#                          - added ard-parse-boards supports
#                          - added -lc to linker opts, 
#                            on Fabien Le Lez's advice
#
#         0.7  12.vii.2011 M J Oldfield
#                          - moved -lm to the end of linker opts,
#	                     to solve Frank Knopf's problem;
#                          - added -F to stty opts: Craig Hollabaugh 
#	                     reckons it's good for Ubuntu
#
#         0.8  12.ii.2012  M J Oldfield
#                          - Patches for Arduino 1.0 IDE:
#                              support .ino files;
#                              handle board 'variants';
#                              tweaked compile flags.
#                          - Build a library from all the system
#                            supplied code rather than linking the .o
#                            files directly.
#                          - Let TARGET default to current directory
#			     as per Daniele Vergini's patch.
#                          - Add support for .c files in system
#                            libraries: Dirk-Willem van Gulik and Evan
#                            Goldenberg both reported this and
#                            provided patches in the same spirit.
#
#          0.9 26.iv.2012  M J Oldfield
#                          - Allow the punter to specify boards.txt
#                            file and parser independently (after
#                            Peplin and Brotchie on github)
#			   - Support user libraries (Peplin's patch)
#                          - Remove main.cpp if NO_CORE_MAIN_CPP is
#                            defined (ex Peplin)
#                          - Added a monitor target which talks to the
#                            Arduino serial port (Peplin's suggestion)
#                          - Rejigged PATH calculations for general 
#                            tidiness (ex Peplin)
#                          - Moved the reset target to Perl for
#                            clarity and better error handling (ex
#                            Daniele Vergini)
#                      
########################################################################
#
# PATHS YOU NEED TO SET UP
#
# I've reworked the way paths to executables are constructed in this
# version (0.9) of the Makefile.
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
# If you don't install the ard-... binaries to /usr/local/bin, but
# instead copy them to e.g. /home/mjo/arduino.mk/bin then set
#   ARDML_DIR = /home/mjo/arduino.mk
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
#                   assume these are in
#                   $(ARDUINO_DIR)/hardware/libraries 
#
#    ARDUINO_PORT - The port where the Arduino can be found (only needed
#                   when uploading
#
#    BOARD_TAG    - The ard-parse-boards tag for the board e.g. uno or mega
#                   'make show_boards' shows a list
#
# Once this file has been created the typical workflow is just
#
#   $ make upload
#
# All of the object files are created in the build-cli subdirectory
# All sources should be in the current directory and can include:
#  - at most one .pde or .ino file which will be treated as C++ after
#    the standard Arduino header and footer have been affixed.
#  - any number of .c, .cpp, .s and .h files
#
# Included libraries are built in the build-cli/libs subdirectory.
#
# Besides make upload you can also
#   make             - no upload
#   make clean       - remove all our dependencies
#   make depends     - update dependencies
#   make reset       - reset the Arduino by tickling DTR on the serial port
#   make raw_upload  - upload without first resetting
#   make show_boards - list all the boards defined in boards.txt
#   make monitor     - connect to the Arduino's serial port
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
# don't set it, it defaults to 9600 baud.
#
########################################################################
#
# PATHS
#
# I've reworked the way paths to executables are constructed in this
# version of Makefile.
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
# So, on the Mac you might want to set:
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
#
#  
#
########################################################################
#
# ARDUINO WITH ISP
#
# You need to specify some details of your ISP programmer and might
# also need to specify the fuse values:
#
#     ISP_PROG	   = -c stk500v2
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
# I think the fuses here are fine for uploading to the ATmega168
# without bootloader.
# 
# To actually do this upload use the ispload target:
#
#    make ispload
#
#
########################################################################

########################################################################
# 
# Default TARGET to cwd (ex Daniele Vergini)
ifndef TARGET
TARGET  = $(notdir $(CURDIR))
endif

########################################################################

#
# Arduino version number
ifndef ARDUINO_VERSION
ARDUINO_VERSION = 100
endif

########################################################################
# Arduino and system paths
#
ifdef ARDUINO_DIR

ifndef AVR_TOOLS_DIR
AVR_TOOLS_DIR     = $(ARDUINO_DIR)/hardware/tools/avr
# The avrdude bundled with Arduino can't find it's config
AVRDUDE_CONF	  = $(AVR_TOOLS_DIR)/etc/avrdude.conf
endif

ifndef AVR_TOOLS_PATH
AVR_TOOLS_PATH    = $(AVR_TOOLS_DIR)/bin
endif

ARDUINO_LIB_PATH  = $(ARDUINO_DIR)/libraries
ARDUINO_CORE_PATH = $(ARDUINO_DIR)/hardware/arduino/cores/arduino
ARDUINO_VAR_PATH  = $(ARDUINO_DIR)/hardware/arduino/variants

else

echo $(error "ARDUINO_DIR is not defined")

endif

########################################################################
# Makefile distribution path
#
ifdef ARDMK_DIR

ifndef ARDMK_PATH
ARDMK_PATH = $(ARDMK_DIR)/bin
endif

else

echo $(error "ARDMK_DIR is not defined")

endif

########################################################################
# Miscellanea
#
ifndef ARDUINO_SKETCHBOOK
ARDUINO_SKETCHBOOK = $(HOME)/sketchbook
endif

ifndef USER_LIB_PATH
USER_LIB_PATH = $(ARDUINO_SKETCHBOOK)/libraries
endif

########################################################################
# Serial monitor (just a screen wrapper)
#
# Quite how to construct the monitor command seems intimately tied
# to the command we're using (here screen). So, read the screen docs
# for more information (search for 'character special device').
#
ifndef MONITOR_BAUDRATE
MONITOR_BAUDRATE = 9600
endif

ifndef MONITOR_CMD
MONITOR_CMD = screen
endif

########################################################################
# Reset
ifndef RESET_CMD
RESET_CMD = $(ARDMK_PATH)/ard-reset-arduino $(ARD_RESET_OPTS)
endif

########################################################################
# boards.txt parsing
#
ifndef BOARD_TAG
BOARD_TAG   = uno
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

# Everything gets built in here
OBJDIR  	  = build-cli

########################################################################
# Local sources
#
LOCAL_C_SRCS    = $(wildcard *.c)
LOCAL_CPP_SRCS  = $(wildcard *.cpp)
LOCAL_CC_SRCS   = $(wildcard *.cc)
LOCAL_PDE_SRCS  = $(wildcard *.pde)
LOCAL_INO_SRCS  = $(wildcard *.ino)
LOCAL_AS_SRCS   = $(wildcard *.S)
LOCAL_OBJ_FILES = $(LOCAL_C_SRCS:.c=.o)   $(LOCAL_CPP_SRCS:.cpp=.o) \
		$(LOCAL_CC_SRCS:.cc=.o)   $(LOCAL_PDE_SRCS:.pde=.o) \
		$(LOCAL_INO_SRCS:.ino=.o) $(LOCAL_AS_SRCS:.S=.o)
LOCAL_OBJS      = $(patsubst %,$(OBJDIR)/%,$(LOCAL_OBJ_FILES))

# Dependency files
DEPS            = $(LOCAL_OBJS:.o=.d)

# core sources
ifeq ($(strip $(NO_CORE)),)
ifdef ARDUINO_CORE_PATH
CORE_C_SRCS     = $(wildcard $(ARDUINO_CORE_PATH)/*.c)
CORE_CPP_SRCS   = $(wildcard $(ARDUINO_CORE_PATH)/*.cpp)

ifneq ($(strip $(NO_CORE_MAIN_CPP)),)
CORE_CPP_SRCS := $(filter-out %main.cpp, $(CORE_CPP_SRCS))
endif

CORE_OBJ_FILES  = $(CORE_C_SRCS:.c=.o) $(CORE_CPP_SRCS:.cpp=.o)
CORE_OBJS       = $(patsubst $(ARDUINO_CORE_PATH)/%,  \
			$(OBJDIR)/%,$(CORE_OBJ_FILES))
endif
endif


########################################################################
# Rules for making stuff
#

# The name of the main targets
TARGET_HEX = $(OBJDIR)/$(TARGET).hex
TARGET_ELF = $(OBJDIR)/$(TARGET).elf
TARGETS    = $(OBJDIR)/$(TARGET).*
CORE_LIB   = $(OBJDIR)/libcore.a

# A list of dependencies
DEP_FILE   = $(OBJDIR)/depends.mk

# Names of executables
CC      = $(AVR_TOOLS_PATH)/avr-gcc
CXX     = $(AVR_TOOLS_PATH)/avr-g++
OBJCOPY = $(AVR_TOOLS_PATH)/avr-objcopy
OBJDUMP = $(AVR_TOOLS_PATH)/avr-objdump
AR      = $(AVR_TOOLS_PATH)/avr-ar
SIZE    = $(AVR_TOOLS_PATH)/avr-size
NM      = $(AVR_TOOLS_PATH)/avr-nm
REMOVE  = rm -f
MV      = mv -f
CAT     = cat
ECHO    = echo

# General arguments
SYS_LIBS      = $(patsubst %,$(ARDUINO_LIB_PATH)/%,$(ARDUINO_LIBS))
USER_LIBS     = $(patsubst %,$(USER_LIB_PATH)/%,$(ARDUINO_LIBS))
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

CPPFLAGS      = -mmcu=$(MCU) -DF_CPU=$(F_CPU) -DARDUINO=$(ARDUINO_VERSION) \
			-I. -I$(ARDUINO_CORE_PATH) -I$(ARDUINO_VAR_PATH)/$(VARIANT) \
			$(SYS_INCLUDES) $(USER_INCLUDES) -g -Os -w -Wall \
			-ffunction-sections -fdata-sections
CFLAGS        = -std=gnu99
CXXFLAGS      = -fno-exceptions
ASFLAGS       = -mmcu=$(MCU) -I. -x assembler-with-cpp
LDFLAGS       = -mmcu=$(MCU) -Wl,--gc-sections -Os

# Expand and pick the first port
ARD_PORT      = $(firstword $(wildcard $(ARDUINO_PORT)))

# Implicit rules for building everything (needed to get everything in
# the right directory)
#
# Rather than mess around with VPATH there are quasi-duplicate rules
# here for building e.g. a system C++ file and a local C++
# file. Besides making things simpler now, this would also make it
# easy to change the build options in future

# library sources
$(OBJDIR)/libs/%.o: $(ARDUINO_LIB_PATH)/%.c
	mkdir -p $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/libs/%.o: $(ARDUINO_LIB_PATH)/%.cpp
	mkdir -p $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/libs/%.o: $(USER_LIB_PATH)/%.cpp
	mkdir -p $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/libs/%.o: $(USER_LIB_PATH)/%.c
	mkdir -p $(dir $@)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

# normal local sources
# .o rules are for objects, .d for dependency tracking
# there seems to be an awful lot of duplication here!!!
$(OBJDIR)/%.o: %.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/%.o: %.cc
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.o: %.cpp
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.o: %.S
	$(CC) -c $(CPPFLAGS) $(ASFLAGS) $< -o $@

$(OBJDIR)/%.o: %.s
	$(CC) -c $(CPPFLAGS) $(ASFLAGS) $< -o $@

$(OBJDIR)/%.d: %.c
	$(CC) -MM $(CPPFLAGS) $(CFLAGS) $< -MF $@ -MT $(@:.d=.o)

$(OBJDIR)/%.d: %.cc
	$(CXX) -MM $(CPPFLAGS) $(CXXFLAGS) $< -MF $@ -MT $(@:.d=.o)

$(OBJDIR)/%.d: %.cpp
	$(CXX) -MM $(CPPFLAGS) $(CXXFLAGS) $< -MF $@ -MT $(@:.d=.o)

$(OBJDIR)/%.d: %.S
	$(CC) -MM $(CPPFLAGS) $(ASFLAGS) $< -MF $@ -MT $(@:.d=.o)

$(OBJDIR)/%.d: %.s
	$(CC) -MM $(CPPFLAGS) $(ASFLAGS) $< -MF $@ -MT $(@:.d=.o)

# the pde -> cpp -> o file
$(OBJDIR)/%.cpp: %.pde
	$(ECHO) '#include "WProgram.h"' > $@
	$(CAT)  $< >> $@

# the ino -> cpp -> o file
$(OBJDIR)/%.cpp: %.ino
	$(ECHO) '#include <Arduino.h>' > $@
	$(CAT)  $< >> $@

$(OBJDIR)/%.o: $(OBJDIR)/%.cpp
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/%.d: $(OBJDIR)/%.cpp
	$(CXX) -MM $(CPPFLAGS) $(CXXFLAGS) $< -MF $@ -MT $(@:.d=.o)

# core files
$(OBJDIR)/%.o: $(ARDUINO_CORE_PATH)/%.c
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/%.o: $(ARDUINO_CORE_PATH)/%.cpp
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

# various object conversions
$(OBJDIR)/%.hex: $(OBJDIR)/%.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(OBJDIR)/%.eep: $(OBJDIR)/%.elf
	-$(OBJCOPY) -j .eeprom --set-section-flags=.eeprom="alloc,load" \
		--change-section-lma .eeprom=0 -O ihex $< $@

$(OBJDIR)/%.lss: $(OBJDIR)/%.elf
	$(OBJDUMP) -h -S $< > $@

$(OBJDIR)/%.sym: $(OBJDIR)/%.elf
	$(NM) -n $< > $@

########################################################################
#
# Avrdude
#
ifndef AVRDUDE
AVRDUDE          = $(AVR_TOOLS_PATH)/avrdude
endif

AVRDUDE_COM_OPTS = -q -V -p $(MCU)
ifdef AVRDUDE_CONF
AVRDUDE_COM_OPTS += -C $(AVRDUDE_CONF)
endif

AVRDUDE_ARD_OPTS = -c $(AVRDUDE_ARD_PROGRAMMER) -b $(AVRDUDE_ARD_BAUDRATE) -P $(ARD_PORT)

ifndef ISP_PROG
ISP_PROG	   = -c stk500v2
endif

AVRDUDE_ISP_OPTS = -P $(ISP_PORT) $(ISP_PROG)


########################################################################
#
# Explicit targets start here
#

all: 		$(OBJDIR) $(TARGET_HEX)

$(OBJDIR):
		mkdir $(OBJDIR)

$(TARGET_ELF): 	$(LOCAL_OBJS) $(CORE_LIB) $(OTHER_OBJS)
		$(CC) $(LDFLAGS) -o $@ $(LOCAL_OBJS) $(CORE_LIB) $(OTHER_OBJS) -lc -lm

$(CORE_LIB):	$(CORE_OBJS) $(LIB_OBJS) $(USER_LIB_OBJS)
		$(AR) rcs $@ $(CORE_OBJS) $(LIB_OBJS) $(USER_LIB_OBJS)

$(DEP_FILE):	$(OBJDIR) $(DEPS)
		cat $(DEPS) > $(DEP_FILE)

upload:		reset raw_upload

raw_upload:	$(TARGET_HEX)
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ARD_OPTS) \
			-U flash:w:$(TARGET_HEX):i

reset:		
		$(RESET_CMD) $(ARD_PORT)

# stty on MacOS likes -F, but on Debian it likes -f redirecting
# stdin/out appears to work but generates a spurious error on MacOS at
# least. Perhaps it would be better to just do it in perl ?
reset_stty:		
		for STTYF in 'stty -F' 'stty --file' 'stty -f' 'stty <' ; \
		  do $$STTYF /dev/tty >/dev/null 2>/dev/null && break ; \
		done ;\
		$$STTYF $(ARD_PORT)  hupcl ;\
		(sleep 0.1 || sleep 1)     ;\
		$$STTYF $(ARD_PORT) -hupcl 

ispload:	$(TARGET_HEX)
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) -e \
			-U lock:w:$(ISP_LOCK_FUSE_PRE):m \
			-U hfuse:w:$(ISP_HIGH_FUSE):m \
			-U lfuse:w:$(ISP_LOW_FUSE):m \
			-U efuse:w:$(ISP_EXT_FUSE):m
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) -D \
			-U flash:w:$(TARGET_HEX):i
		$(AVRDUDE) $(AVRDUDE_COM_OPTS) $(AVRDUDE_ISP_OPTS) \
			-U lock:w:$(ISP_LOCK_FUSE_POST):m

clean:
		$(REMOVE) $(LOCAL_OBJS) $(CORE_OBJS) $(LIB_OBJS) $(CORE_LIB) $(TARGETS) $(DEP_FILE) $(DEPS) $(USER_LIB_OBJS)

depends:	$(DEPS)
		cat $(DEPS) > $(DEP_FILE)

size:		$(OBJDIR) $(TARGET_HEX)
		$(SIZE) $(TARGET_HEX)

show_boards:	
		$(PARSE_BOARD_CMD) --boards

monitor:
		$(MONITOR_CMD) $(ARD_PORT) $(MONITOR_BAUDRATE)

.PHONY:	all clean depends upload raw_upload reset reset_stty size show_boards monitor

include $(DEP_FILE)
