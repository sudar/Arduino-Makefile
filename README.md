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

## Versioning

The current version of the makefile is `0.10.4`. You can find the full history in the [HISTORY.md](HISTORY.md) file

This project adheres to Semantic [Versioning 2.0](http://semver.org/).

## Contribution

All contributions (even documentation) are welcome :) Open a pull request and I would be happy to merge them.

If you are looking for ideas to work on, then check out the following TODO items.

## Know Issues / TODO's

- Doesn't work with Arduino 1.5.x yet.

If you find an issue or have an idea for a feature then log them at https://github.com/sudar/Arduino-Makefile/issues/

## Similar works
- It's not a derivative of this, but Alan Burlison has written a [similar thing](http://bleaklow.com/2010/06/04/a_makefile_for_arduino_sketches.html).
- Alan's Makefile was used in a [Pragmatic Programmer's article](http://pragprog.com/magazines/2011-04/advanced-arduino-hacking).
- Rei Vilo wrote to tell me that he's using the Makefile ina Xcode 4 template called [embedXcode](http://embedxcode.weebly.com/). Apparently it supports many platforms and boards, including AVR-based Arduino, AVR-based Wiring, PIC32-based chipKIT, MSP430-based LaunchPad and ARM3-based Maple.
