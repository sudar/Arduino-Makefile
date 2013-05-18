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
You'll need to install `Device::SerialPort` to use it though. You'll also
need the `YAML` library to run ard-parse-boards.

On Debian or Ubuntu:

       apt-get install libdevice-serialport-perl
       apt-get install libyaml-perl

On Fedora:

       yum install perl-Device-SerialPort
       yum install perl-YAML

On Mac using MacPorts:

       sudo port install p5-device-serialport
       sudo port install p5-YAML

      and use /opt/local/bin/perl5 instead of /usr/bin/perl

On other systems:

       cpanm Device::SerialPort
       cpanm YAML

## User Libraries

In order to use Arduino libraries installed in the user's sketchbook folder (the
standard location for custom libraries when using the Arduino IDE), you need to
set the `ARDUINO_SKETCHBOOK` variable to point to this directory. By default it
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

###   0.9.3.1 18.viii.2012 jeffkowalski
- Autodetect ARDUINO_LIBS from includes in LOCAL_SRCS
- Autodetect ARDUINO_SKETCHBOOK from file set by Arduino IDE
- Autodetect ARDMK_DIR based on location of this file
- Added support for utility directory within SYS and USER libraries

###   0.9.3.2 10.ix.2012 Sudar
- Fixed a typo in README. Issue reported at upstream (https://github.com/mjoldfield/Arduino-Makefile/issues/21)

###   0.10 17.ix.12   M J Oldfield
- Merged all changes from Upstream

###  0.10.1 15.xii.2012 Sudar
- Merged all changes from Upstream and the following changes from https://github.com/rpavlik
- Allow passing extra flags
- Make listing files more useful
- Add knowledge of device-specific assembler
- Use variables instead of hardcoded commands
- Make disasm more helpful
- Change .sym output
- Provide symbol_sizes and generated_assembly targets.
- Be able to silence configuration output
- Make everybody depend on the makefile, in case cflags are changed, etc.
- Make the makefile error if the arduino port is not present.

###   	0.10.2 15.xii.2012 Sudar
- Added sketch size verification. (https://github.com/fornellas)
- Show original line number for error messages (https://github.com/WizenedEE)
- Removed -w from CPPFLAGS to show warnings (https://github.com/gaftech)
- Changed shebang to use /usr/bin/env (https://github.com/anm)
- set USB_VID and USB_PID only for leonardo boards(https://github.com/alohr)
- Updated Readme (https://github.com/fr0sty1/)

## Know Issues
- Because of the way the makefile is structured, the configuration parameters gets printed twice. 
- Doesn't work with Leonardo yet.
- More todo's at https://github.com/sudar/Arduino-Makefile/issues/
