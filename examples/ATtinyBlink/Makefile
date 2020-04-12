# Arduino Make file. Refer to https://github.com/sudar/Arduino-Makefile

# Set this if the IDE is not in your $PATH or you want to use a specific version:
ARDUINO_DIR = $(HOME)/arduino-1.8.5

# Programmer type:
ISP_PROG = usbasp

# Examples - obviously pick only one and comment/delete the rest:

# ------------------------------------------------------------------ #

# https://github.com/SpenceKonde/ATTinyCore (1.5+)
ALTERNATE_CORE = ATTinyCore
BOARD_TAG = attinyx4
BOARD_SUB = 84
VARIANT = tinyX4
F_CPU = 8000000L
#BOARD_TAG = attinyx313
#BOARD_SUB = 4313
#BOARD_TAG = attinyx61
#BOARD_SUB = 861
#F_CPU = 8000000L

# ------------------------------------------------------------------ #

# https://github.com/Coding-Badly/TinyCore1 (1.5+)
ALTERNATE_CORE = tiny
BOARD_TAG = attiny85at8
#BOARD_TAG = attiny2313at1

# https://github.com/Coding-Badly/arduino-tiny (1.0)
ALTERNATE_CORE = tiny
BOARD_TAG = attiny85at8
#BOARD_TAG = attiny44at8
#BOARD_TAG = attiny84at8
ARDUINO_VAR_PATH = $(HOME)/arduino/hardware/tiny/cores/tiny
ARDUINO_CORE_PATH = $(HOME)/arduino/hardware/tiny/cores/tiny

# ------------------------------------------------------------------ #

# https://github.com/damellis/attiny (1.5+)
ALTERNATE_CORE = attiny-master
BOARD_TAG = attiny
BOARD_SUB = attiny85
F_CPU = 16000000L

# https://github.com/damellis/attiny (1.0)
ALTERNATE_CORE = attiny-master
BOARD_TAG = attiny85
#BOARD_TAG = attiny44-8
#BOARD_TAG = attiny84-20

# ------------------------------------------------------------------ #

# Path to the Arduino Makefile
include $(ARDMK_DIR)/Arduino.mk

# !!! Important. You have to use 'make ispload' when using an ISP.
