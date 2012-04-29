# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches.

Until March 2012, this was simply posted on my website where you can
still find [what
documentation](http://mjo.tc/atelier/2009/02/arduino-cli.html
"Documentation") exists.

If you're using Debian or Ubuntu, you can find this in the
arduino-core package.

# Important Changes, 2012-04-29

I've rejigged the path calculations so that:

1. Few, if any paths, need to specified in the project specific Makefiles.

1. The paths can be grabber from the environment e.g. set up in a user's .bashrc.

1. It should be easier to move between e.g. Mac and Linux.

I'm indebted to Christopher Peplin for making me think about this, and indeed for
contributing code which did similar things in different ways.

The upshot of all this is that you'll need to set up some variables if you want 
this to work:

On the Mac you might want to set:

    ARDUINO_DIR   = /Applications/Arduino.app/Contents/Resources/Java
    ARDMK_DIR     = /usr/local

On Linux, you might prefer:

    ARDUINO_DIR   = /usr/share/arduino
    ARDMK_DIR     = /usr/local
    AVR_TOOLS_DIR = /usr

The Makefile also delegates resetting the board to a short Perl program.
You'll need to install Device::SerialPort to use it though. On Debian or 
Ubuntu do

       apt-get install libdevice-serial-perl

On other systems

       cpanm Device::SerialPort

## User Libraries

In order to use Arduino libraries installed in the user's sketchbook folder (the
standard location for custom libraries when using the Arduino IDE), you need to
set the `ARDUNIO_SKETCHBOOK` variable to point to this directory. By default it
is set to `$HOME/sketchbook`.
