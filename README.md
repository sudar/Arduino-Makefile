# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches. It defines the entire workflows for compiling code, flashing it to Arduino and even communicating through Serial monitor. You don't need to change anything in the Arduino sketches.

If you're using Debian or Ubuntu, you can find this in the `arduino-mk` package.

## Credits

This makefile was originally created by [Martin Oldfield](http://mjo.tc/atelier/2009/02/arduino-cli.html) and he maintained it till v0.10.2. 
From May 2013, it is maintained by [Sudar](http://hardwarefun.com)

## Usage

Download a copy of this repo some where in your system.

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

## Changelog

The following is the rough list of changes that went into different versions. I tried to give credit whenever possible. If I have missed anyone, kindly add it to the list.

### 0.10.2 15.xii.2012 Sudar
- Added sketch size verification. (https://github.com/fornellas)
- Show original line number for error messages (https://github.com/WizenedEE)
- Removed -w from CPPFLAGS to show warnings (https://github.com/gaftech)
- Changed shebang to use /usr/bin/env (https://github.com/anm)
- set USB_VID and USB_PID only for leonardo boards(https://github.com/alohr)
- Updated Readme (https://github.com/fr0sty1/)

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

###   0.10 17.ix.12   M J Oldfield
- Merged all changes from Upstream

###   0.9.3.2 10.ix.2012 Sudar
- Fixed a typo in README. Issue reported at upstream (https://github.com/mjoldfield/Arduino-Makefile/issues/21)

###   0.9.3.1 18.viii.2012 jeffkowalski

- Autodetect ARDUINO_LIBS from includes in LOCAL_SRCS
- Autodetect ARDUINO_SKETCHBOOK from file set by Arduino IDE
- Autodetect ARDMK_DIR based on location of this file
- Added support for utility directory within SYS and USER libraries

### 0.9.3 13.vi.2012 

- Auto detect ARDUINO_DIR, Arduino version (https://github.com/rpavlik/)
- Categorize libs into user and system (https://github.com/rpavlik/)
- Dump size at the end of the build (https://github.com/rpavlik/)
- Lots and lots of improvements (https://github.com/rpavlik/)
- Changed bytes option for the head shell command, so that it works in Mac as well
- Auto detect Serial Baud rate from sketch if possible

### 0.9.2 06.vi.2012 

- Allow user to choose source files (LOCAL_*_SRCS flags) (https://github.com/Gaftech)
- Modified "make size" behavior: using --mcu option and targeting .elf file instead of .hex file.(https://github.com/Gaftech)

### 0.9.1 06.vi.2012 

- Corrected the ubuntu package names
- Prevent the *file-not-found* error if the depends.mk file is not needed
- Delete the build-cli folder as well while doing make clean
- Added support for compiling .pde files in Arduino 1.0 environment
- Replaced = with += in CPPFLAGS assignment so that we can set CPPFLAGS per sketch if needed
- Changed AVRDUDE_CONF so it can be defined in per-project makefile (https://github.com/WizenedEE)
- Cleaner way to delete the build-cli directory when make clean is invoked
- The package name in Debian and Ubuntu is arduino-mk (https://github.com/maqifrnswa)

### 2012-02-12, version 0.8
- Patches for version 1.0 of the Arduino IDE. Older versions might still work, but I’ve not tested it.
- A change to the build process: rather than link all the system objects directly into the executable, bundle them in a library first. This should make the final executable smaller.
- If TARGET isn’t explicitly set, default to the current directory name. Thanks to Daniele Vergini for this patch.
- Add support for .c files in system libraries: Dirk-Willem van Gulik and Evan Goldenberg both reported this and provided patches in the same spirit.
- Added a size target as suggested by Alex Satrapa.

### Unreleased, version 0.7
- Added -lm to the linker options, and -F to stty.

### 2011-06-23, version 0.6
- Added ard-parse-boards. Mark Sproul suggested doing something like this ages ago, but I’ve only recently looked at it in detail.
- Fabien Le Lez reported that one needs to link with -lc to avoid [linker errors](http://forum.arduino.cc/index.php/topic,40215.0.html).

### 2011-06-23, version 0.5
- Imported changes from Debian/Ubuntu, which incorporate a patch from Stefan Tomanek so that libraries would be compiled too.

Note: Many other people sent me similar patches, but I didn’t get around to using them. In the end, I took the patch from Debian and Ubuntu: there seems merit in not forking the code and using a tested version. So, thanks and apologies to Nick Andrew, Leandro Coletto Biazon, Thibaud Chupin, Craig Hollabaugh, Johannes H. Jensen, Fabien Le Lez, Craig Leres, and Mark Sproul.

### 2010-05-24, version 0.4
Tweaked rules for the reset target on Philip Hands’ advice.

### 2010-05-21, version 0.3
- Tidied up the licensing, making it clear that it’s released under LGPL 2.1.
- [Philip Hands](http://hands.com/~phil/) sent me some code to reset the Arduino by dropping DTR for 100ms, and I added it.
- Tweaked the Makefile to handle version 0018 of the Arduino software which now includes main.cpp. Accordingly we don’t need to—and indeed must not—add main.cxx to the .pde sketch file. The paths seem to have changed a bit too.

## Know Issues
- Because of the way the makefile is structured, the configuration parameters gets printed twice. 
- Doesn't work with Leonardo yet.
- More todo's at https://github.com/sudar/Arduino-Makefile/issues/

## Similar works
- It's not a derivative of this, but Alan Burlison has written a [similar thing](http://bleaklow.com/2010/06/04/a_makefile_for_arduino_sketches.html).
- Alan's Makefile was used in a [Pragmatic Programmer's article](http://pragprog.com/magazines/2011-04/advanced-arduino-hacking).
- Rei Vilo wrote to tell me that he's using the Makefile ina Xcode 4 template called [embedXcode](http://embedxcode.weebly.com/). Apparently it supports many platforms and boards, including AVR-based Arduino, AVR-based Wiring, PIC32-based chipKIT, MSP430-based LaunchPad and ARM3-based Maple.
