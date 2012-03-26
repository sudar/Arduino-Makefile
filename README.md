# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches.

Until March 2012, this was simply posted on my website where you can
still find [what
documentation](http://mjo.tc/atelier/2009/02/arduino-cli.html
"Documentation") exists.

If you're using Debian or Ubuntu, you can find this in the arduino-core package.

## User Libraries

In order to use Arduino libraries installed in the user's sketchbook folder (the
standard location for custom libraries when using the Arduino IDE), you need to
set the `ARDUNIO_SKETCHBOOK` variable to point to this directory. By default it
is set to `$HOME/sketchbook`.
