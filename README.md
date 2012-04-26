# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches.

Until March 2012, this was simply posted on my website where you can
still find [what
documentation](http://mjo.tc/atelier/2009/02/arduino-cli.html
"Documentation") exists.

If you're using Debian or Ubuntu, you can find this in the arduino-core package.

## Commands

### Serial Monitor

If you have minicom installed, you can run `make monitor` to open the serial
output. You can use a different serial monitoring tool (e.g. screen) by
overriding the `SERIAL_MONITOR_BINARY` and `SERIAL_MONITOR_FLAGS` variables.
