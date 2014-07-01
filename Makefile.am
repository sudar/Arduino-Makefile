########################################################################
#
# Makefile for compiling Arduino sketches from command line
# System part (i.e. project independent)
# Makefile.am for installing Arduino.mk on the system
#
# Copyright (C) 2014 Bas Wijnen <wijnen@debian.org>
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
########################################################################

AUTOMAKE_OPTIONS = foreign

ardmkdir = ${ARDMK_DIR}
bin_SCRIPTS = arduino-mk-tool bin/ard-reset-arduino
ardmk_DATA = Arduino.mk chipKIT.mk Common.mk
man_MANS = ard-reset-arduino.1

# Allow cleaning up all the junk that autotools create.
JUNK = Makefile.in aclocal.m4 config.guess config.sub configure install-sh missing

autoclean: maintainer-clean
 ifneq ($(wildcard $(JUNK)),)
	rm -r $(wildcard $(JUNK))
 endif
