# This program is free software and is licensed under the same conditions as
# describe in https://github.com/sudar/Arduino-Makefile/blob/master/licence.txt

# This is an example Makefile, that is being used to build an archive
# from locally compiled objects.
#
# All source files in this directory will automatically get compiled
# and archived into the build-$(BOARD_TAG)/libtoggle.a target.

include ../board.mk
include ../../../Arduino.mk

build-$(BOARD_TAG)/libtoggle.a: $(LOCAL_OBJS)
	$(AR) rcs $@ $(LOCAL_OBJS)
