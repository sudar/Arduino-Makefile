# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches.

Until March 2012, this was simply posted on my website where you can still find
[what documentation][docs] exists.

If you're using Debian or Ubuntu, you can find this in the arduino-core package.

This Makefile current requires either Arduino 1.0 or MPIDE 0023.

## chipKIT Support

In addition to regular Arduino boards, this Makefile supports the Digilent
chipKIT Uno32 and Max32, both Arduino-compatible microcontrollers. To use this
Makefile with one of those, include `chipKIT.mk` instead of `Arduino.mk` at the
bottom of your Makefile.

    include /path/to/chipKIT.mk

You can adjust the same variables [as described for the Arduino][docs], but the
`ARDUINO_DIR` variable must point to an MPIDE installation (which includes the
chipKIT toolchain) instead of the Arduino IDE.


Some details on the addition of chipKIT support can be found in another
[blog post](http://christopherpeplin.com/2011/12/chipkit-arduino-makefile/).

[docs]: http://mjo.tc/atelier/2009/02/arduino-cli.html

## Contributors

* Martin Oldfield (initial version)
* Chris Peplin (chipKIT)
* rei_vilo / Olivier
* Edward Comer
