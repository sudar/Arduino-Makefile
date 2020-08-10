# This program is free software and is licensed under the same conditions as
# describe in https://github.com/sudar/Arduino-Makefile/blob/master/licence.txt

# This is an example Makefile, that demonstrates the linking of a third party
# library. In this case the third party library resides in the ./Toggle
# sub-directory. Note that the archive TOGGLE_ARCHIVE _only_ contains the
# compiled Toggle.c.o object. The TOGGLE_ARCHIVE is thus very lean, but it
# requires the Arduino libraries, which are being build in this directory,
# together with Blink, the 'main' program.

include board.mk

TOGGLE_ARCHIVE = build-$(BOARD_TAG)/libtoggle.a

CXXFLAGS += -IToggle
OTHER_OBJS = Toggle/$(TOGGLE_ARCHIVE)

include ../../Arduino.mk

Toggle/$(TOGGLE_ARCHIVE):
	$(MAKE) -C Toggle $(TOGGLE_ARCHIVE)

clean::
	$(MAKE) -C Toggle clean
