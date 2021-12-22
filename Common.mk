COMMON_INCLUDED = TRUE
# Useful functions
# Returns the first argument (typically a directory), if the file or directory
# named by concatenating the first and optionally second argument
# (directory and optional filename) exists
dir_if_exists = $(if $(wildcard $(1)$(2)),$(1))

# result = $(call READ_BOARD_TXT, 'boardname', 'parameter')
PARSE_BOARD = $(shell if [ -f $(BOARDS_TXT) ]; \
then \
  $(GREP_CMD) -Ev '^\#' $(BOARDS_TXT) | \
  $(GREP_CMD) -E "^[ \t]*$(1).$(2)=" | \
  cut -d = -f 2- | \
  cut -d : -f 2; \
fi)

# Run a shell script if it exists. Stops make on error.
runscript_if_exists =                                                          \
    $(if $(wildcard $(1)),                                                     \
         $(if $(findstring 0,                                                  \
                  $(lastword $(shell $(abspath $(wildcard $(1))); echo $$?))), \
              $(info Info: $(1) success),                                      \
              $(error ERROR: $(1) failed)))

# For message printing: pad the right side of the first argument with spaces to
# the number of bytes indicated by the second argument.
space_pad_to = $(shell echo "$(1)                                                       " | head -c$(2))

# Call with some text, and a prefix tag if desired (like [AUTODETECTED]),
show_config_info = $(call arduino_output,- $(call space_pad_to,$(2),20) $(1))

# Call with the name of the variable, a prefix tag if desired (like [AUTODETECTED]),
# and an explanation if desired (like (found in $$PATH)
show_config_variable = $(call show_config_info,$(1) = $($(1)) $(3),$(2))

# Just a nice simple visual separator
show_separator = $(call arduino_output,-------------------------)

# Master Arduino Makefile include (after user Makefile)
ardmk_include = $(shell basename $(word 2,$(MAKEFILE_LIST)))

$(call show_separator)
$(call arduino_output,$(call ardmk_include) Configuration:)

########################################################################
#
# Detect OS

ifeq ($(OS),Windows_NT)
    CURRENT_OS = WINDOWS
    GREP_CMD = grep
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        CURRENT_OS = LINUX
        GREP_CMD = grep
    endif
    ifeq ($(UNAME_S),Darwin)
        CURRENT_OS = MAC
        ifeq (, $(shell which gggrep))
            $(info Using macOS BSD grep, please install GNU grep to avoid warnings)
            GREP_CMD = grep
        else
            GREP_CMD = ggrep
        endif
    endif
endif
$(call show_config_variable,CURRENT_OS,[AUTODETECTED])

########################################################################
#
# Travis-CI
ifneq ($(TEST),)
       DEPENDENCIES_DIR = /var/tmp/Arduino-Makefile-testing-dependencies

       DEPENDENCIES_MPIDE_DIR := $(shell find $(DEPENDENCIES_DIR) -name 'mpide-0023-*' -type d -exec ls -dt {} + | head -n 1)

       ifeq ($(MPIDE_DIR),)
              MPIDE_DIR = $(DEPENDENCIES_MPIDE_DIR)
       endif

       ifndef ARDUINO_IDE_DIR
              ifeq ($(CURRENT_OS),MAC)
                  ARDUINO_IDE_DIR = Arduino.app/Contents/Resources/Java
              else
                  ARDUINO_IDE_DIR := $(shell basename $(basename $(basename $(lastword $(wildcard $(DEPENDENCIES_DIR)/arduino*)))))
              endif
       endif
       DEPENDENCIES_ARDUINO_DIR = $(DEPENDENCIES_DIR)/$(ARDUINO_IDE_DIR)
       ifeq ($(ARDUINO_DIR),)
              ARDUINO_DIR = $(DEPENDENCIES_ARDUINO_DIR)
       endif
endif

########################################################################
# Arduino Directory

ifndef ARDUINO_DIR
    AUTO_ARDUINO_DIR := $(firstword \
        $(call dir_if_exists,/usr/share/arduino) \
        $(call dir_if_exists,/Applications/Arduino.app/Contents/Resources/Java) \
        $(call dir_if_exists,/Applications/Arduino.app/Contents/Java) )
    ifdef AUTO_ARDUINO_DIR
       ARDUINO_DIR = $(AUTO_ARDUINO_DIR)
       $(call show_config_variable,ARDUINO_DIR,[AUTODETECTED])
    else
        echo $(error "ARDUINO_DIR is not defined")
    endif
else
    $(call show_config_variable,ARDUINO_DIR,[USER])
endif

ifeq ($(CURRENT_OS),WINDOWS)
		ifneq ($(shell echo $(ARDUINO_DIR) | egrep '\\|[[:space:]]|cygdrive'),)
        echo $(error On Windows, ARDUINO_DIR and other defines must use forward slash and not contain spaces, special characters or be cygdrive relative)
    endif
endif

########################################################################
# System Python

ifndef PYTHON_CMD
    # try for Python 3 first
    PYTHON_CMD := $(shell which python3 2> /dev/null)
    ifdef PYTHON_CMD
        $(call show_config_variable,PYTHON_CMD,[AUTODETECTED])
    else
        # fall-back to any Python
        PYTHON_CMD := $(shell which python 2> /dev/null)
        ifdef PYTHON_CMD
            $(call show_config_variable,PYTHON_CMD,[AUTODETECTED])
        else
            echo $(error "Unable to find system Python! Utility scipts won't work. Override this error by defining PYTHON_CMD")
        endif
    endif
else
    $(call show_config_variable,PYTHON_CMD,[USER])
endif
