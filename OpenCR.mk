########################################################################
#
# Support for Robotis OpenCR boards 
#
# Written by Dowhan Jeong, EunJin Jeong
#
# Based on work that is copyright Jeremy Shaw, Sudar, Nicholas Zambetti,
# David A. Mellis & Hernando Barragan.
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
########################################################################

ifndef ARDUINO_DIR
echo $(error ARDUINO_DIR should be specified)
endif

ifndef BOARD_TAG
echo $(error BOARD_TAG should be specified. check board list with 'make show_boards')
endif

ifndef ARDMK_DIR
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif

include $(ARDMK_DIR)/Common.mk

ifndef ARDUINO_PACKAGE_DIR
    # attempt to find based on Linux, macOS and Windows default
    ARDUINO_PACKAGE_DIR := $(firstword \
        $(call dir_if_exists,$(HOME)/.arduino15/packages) \
        $(call dir_if_exists,$(ARDUINO_DIR)/packages) \
        $(call dir_if_exists,$(HOME)/Library/Arduino15/packages) \
        $(call dir_if_exists,$(realpath $(USERPROFILE))/AppData/Local/Arduino15/packages) )
    $(call show_config_variable,ARDUINO_PACKAGE_DIR,[AUTODETECTED],(from DEFAULT))
else
    $(call show_config_variable,ARDUINO_PACKAGE_DIR,[USER])
endif

ifndef ARDMK_VENDOR
    ARDMK_VENDOR         = OpenCR
endif

ifndef ARCHITECTURE
    ARCHITECTURE := OpenCR
endif

ifndef CORE_VER
    CORE_VER := $(wildcard $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/hardware/$(ARCHITECTURE)/1.*)
    ifneq ($(CORE_VER),)
        CORE_VER := $(shell basename $(CORE_VER))
        $(call show_config_variable,CORE_VER,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
    endif
else
    $(call show_config_variable,CORE_VER,[USER])
endif

ARCHITECTURE := sam

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

# Arduino Settings (will get shown in Arduino.mk as computed)
ifndef ALTERNATE_CORE_PATH
    ifdef CORE_VER
	ALTERNATE_CORE_PATH = $(ARDUINO_PACKAGE_DIR)/OpenCR/hardware/OpenCR/$(CORE_VER)
    else
	    echo $(error  Cannot find $(CORE_VER). Check directory settings.)
    endif
endif

ifndef ARDUINO_CORE_PATH
        ARDUINO_CORE_PATH= $(ALTERNATE_CORE_PATH)/cores/arduino
endif

ifndef BOARDS_TXT
        BOARDS_TXT= $(ALTERNATE_CORE_PATH)/boards.txt
endif

ifndef VARIANT
    VARIANT := $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
endif

ARDUINO_VAR_PATH = $(ALTERNATE_CORE_PATH)/variants/$(VARIANT)


# Check boards file exists before continuing as parsing non-existant file can create problems
ifneq ($(findstring boards.txt, $(wildcard $(ALTERNATE_CORE_PATH)/*.txt)), boards.txt)
    echo $(error $(CORE_VER) Cannot find boards file $(BOARDS_TXT). Check ?? and board support installed)
endif

# grab any sources in the variant core path.
# directorys were manually checked.
# Core sources(used to generate libcore.a archive)
OPENCR_CORE_C_SRCS_1 := $(wildcard $(ARDUINO_CORE_PATH)/avr/*.c)
OPENCR_CORE_C_SRCS_2 := $(wildcard $(ARDUINO_CORE_PATH)/*.c)
OPENCR_CORE_CPP_SRCS := $(wildcard $(ARDUINO_CORE_PATH)/*.cpp)

# library sources
OPENCR_LIB_C_SRCS_1 := $(wildcard $(ARDUINO_VAR_PATH)/bsp/opencr/*.c)
OPENCR_LIB_C_SRCS_2 := $(wildcard $(ARDUINO_VAR_PATH)/hw/*.c)
OPENCR_LIB_C_SRCS_3 := $(wildcard $(ARDUINO_VAR_PATH)/hw/driver/*.c)
OPENCR_LIB_C_SRCS_4 := $(wildcard $(ARDUINO_VAR_PATH)/hw/usb_cdc/*.c)
OPENCR_LIB_C_SRCS_5 := $(wildcard $(ARDUINO_VAR_PATH)/lib/STM32F7xx_HAL_Driver/Src/*.c)
OPENCR_LIB_CPP_SRCS := $(wildcard $(ARDUINO_VAR_PATH)/*.cpp)
OPENCR_LIB_S_SRCS := $(wildcard $(ARDUINO_VAR_PATH)/bsp/opencr/startup/*.S)

ifndef F_CPU
    F_CPU := $(call PARSE_BOARD,$(BOARD_TAG),build.f_cpu)
endif

OPENCR_LIB_OBJ_FILES = $(notdir $(OPENCR_LIB_C_SRCS_1:.c=.c.o)) $(notdir $(OPENCR_LIB_C_SRCS_2:.c=.c.o)) $(notdir $(OPENCR_LIB_C_SRCS_3:.c=.c.o)) $(notdir $(OPENCR_LIB_C_SRCS_4:.c=.c.o)) $(notdir $(OPENCR_LIB_C_SRCS_5:.c=.c.o)) $(notdir $(OPENCR_LIB_CPP_SRCS:.cpp=.cpp.o)) $(notdir $(OPENCR_LIB_S_SRCS:.S=.S.o))
    OTHER_OBJS = $(patsubst %, \
	   $(OBJDIR)/OpenCRlib/%, $(OPENCR_LIB_OBJ_FILES)) 

OPENCR_CORE_OBJ_FILES = $(notdir $(OPENCR_CORE_C_SRCS_1:.c=.c.o)) $(notdir $(OPENCR_CORE_C_SRCS_2:.c=.c.o)) $(notdir $(OPENCR_CORE_CPP_SRCS:.cpp=.cpp.o))
# override is used since opencr dosen't need other sam core objects
override CORE_OBJS = $(patsubst %, \
			 $(OBJDIR)/core/%, $(OPENCR_CORE_OBJ_FILES))

ifndef AVR_TOOLS_DIR
	AVR_TOOLS_DIR = $(call dir_if_exists,$(ARDUINO_PACKAGE_DIR)/OpenCR/tools/opencr_gcc/5.4.0-2016q2)
endif
ifeq ($(strip $(AVR_TOOLS_DIR)),)
    echo $(error $(AVR_TOOLS_DIR) Cannot find AVR_TOOLS_DIR. Check AVR_TOOLS_DIR)
endif

# Robotis OpenCR platform library directory
ifndef ARDUINO_PLATFORM_LIB_PATH
    ARDUINO_PLATFORM_LIB_PATH = $(ALTERNATE_CORE_PATH)/libraries
    $(call show_config_variable,ARDUINO_PLATFORM_LIB_PATH,[COMPUTED],(from OPENCR_DIR))
endif

########################################################################
# command names

TOOL_PREFIX = arm-none-eabi

# processor stuff
ifndef MCU
    MCU := $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
endif

ifndef MCU_FLAG_NAME
    MCU_FLAG_NAME=mcpu
endif

########################################################################
# FLAGS
ifndef USB_TYPE
    USB_TYPE = USB_SERIAL
endif

# from platform.txt
CPPFLAGS += -DARDUINO_OpenCR
CPPFLAGS += -DARDUINO_ARCH_OPENCR

CPPFLAGS += $(call PARSE_BOARD,$(BOARD_TAG),build.common_flags)

OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc1)
OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc2)
OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc3)
OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc4)
OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc5)
OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc6)
OPENCR_COMPILER_LIBS_C_FLAGS +=-I$(ARDUINO_VAR_PATH)/$(call PARSE_BOARD,$(BOARD_TAG),build.inc7)
CPPFLAGS += $(OPENCR_COMPILER_LIBS_C_FLAGS)

CFLAGS_STD += -c -g -O2 -std=gnu11 -mfloat-abi=softfp -mfpu=fpv5-sp-d16 -Wall -Wextra -DDEBUG_LEVEL=DEBUG_ALL -MMD -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -DBOARD_$(VARIANT)

CXXFLAGS_STD += -c -g -O2 -std=gnu++11 -mfloat-abi=softfp -mfpu=fpv5-sp-d16  -Wall -Wextra -DDEBUG_LEVEL=DEBUG_ALL -MMD -ffunction-sections -fdata-sections -nostdlib --param max-inline-insns-single=500 -fno-rtti -fno-exceptions -DBOARD_$(VARIANT)

ASFLAGS += -c -g -x assembler-with-cpp -MMD

LDFLAGS += -lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-unresolved-symbols -Wl,--start-group -Wl,--whole-archive

LINKER_SCRIPTS = -T$(ARDUINO_VAR_PATH)/bsp/opencr/ldscript/opencr_flash.ld
########################################################################
# Reset is handled by upload script. OpenCR don't neet reset command.
override RESET_CMD = 

########################################################################
# Object conversion & uploading magic, modified from Arduino.mk
override TARGET_HEX = $(OBJDIR)/$(TARGET).bin

override avr_size = $(SIZE) --target=binary $(2)

# Define UPLOAD_TOOL as avrdude to use avrdude upload recipe in Arduino.mk
override UPLOAD_TOOL = avrdude

ifeq ($(CURRENT_OS), WINDOWS)
    override AVRDUDE = $(ARDUINO_PACKAGE_DIR)/OpenCR/tools/opencr_tools/1.0.0/win/opencr_ld.exe
else
    override AVRDUDE = $(ARDUINO_PACKAGE_DIR)/OpenCR/tools/opencr_tools/1.0.0/linux/opencr_ld
endif
override AVRDUDE_COM_OPTS = $(DEVICE_PATH) 
override AVRDUDE_ISP_OPTS = 115200 $(TARGET_HEX) 1
override AVRDUDE_ISPLOAD_OPTS = 

########################################################################
# automatically include Arduino.mk

include $(ARDMK_DIR)/Arduino.mk

########################################################################

# OpenCR core files
$(OBJDIR)/core/%.c.o: $(ARDUINO_CORE_PATH)/avr/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/core/%.c.o: $(ARDUINO_CORE_PATH)/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/core/%.cpp.o: $(ARDUINO_CORE_PATH)/%.cpp $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CXX) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

# OpenCR lib files
$(OBJDIR)/OpenCRlib/%.c.o: $(ARDUINO_VAR_PATH)/bsp/opencr/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@
$(OBJDIR)/OpenCRlib/%.c.o: $(ARDUINO_VAR_PATH)/hw/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/OpenCRlib/%.c.o: $(ARDUINO_VAR_PATH)/hw/driver/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/OpenCRlib/%.c.o: $(ARDUINO_VAR_PATH)/hw/usb_cdc/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/OpenCRlib/%.c.o: $(ARDUINO_VAR_PATH)/lib/STM32F7xx_HAL_Driver/Src/%.c $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(CFLAGS) $< -o $@

$(OBJDIR)/OpenCRlib/%.cpp.o: $(ARDUINO_VAR_PATH)/%.cpp $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CXX) -MMD -c $(CPPFLAGS) $(CXXFLAGS) $< -o $@

$(OBJDIR)/OpenCRlib/%.S.o: $(ARDUINO_VAR_PATH)/bsp/opencr/startup/%.S $(COMMON_DEPS) | $(OBJDIR)
	@$(MKDIR) $(dir $@)
	$(CC) -MMD -c $(CPPFLAGS) $(ASFLAGS) $< -o $@

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

CORE_LIB += -Wl,--no-whole-archive -lstdc++
