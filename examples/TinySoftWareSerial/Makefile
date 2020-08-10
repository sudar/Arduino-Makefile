# Arduino Make file. Refer to https://github.com/sudar/Arduino-Makefile

# if you have placed the alternate core in your sketchbook directory, then you can just mention the core name alone.
ALTERNATE_CORE = attiny
# If not, you might have to include the full path.
#ALTERNATE_CORE_PATH = /home/sudar/Dropbox/code/arduino-sketches/hardware/attiny/

# !!! Important. You have to use "make ispload" to upload when using ISP programmer
ISP_PROG = usbasp

# 1.5+ example of submenu cpu
BOARD_TAG    = attiny
BOARD_SUB    = attiny85

# clock is a submenu too
F_CPU        = 16000000L

ARDUINO_LIBS = SoftwareSerial

include /usr/share/arduino/Arduino.mk
