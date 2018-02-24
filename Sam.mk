########################################################################
#
# Support for Arduino Atmel SAM boards (sam and samd)
#
# You must install a SAM board hardware support package (such as Arduino Zero)
# to use this, then define ARDUINO_PACKAGE_DIR as the path to the root
# directory containing the support package.
#
# 2018 John Whittington @j_whittington
#
########################################################################

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

ifndef ARDMK_DIR
    ARDMK_DIR := $(realpath $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
endif

# include Common.mk now we know where it is
ifndef COMMON_INCLUDED
    include $(ARDMK_DIR)/Common.mk
endif

ifndef ARDUINO_PACKAGE_DIR
    # attempt to find based on Linux, macOS and Windows default
    ARDUINO_PACKAGE_DIR := $(firstword \
        $(call dir_if_exists,$(HOME)/.arduino15/packages) \
        $(call dir_if_exists,$(ARDUINO_DIR)/packages) \
        $(call dir_if_exists,$(HOME)/Library/Arduino15/packages) \
        $(call dir_if_exists,$(USERPROFILE)/AppData/Local/Arduino15/packages) )
    $(call show_config_variable,ARDUINO_PACKAGE_DIR,[AUTODETECTED],(from DEFAULT))
else
    $(call show_config_variable,ARDUINO_PACKAGE_DIR,[USER])
endif

ifndef ARDMK_VENDOR
    ARDMK_VENDOR := arduino
endif

ifndef ARCHITECTURE
    ARCHITECTURE := samd
endif

ifndef CORE_VER
    CORE_VER := $(wildcard $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/hardware/$(ARCHITECTURE)/1.*)
    ifdef CORE_VER
        CORE_VER := $(shell basename $(CORE_VER))
        $(call show_config_variable,CORE_VER,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
    endif
else
    $(call show_config_variable,CORE_VER,[USER])
endif

ifndef CMSIS_VER
    CMSIS_VER := $(shell basename $(wildcard $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/CMSIS/4.*))
    $(call show_config_variable,CMSIS_VER,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
else
    $(call show_config_variable,CMSIS_VER,[USER])
endif

ifndef CMSIS_ATMEL_VER
    CMSIS_ATMEL_VER := $(shell basename $(wildcard $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/CMSIS-Atmel/1.*))
    $(call show_config_variable,CMSIS_ATMEL_VER,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
else
    $(call show_config_variable,CMSIS_ATMEL_VER,[USER])
endif

ifndef CMSIS_DIR
    CMSIS_DIR := $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/CMSIS/$(CMSIS_VER)/CMSIS
    $(call show_config_variable,CMSIS_DIR,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
else
    $(call show_config_variable,CMSIS_DIR,[USER])
endif

ifndef CMSIS_ATMEL_DIR
    CMSIS_ATMEL_DIR := $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/CMSIS-Atmel/$(CMSIS_ATMEL_VER)/CMSIS
    $(call show_config_variable,CMSIS_ATMEL_DIR,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
else
    $(call show_config_variable,CMSIS_ATMEL_DIR,[USER])
endif

# Arduino Settings (will get shown in Arduino.mk as computed)
ifndef ALTERNATE_CORE_PATH
    ifdef CORE_VER
        ALTERNATE_CORE_PATH = $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/hardware/$(ARCHITECTURE)/$(CORE_VER)
    else
        ALTERNATE_CORE_PATH = $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/hardware/$(ARCHITECTURE)
    endif
endif
ifndef ARDUINO_CORE_PATH
    ARDUINO_CORE_PATH   = $(ALTERNATE_CORE_PATH)/cores/arduino
endif
ifndef BOARD_TXT
    BOARDS_TXT          = $(ALTERNATE_CORE_PATH)/boards.txt
endif

# Check boards file exists before continuing as parsing non-existant file can create problems
ifneq ($(findstring boards.txt, $(wildcard $(ALTERNATE_CORE_PATH)/*.txt)), boards.txt)
    echo $(error $(CORE_VER) Cannot find boards file $(BOARDS_TXT). Check ARDUINO_PACKAGE_DIR path: $(ARDUINO_PACKAGE_DIR) and board support installed)
endif

# add CMSIS includes
CPPFLAGS += -I$(CMSIS_DIR)/Include/
CPPFLAGS += -I$(CMSIS_ATMEL_DIR)/Device/ATMEL
# path for Cortex library
LIB_PATH  =  $(CMSIS_DIR)/Lib/GCC
BOOTLOADER_PARENT = $(ALTERNATE_CORE_PATH)/bootloaders

# Utility from ard-mk to parse boards.txt for flags
ifndef PARSE_BOARD
    PARSE_BOARD = $(shell grep -Ev '^\#' $(BOARDS_TXT) | grep -E '^[ \t]*$(1).$(2)=' | cut -d = -f 2 | cut -d : -f 2)
endif

ifndef VARIANT
    VARIANT := $(call PARSE_BOARD,$(BOARD_TAG),menu.(chip|cpu).$(BOARD_SUB).build.variant)
    ifndef VARIANT
        VARIANT := $(call PARSE_BOARD,$(BOARD_TAG),build.variant)
    endif
endif

# grab any sources in the variant core path (variant.cpp defines pin/port mapping on SAM devices)
ALT_CORE_C_SRCS := $(wildcard $(ALTERNATE_CORE_PATH)/variants/$(VARIANT)/*.c)
ALT_CORE_CPP_SRCS := $(wildcard $(ALTERNATE_CORE_PATH)/variants/$(VARIANT)/*.cpp)
ALT_CORE_S_SRCS := $(wildcard $(ALTERNATE_CORE_PATH)/variants/$(VARIANT)/*.S)

# Use arm-toolchain from Arduino install if exists and user has not defined global version
ifndef ARM_TOOLS_DIR
    ARM_TOOLS_DIR = $(call dir_if_exists,$(wildcard $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/arm-none-eabi-gcc/*))
    $(call show_config_variable,ARM_TOOLS_DIR,[COMPUTED],(from ARDUINO_PACKAGE_DIR))
else
    $(call show_config_variable,ARM_TOOLS_DIR,[USER])
endif

# define plaform lib dir from Arduino ARM support
ifndef ARDUINO_PLATFORM_LIB_PATH
    ARDUINO_PLATFORM_LIB_PATH := $(ALTERNATE_CORE_PATH)/libraries
    $(call show_config_variable,ARDUINO_PLATFORM_LIB_PATH,[COMPUTED],(from ARDUINO_PACKAGE_DIR))
endif

########################################################################
# command names

ifndef CC_NAME
    CC_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.gcc)
    ifndef CC_NAME
        CC_NAME := arm-none-eabi-gcc
    else
        $(call show_config_variable,CC_NAME,[COMPUTED])
    endif
endif

ifndef CXX_NAME
    CXX_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.g++)
    ifndef CXX_NAME
        CXX_NAME := arm-none-eabi-g++
    else
        $(call show_config_variable,CXX_NAME,[COMPUTED])
    endif
endif

ifndef AS_NAME
    AS_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.as)
    ifndef AS_NAME
        AS_NAME := arm-none-eabi-gcc-as
    else
        $(call show_config_variable,AS_NAME,[COMPUTED])
    endif
endif

ifndef OBJCOPY_NAME
    OBJCOPY_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.objcopy)
    ifndef OBJCOPY_NAME
        OBJCOPY_NAME := arm-none-eabi-objcopy
    else
        $(call show_config_variable,OBJCOPY_NAME,[COMPUTED])
    endif
endif

ifndef OBJDUMP_NAME
    OBJDUMP_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.objdump)
    ifndef OBJDUMP_NAME
        OBJDUMP_NAME := arm-none-eabi-objdump
    else
        $(call show_config_variable,OBJDUMP_NAME,[COMPUTED])
    endif
endif

ifndef AR_NAME
    AR_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.ar)
    ifndef AR_NAME
        AR_NAME := arm-none-eabi-ar
    else
        $(call show_config_variable,AR_NAME,[COMPUTED])
    endif
endif

ifndef SIZE_NAME
    SIZE_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.size)
    ifndef SIZE_NAME
        SIZE_NAME := arm-none-eabi-size
    else
        $(call show_config_variable,SIZE_NAME,[COMPUTED])
    endif
endif

ifndef NM_NAME
    NM_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.nm)
    ifndef NM_NAME
        NM_NAME := arm-none-eabi-gcc-nm
    else
        $(call show_config_variable,NM_NAME,[COMPUTED])
    endif
endif

ifndef GDB_NAME
    GDB_NAME := $(call PARSE_BOARD,$(BOARD_TAG),build.command.gdb)
    ifndef GDB_NAME
        GDB_NAME := arm-none-eabi-gdb
    else
        $(call show_config_variable,GDB_NAME,[COMPUTED])
    endif
endif

ifndef UPLOAD_TOOL
    UPLOAD_TOOL := $(call PARSE_BOARD,$(BOARD_TAG),upload.tool)
    ifndef UPLOAD_TOOL
        UPLOAD_TOOL := openocd
    else
        $(call show_config_variable,UPLOAD_TOOL,[COMPUTED])
    endif
endif

ifndef BOOTLOADER_UPLOAD_TOOL
    BOOTLOADER_UPLOAD_TOOL := $(call PARSE_BOARD,$(BOARD_TAG),bootloader.tool)
    ifndef BOOTLOADER_UPLOAD_TOOL
        BOOTLOADER_UPLOAD_TOOL := openocd
    else
        $(call show_config_variable,BOOTLOADER_UPLOAD_TOOL,[COMPUTED])
    endif
endif

# processor stuff
ifndef MCU
    MCU := $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
endif

ifndef MCU_FLAG_NAME
    MCU_FLAG_NAME=mcpu
endif

# native port emulates an AVR chip to use AVRDUDE
ifndef AVRDUDE_MCU
    AVRDUDE_MCU := $(call PARSE_BOARD,$(BOARD_TAG),build.emu.mcu)
endif

# GDP settings
ifndef GDB_PORT
    # default to localhost default OpenOCD port
    GDB_PORT = localhost:3333
endif

ifndef GDB_OPTS
    # if using BMP do a scan and attach
    ifeq ($(findstring /dev/tty, $(strip $(GDB_PORT))), /dev/tty)
        GDB_OPTS = -ex "target extended-remote $(GDB_PORT)" -ex "monitor swdp_scan" -ex "attach 1" -ex "load" -d $(OBJDIR) $(TARGET_ELF)
    else
        GDB_OPTS = -ex "target extended-remote $(GDB_PORT)" -ex "load" -d $(OBJDIR) $(TARGET_ELF)
    endif
endif

ifndef GDB_UPLOAD_OPTS
    GDB_UPLOAD_OPTS = $(GDB_OPTS) -ex "set confirm off" -ex "set target-async off" -ex "set remotetimeout 30" -ex "detach" -ex "kill" -ex "quit"
endif

########################################################################
# OpenOCD for SAM devices

ifndef OPENOCD
    BUNDLED_OPENOCD_DIR := $(call dir_if_exists,$(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/openocd)
    # Try Arduino support package first
    ifdef BUNDLED_OPENOCD_DIR
        OPENOCD_VER := $(shell basename $(wildcard $(BUNDLED_OPENOCD_DIR)/*))
        OPENOCD = $(BUNDLED_OPENOCD_DIR)/$(OPENOCD_VER)/bin/openocd -s $(BUNDLED_OPENOCD_DIR)/$(OPENOCD_VER)/share/openocd/scripts/
        $(call show_config_variable,OPENOCD,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
    else
        # Otherwise look on user path
        OPENOCD := $(shell which openocd 2>/dev/null)
        ifdef OPENOCD
            $(call show_config_variable,OPENOCD,[AUTODETECTED],(found in $$PATH))
        endif
    endif
else
    $(call show_config_variable,OPENOCD,[USER])
endif

ifndef OPENOCD_OPTS
    OPENOCD_OPTS += -d2 -f $(ALTERNATE_CORE_PATH)/variants/$(VARIANT)/$(OPENOCD_SCRIPT)
endif

########################################################################
# Bossa for SAM devices

ifndef BOSSA
    BUNDLED_BOSSA_DIR := $(call dir_if_exists,$(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/bossac)
    # Try Arduino support package first
    ifdef BUNDLED_BOSSA_DIR
        BOSSA_VER := $(shell basename $(wildcard $(BUNDLED_BOSSA_DIR)/*))
        BOSSA = $(BUNDLED_BOSSA_DIR)/$(BOSSA_VER)/bossac
        $(call show_config_variable,BOSSA,[AUTODETECTED],(from ARDUINO_PACKAGE_DIR))
    else
        # Otherwise look on user path
        BOSSA := $(shell which bossac 2>/dev/null)
        ifdef BOSSA
            $(call show_config_variable,BOSSA,[AUTODETECTED],(found in $$PATH))
        endif
    endif
else
    $(call show_config_variable,BOSSA,[USER])
endif

ifndef BOSSA_OPTS
    BOSSA_OPTS += -d --info --erase --write --verify --reset
endif

get_bootloader = $(shell $(RESET_CMD) | tail -1)

# if not bootloader port defined (ISP_PORT), automatically grab first port after reset
# if not on windows
ifndef ISP_PORT
    ifeq ($(CURRENT_OS), WINDOWS)
        BOSSA_OPTS += --port=$(COM_STYLE_MONITOR_PORT)
    else
        BOSSA_OPTS += --port=$(call get_monitor_port)
    endif
else
    BOSSA_OPTS += --port=$(ISP_PORT)
endif

########################################################################
# EXECUTABLES
# Define them here to use ARM_TOOLS_PATH and allow auto finding of AVR_TOOLS_PATH
OVERRIDE_EXECUTABLES = 1

ARM_TOOLS_PATH := $(ARM_TOOLS_DIR)/bin
CC      = $(ARM_TOOLS_PATH)/$(CC_NAME)
CXX     = $(ARM_TOOLS_PATH)/$(CXX_NAME)
AS      = $(ARM_TOOLS_PATH)/$(AS_NAME)
OBJCOPY = $(ARM_TOOLS_PATH)/$(OBJCOPY_NAME)
OBJDUMP = $(ARM_TOOLS_PATH)/$(OBJDUMP_NAME)
AR      = $(ARM_TOOLS_PATH)/$(AR_NAME)
SIZE    = $(ARM_TOOLS_PATH)/$(SIZE_NAME)
NM      = $(ARM_TOOLS_PATH)/$(NM_NAME)
#GDB     = $(ARM_TOOLS_PATH)/$(GDB_NAME)
# Use system gdb for now as Arduino supplied has lib error?
GDB     = $(GDB_NAME)

########################################################################
# FLAGS

ifndef USB_TYPE
    USB_TYPE = USBCON
endif

ifndef USB_PRODUCT
    USB_PRODUCT := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_product)
    ifdef USB_PRODUCT
        $(call show_config_variable,USB_PRODUCT,[COMPUTED])
    endif
endif

ifndef USB_MANUFACTURER
    USB_MANUFACTURER := $(call PARSE_BOARD,$(BOARD_TAG),build.usb_manufacturer)
    ifndef USB_MANUFACTURER
        USB_MANUFACTURER = "Unknown"
    else
        $(call show_config_variable,USB_MANUFACTURER,[COMPUTED])
    endif
endif

ifndef USB_VID
    USB_VID := $(call PARSE_BOARD,$(BOARD_TAG),build.vid)
    ifdef USB_VID
        $(call show_config_variable,USB_VID,[COMPUTED])
    endif
endif

ifndef USB_PID
    USB_PID := $(call PARSE_BOARD,$(BOARD_TAG),build.pid)
    ifdef USB_PID
        $(call show_config_variable,USB_PID,[COMPUTED])
    endif
endif

# Bootloader settings
ifndef BOOTLOADER_SIZE
    BOOTLOADER_SIZE := $(call PARSE_BOARD,$(BOARD_TAG),bootloader.size)
    ifndef BOOTLOADER_SIZE
        BOOTLOADER_SIZE := 0x2000
    else
        $(call show_config_variable,BOOTLOADER_SIZE,[COMPUTED])
    endif
endif

ifndef BOOTLOADER_UNPROTECT
    BOOTLOADER_UNPROTECT := $(call PARSE_BOARD,$(BOARD_TAG),bootloader.cmd_unprotect)
    ifndef BOOTLOADER_UNPROTECT
        BOOTLOADER_UNPROTECT := at91samd bootloader 0
    else
        $(call show_config_variable,BOOTLOADER_UNPROTECT,[COMPUTED])
    endif
endif

ifndef BOOTLOADER_PROTECT
    BOOTLOADER_PROTECT := $(call PARSE_BOARD,$(BOARD_TAG),bootloader.cmd_protect)
    ifndef BOOTLOADER_PROTECT
        BOOTLOADER_PROTECT := at91samd bootloader 16384
    else
        $(call show_config_variable,BOOTLOADER_PROTECT,[COMPUTED])
    endif
endif

ifndef BOOTLOADER_PROTECT_VERIFY
    BOOTLOADER_PROTECT_VERIFY := $(call PARSE_BOARD,$(BOARD_TAG),bootloader.cmd_protect_verify)
    ifndef BOOTLOADER_PROTECT_VERIFY
        BOOTLOADER_PROTECT_VERIFY := at91samd bootloader
    else
        $(call show_config_variable,BOOTLOADER_PROTECT_VERIFY,[COMPUTED])
    endif
endif

# C99 with GNU extensions required for C sources using old compiler
CC_VERNUM = $(shell $(CC) -dumpversion | sed 's/\.//g')
ifneq ($(shell expr $(CC_VERNUM) '>' 490), 1)
    CFLAGS_STD        = -std=gnu99
endif

CPPFLAGS += -DMD -D$(USB_TYPE) '-DUSB_PRODUCT=$(USB_PRODUCT)' '-DUSB_MANUFACTURER=$(USB_MANUFACTURER)'

# Get extra define flags from boards.txt
EXFLAGS := $(shell echo $(call PARSE_BOARD,$(BOARD_TAG),build.extra_flags) | grep -oE '(-D)\w+')

# Strip only defines from extra flags as boards file appends user {build.usb}
CPPFLAGS += $(EXFLAGS)
CPPFLAGS += -DUSB_VID=$(USB_VID)
CPPFLAGS += -DUSB_PID=$(USB_PID)
# Cortex compiler flags
CPPFLAGS += -mthumb -nostdlib --param max-inline-insns-single=500 -fno-exceptions -Wl,-Map=$(OBJDIR)/$(TARGET).map
CXXFLAGS += -fno-rtti -fno-threadsafe-statics -std=gnu++11

AMCU := $(call PARSE_BOARD,$(BOARD_TAG),build.mcu)
BOARD_LINKER_SCRIPT := $(call PARSE_BOARD,$(BOARD_TAG),build.ldscript)
OPENOCD_SCRIPT := $(call PARSE_BOARD,$(BOARD_TAG),build.openocdscript)
# TODO Hard defines Cortex M0 math lib - should be dynamic
LDFLAGS += --specs=nano.specs --specs=nosys.specs -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--start-group -L$(LIB_PATH) -larm_cortexM0l_math -lm
LINKER_SCRIPTS := -T$(ALTERNATE_CORE_PATH)/variants/$(VARIANT)/$(BOARD_LINKER_SCRIPT)
OTHER_LIBS := $(call PARSE_BOARD,$(BOARD_TAG),build.flags.libs)

# OpenOCD reset command only for now
ifeq ($(strip $(UPLOAD_TOOL)), openocd)
    RESET_CMD = $(OPENOCD) $(OPENOCD_OPTS) -c "telnet_port disabled; init; targets; reset run; shutdown"
else
    # Set zero flag for ard-reset for 1200 baud boot to bootloader
    ARD_RESET_OPTS += --zero
endif

########################################################################
# automatially include Arduino.mk for the user

$(call show_separator)
$(call arduino_output,Arduino.mk Configuration:)
include $(ARDMK_DIR)/Arduino.mk
