# Arduino Make file. Refer to https://github.com/sudar/Arduino-Makefile

# if you have placed the alternate core in your sketchbook directory, then you can just mention the core name alone.
ALTERNATE_CORE = attiny
# If not, you might have to include the full path.
#ALTERNATE_CORE_PATH = /home/sudar/Dropbox/code/arduino-sketches/hardware/attiny/

BOARD_TAG    = attiny85-8
ISP_PORT = /dev/ttyACM*

include $(ARDMK_DIR)/Arduino.mk

# !!! Important. You have to use make ispload to upload when using ISP programmer
