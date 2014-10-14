########################################################################
#
# To use you will need to uncomment these lines in,
#  $(ARDUINO_DIR)/hardware/$(VENDOR)/boards.txt
#
# teensy31.build.option6=-DUSB_SERIAL
# teensy31.build.option7=-DLAYOUT_US_ENGLISH
#

VENDOR              = teensy
ARDUINO_CORE_PATH   = $(ARDUINO_DIR)/hardware/teensy/cores/teensy3
BOARDS_TXT          = $(ARDUINO_DIR)/hardware/$(VENDOR)/boards.txt

ifndef F_CPU
    F_CPU=72000000
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
        CC_NAME := avr-gcc
    else
        $(call show_config_variable,CC_NAME,[COMPUTED])
    endif
endif

ifndef CXX_NAME
    CXX_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.g++)
    ifndef CXX_NAME
        CXX_NAME := avr-g++
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
        OBJCOPY_NAME := avr-objcopy
    else
        $(call show_config_variable,OBJCOPY_NAME,[COMPUTED])
    endif
endif

ifndef OBJDUMP_NAME
    OBJDUMP_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.objdump)
    ifndef OBJDUMP_NAME
        OBJDUMP_NAME := avr-objdump
    else
        $(call show_config_variable,OBJDUMP_NAME,[COMPUTED])
    endif
endif

ifndef AR_NAME
    AR_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.ar)
    ifndef AR_NAME
        AR_NAME := avr-ar
    else
        $(call show_config_variable,AR_NAME,[COMPUTED])
    endif
endif

ifndef SIZE_NAME
    SIZE_NAME := $(call PARSE_TEENSY,$(BOARD_TAG),build.command.size)
    ifndef SIZE_NAME
        SIZE_NAME := avr-size
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
    ifndef MCU
        MCU := $(call PARSE_TEENSY,$(BOARD_TAG),build.mcu)
    else
        MCU_FLAG_NAME=mcpu
    endif
endif

########################################################################
# FLAGS

CPPFLAGS += -DLAYOUT_US_ENGLISH -DUSB_SERIAL
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

MONITOR_PORT = /bin/true
AVRDUDE      = true

RESET_CMD = nohup $(ARDUINO_DIR)/hardware/tools/teensy_post_compile -board=$(BOARD_TAG) -tools=$(abspath $(ARDUINO_DIR)/hardware/tools) -path=$(abspath $(OBJDIR)) -file=$(TARGET) > /dev/null ; $(ARDUINO_DIR)/hardware/tools/teensy_reboot ; true

ifndef ARDMK_DIR
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif

include $(ARDMK_DIR)/Arduino.mk
