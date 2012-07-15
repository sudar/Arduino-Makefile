# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches. It defines the entire workflows for compiling code, flashing it to Arduino and even communicating through Serial monitor. You don't need to change anything in the Arduino sketches

Until March 2012, this was simply posted on my website where you can
still find [what documentation](http://mjo.tc/atelier/2009/02/arduino-cli.html
"Documentation") exists.

If you're using Debian or Ubuntu, you can find this in the
arduino-mk package.

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

       apt-get install libdevice-serialport-perl libconfig-yaml-perl

On other systems

       cpanm Device::SerialPort

## User Libraries

In order to use Arduino libraries installed in the user's sketchbook folder (the
standard location for custom libraries when using the Arduino IDE), you need to
set the `ARDUNIO_SKETCHBOOK` variable to point to this directory. By default it
is set to `$HOME/sketchbook`.

## Notes from Sudar

The following are the list of changes that I have made or merged in this fork. Hopefully it gets into mjoldfield repo and ultimately into Ubuntu package one day :)

### 0.9.1 06.vi.2012 

- Corrected the ubuntu package names
- Prevent the *file-not-found* error if the depends.mk file is not needed
- Delete the build-cli folder as well while doing make clean
- Added support for compiling .pde files in Arduino 1.0 environment
- Replaced = with += in CPPFLAGS assignment so that we can set CPPFLAGS per sketch if needed
- Changed AVRDUDE_CONF so it can be defined in per-project makefile (https://github.com/WizenedEE)
- Cleaner way to delete the build-cli directory when make clean is invoked
- The package name in Debian and Ubuntu is arduino-mk (https://github.com/maqifrnswa)

### 0.9.2 06.vi.2012 

- Allow user to choose source files (LOCAL_*_SRCS flags) (https://github.com/Gaftech)
- Modified "make size" behavior: using --mcu option and targeting .elf file instead of .hex file.(https://github.com/Gaftech)

### 0.9.3 13.vi.2012 

- Auto detect ARDUINO_DIR, Arduino version (https://github.com/rpavlik/)
- Categorize libs into user and system (https://github.com/rpavlik/)
- Dump size at the end of the build (https://github.com/rpavlik/)
- Lots and lots of improvements (https://github.com/rpavlik/)
- Changed bytes option for the head shell command, so that it works in Mac as well
- Auto detect Serial Baud rate from sketch if possible

## Know Issues
- Because of the way the makefile is structured, the configuration parameters gets printed twice. 
