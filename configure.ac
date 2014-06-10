########################################################################
#
# Makefile for compiling Arduino sketches from command line
# System part (i.e. project independent)
# configure.ac for installing Arduino.mk on the system
#
# Copyright (C) 2014 Bas Wijnen <wijnen@debian.org>
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
########################################################################

AC_PREREQ(2.53)
AC_INIT([arduino-mk],[0.1],[https://github.com/sudar/Arduino-Makefile])
AM_INIT_AUTOMAKE

AC_PATH_PROG([AVRDUDE], [avrdude])
AC_PATH_PROG([CC_NAME], [avr-gcc])
AC_SUBST([AVR_TOOLS_DIR], `AS_DIRNAME([${CC_NAME}])`/..)
AC_CANONICAL_HOST
AS_CASE([$host],
	[*-linux-*], [ARDUINO_DIR=${datarootdir}/arduino; MONITOR_PORT="/dev/ttyACM* /dev/ttyUSB*"],
	[*-darwin-*], [ARDUINO_DIR=/Applications/Arduino.app/Contents/Resources/Java; MONITOR_PORT=/dev/cu.usb*],
	[*-cygwin-*], [MONITOR_PORT=com1])
AS_IF([test "x$ARDUINO_DIR" = x], [AC_MSG_ERROR(["ARDUINO_DIR is not defined for your platform; please define it manually"])])
AS_IF([test "x$MONITOR_PORT" = x], [AC_MSG_ERROR(["MONITOR_PORT is not defined for your platform; please define it manually"])])
AC_SUBST([ARDUINO_DIR])
AC_SUBST([MONITOR_PORT])
AC_SUBST([ARDMK_DIR], [${datarootdir}/arduino])
AC_CONFIG_FILES([arduino-mk-tool] [Makefile])

AC_OUTPUT
