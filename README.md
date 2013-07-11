# A Makefile for Arduino Sketches

This is a very simple Makefile which knows how to build Arduino sketches. It defines the entire workflows for compiling code, flashing it to Arduino and even communicating through Serial monitor. You don't need to change anything in the Arduino sketches.

If you're using FreeBSD, Debian or Ubuntu, you can find this in the `arduino-mk` package.

## Usage

You can also find more [detailed instructions in this guide](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile) or also checkout the sample makefiles inside the examples/ folder

Download a copy of this repo some where in your system.

On the Mac you might want to set:

    ARDUINO_DIR   = /Applications/Arduino.app/Contents/Resources/Java
    ARDMK_DIR     = /usr/local

On Linux, you might prefer:

    ARDUINO_DIR   = /usr/share/arduino
    ARDMK_DIR     = /usr
    AVR_TOOLS_DIR = /usr

The Makefile also delegates resetting the board to a short Perl program.
You'll need to install `Device::SerialPort` to use it though.

On Debian or Ubuntu:

       apt-get install libdevice-serialport-perl

On Fedora:

       yum install perl-Device-SerialPort

On openSUSE:

      zypper install perl-Device-SerialPort

On Mac using MacPorts:

       sudo port install p5-device-serialport

      and use /opt/local/bin/perl5 instead of /usr/bin/perl

On other systems:

       cpanm Device::SerialPort

## Including Libraries

You can specify space separated list of libraries that are needed for your sketch to the variable `ARDUINO_LIBS`.

`ARDUINO_LIBS = Wire SoftwareSerial`

The libraries will be searched in the following places in the following order.

- `/libraries` folder inside your sketchbook folder. Sketchbook folder will be auto detected from your Arduino preference file. You can also manually set it through `ARDUINO_SKETCHBOOK`.
- `/libraries` folder inside your Arduino folder, which is read from `ARDUINO_DIR`.

The libraries inside user folder will take precedence over libraries present in Arduino core folder.

The makefile can autodetect the libraries that are included from your sketch and can include them automatically. But it can't detect libraries that are included from other libraries. (see [issue #93](https://github.com/sudar/Arduino-Makefile/issues/93))

## avrdude

To upload compiled files, `avrdude` is used. This Makefile tries to find `avrdude` and it's config (`avrdude.conf`) below `ARDUINO_DIR`. If you like to use the one installed on your system instead of the one which came with Arduino, you can try to set the variables `AVRDUDE` and `AVRDUDE_CONF`. On a typical Linux system these could be set to

      AVRDDUDE     = /usr/bin/avrdude
      AVRDUDE_CONF = /etc/avrdude.conf

## Versioning

The current version of the makefile is `0.12.0`. You can find the full history in the [HISTORY.md](HISTORY.md) file

This project adheres to Semantic [Versioning 2.0](http://semver.org/).

## Contribution

All contributions (even documentation) are welcome :) Open a pull request and I would be happy to merge them.

If you are looking for ideas to work on, then check out the following TODO items or the [issue tracker](https://github.com/sudar/Arduino-Makefile/issues/).

## Limitations / Know Issues / TODO's

- Doesn't work with Arduino 1.5.x yet. Follow [issue #45](https://github.com/sudar/Arduino-Makefile/issues/45) for progress.
- Since it doesn't do any pre processing like Arduino IDE, you have to declare all methods before you use them ([issue #59](https://github.com/sudar/Arduino-Makefile/issues/59))
- More than one .ino or .pde file is not supported yet ([issue #49](https://github.com/sudar/Arduino-Makefile/issues/49))
- When you compile for the first time, it builds all libs inside Arduino directory even if it is not needed. But while linking only the relevant files are linked. ([issue #29](https://github.com/sudar/Arduino-Makefile/issues/29)). Even Arduino IDE does the same thing though.

If you find an issue or have an idea for a feature then log them in the [issue tracker](https://github.com/sudar/Arduino-Makefile/issues/)

## Credits

This makefile was originally created by [Martin Oldfield](http://mjo.tc/atelier/2009/02/arduino-cli.html) and he maintained it till v0.10.2. 
From May 2013, it is maintained by [Sudar](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile)

## Similar works
- It's not a derivative of this, but Alan Burlison has written a [similar thing](http://bleaklow.com/2010/06/04/a_makefile_for_arduino_sketches.html).
- Alan's Makefile was used in a [Pragmatic Programmer's article](http://pragprog.com/magazines/2011-04/advanced-arduino-hacking).
- Rei Vilo wrote to tell me that he's using the Makefile ina Xcode 4 template called [embedXcode](http://embedxcode.weebly.com/). Apparently it supports many platforms and boards, including AVR-based Arduino, AVR-based Wiring, PIC32-based chipKIT, MSP430-based LaunchPad and ARM3-based Maple.
