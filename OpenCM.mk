########################################################################
#
# Support for Robotis OpenCM boards
#
# http://en.robotis.com/index/product.php?cate_code=131010
#
# You must install the OpenCM IDE for this Makefile to work:
#
# http://support.robotis.com/en/software/robotis_opencm/robotis_opencm.htm
#
# Based on work that is copyright Jeremy Shaw, Sudar, Nicholas Zambetti,
# David A. Mellis & Hernando Barragan.
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# Adapted from Teensy 3.x makefile which was adapted from Arduino 0011
# Makefile by M J Oldfield
#
# Original Arduino adaptation by mellis, eighthave, oli.keller
#
########################################################################

ifndef ARDMK_DIR
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif

# include Common.mk now we know where it is
include $(ARDMK_DIR)/Common.mk

ARDUINO_DIR = $(OPENCMIDE_DIR)

ifndef ARDMK_VENDOR
    ARDMK_VENDOR         = robotis
endif

ifndef ARDUINO_CORE_PATH
    ARDUINO_CORE_PATH    = $(ARDUINO_DIR)/hardware/robotis/cores/robotis
endif

ifndef BOARDS_TXT
    BOARDS_TXT           = $(ARDUINO_DIR)/hardware/$(ARDMK_VENDOR)/boards.txt
endif

ifndef PARSE_OPENCM
    # result = $(call READ_BOARD_TXT, 'boardname', 'parameter')
    PARSE_OPENCM = $(shell grep -v "^\#" "$(BOARDS_TXT)" | grep $(1).$(2) | cut -d = -f 2- )
endif

ifndef F_CPU
    F_CPU := $(call PARSE_OPENCM,$(BOARD_TAG),build.f_cpu)
endif

# if boards.txt gets modified, look there, else hard code it
ARCHITECTURE = $(call PARSE_OPENCM,$(BOARD_TAG),build.architecture)
ifeq ($(strip $(ARCHITECTURE)),)
    ARCHITECTURE = arm
endif

AVR_TOOLS_DIR = $(call dir_if_exists,$(ARDUINO_DIR)/hardware/tools/$(ARCHITECTURE))

# Robotis has moved the platform lib dir to their root folder
ifndef ARDUINO_PLATFORM_LIB_PATH
    ARDUINO_PLATFORM_LIB_PATH = $(ARDUINO_DIR)/libraries
    $(call show_config_variable,ARDUINO_PLATFORM_LIB_PATH,[COMPUTED],(from ARDUINO_DIR))
endif

ifndef ARDUINO_HEADER
    ARDUINO_HEADER = wirish.h
endif

########################################################################
# command names

ifndef CC_NAME
    CC_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.gcc)
    ifndef CC_NAME
        CC_NAME := arm-none-eabi-gcc
    else
        $(call show_config_variable,CC_NAME,[COMPUTED])
    endif
endif

ifndef CXX_NAME
    CXX_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.g++)
    ifndef CXX_NAME
        CXX_NAME := arm-none-eabi-g++
    else
        $(call show_config_variable,CXX_NAME,[COMPUTED])
    endif
endif

ifndef AS_NAME
    AS_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.as)
    ifndef AS_NAME
        AS_NAME := arm-none-eabi-as
    else
        $(call show_config_variable,AS_NAME,[COMPUTED])
    endif
endif

ifndef OBJDUMP_NAME
    OBJDUMP_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.objdump)
    ifndef OBJDUMP_NAME
        OBJDUMP_NAME := arm-none-eabi-objdump
    else
        $(call show_config_variable,OBJDUMP_NAME,[COMPUTED])
    endif
endif

ifndef AR_NAME
    AR_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.ar)
    ifndef AR_NAME
        AR_NAME := arm-none-eabi-ar
    else
        $(call show_config_variable,AR_NAME,[COMPUTED])
    endif
endif

ifndef SIZE_NAME
    SIZE_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.size)
    ifndef SIZE_NAME
        SIZE_NAME := arm-none-eabi-size
    else
        $(call show_config_variable,SIZE_NAME,[COMPUTED])
    endif
endif

ifndef NM_NAME
    NM_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.nm)
    ifndef NM_NAME
        NM_NAME := arm-none-eabi-nm
    else
        $(call show_config_variable,NM_NAME,[COMPUTED])
    endif
endif

ifndef OBJCOPY_NAME
    OBJCOPY_NAME := $(call PARSE_OPENCM,$(BOARD_TAG),build.command.objcopy)
    ifndef OBJCOPY_NAME
        OBJCOPY_NAME := arm-none-eabi-objcopy
    else
        $(call show_config_variable,OBJCOPY_NAME,[COMPUTED])
    endif
endif

# processor stuff
ifndef MCU
    MCU := $(call PARSE_OPENCM,$(BOARD_TAG),build.family)
endif

ifndef MCU_FLAG_NAME
    MCU_FLAG_NAME=mcpu
endif

########################################################################
# FLAGS
ifndef USB_TYPE
    USB_TYPE = USB_SERIAL
endif

CPPFLAGS += -DBOARD_$(call PARSE_OPENCM,$(BOARD_TAG),build.board)
CPPFLAGS += -DMCU_$(call PARSE_OPENCM,$(BOARD_TAG),build.mcu)
CPPFLAGS += -DSTM32_MEDIUM_DENSITY -DVECT_TAB_FLASH

CPPFLAGS += $(call PARSE_OPENCM,$(BOARD_TAG),build.option)

CXXFLAGS += -fno-rtti

CXXFLAGS += $(call PARSE_OPENCM,$(BOARD_TAG),build.cppoption)
ifeq ("$(call PARSE_OPENCM,$(BOARD_TAG),build.gnu0x)","true")
    CXXFLAGS_STD += -std=gnu++0x
endif

ifeq ("$(call PARSE_OPENCM,$(BOARD_TAG),build.elide_constructors)", "true")
    CXXFLAGS += -felide-constructors
endif

CPPFLAGS += -mthumb -march=armv7-m -nostdlib -Wl,--gc-sections -Wall

LDFLAGS += -T$(ARDUINO_DIR)/hardware/robotis/cores/robotis/CM900/flash.ld
LDFLAGS += -L$(ARDUINO_CORE_PATH)
LDFLAGS += -mthumb -Xlinker --gc-sections -Wall

OTHER_LIBS += -lstdc++

########################################################################
# Reset is handled by upload script
override RESET_CMD = 

########################################################################
# Object conversion & uploading magic, modified from Arduino.mk
override TARGET_HEX = $(OBJDIR)/$(TARGET).bin

ifndef AVRDUDE
    AVRDUDE := $(shell which robotis-loader 2>/dev/null)
    ifndef AVRDUDE
        AVRDUDE = $(ARDMK_DIR)/bin/robotis-loader
    endif
endif

override avr_size = $(SIZE) --target=binary $(2)

override AVRDUDE_COM_OPTS = 
ifeq ($(CURRENT_OS), WINDOWS)
    override AVRDUDE_ARD_OPTS = $(COM_STYLE_MONITOR_PORT)
else
    override AVRDUDE_ARD_OPTS = $(call get_monitor_port)
endif
	
override AVRDUDE_UPLOAD_HEX = $(TARGET_HEX)

########################################################################
# automatically include Arduino.mk

include $(ARDMK_DIR)/Arduino.mk

########################################################################
# Object conversion & uploading magic, modified from Arduino.mk

$(OBJDIR)/%.bin: $(OBJDIR)/%.elf $(COMMON_DEPS)
	@$(MKDIR) $(dir $@)
	$(OBJCOPY) -v -Obinary $< $@
	@$(ECHO) '\n'
	$(call avr_size,$<,$@)
ifneq ($(strip $(HEX_MAXIMUM_SIZE)),)
	@if [ `$(SIZE) --target=binary $@ | awk 'FNR == 2 {print $$2}'` -le $(HEX_MAXIMUM_SIZE) ]; then touch $@.sizeok; fi
else
	@$(ECHO) "Maximum flash memory of $(BOARD_TAG) is not specified. Make sure the size of $@ is less then $(BOARD_TAG)\'s flash memory"
	@touch $@.sizeok
endif

# link fails to plug _sbrk into libc if core is a lib, seems a bug in the linker
CORE_LIB = $(CORE_OBJS)
