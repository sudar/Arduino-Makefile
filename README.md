# A Makefile for Arduino Sketches [![Build Status](https://travis-ci.org/sudar/Arduino-Makefile.svg)](https://travis-ci.org/sudar/Arduino-Makefile)

This is a very simple Makefile which knows how to build Arduino sketches. It defines entire workflows for compiling code, flashing it to Arduino and even communicating through Serial monitor. You don't need to change anything in the Arduino sketches.

## Features

- Very robust
- Highly customizable
- Supports all official AVR-based Arduino boards
- Supports chipKIT
- Works on all three major OS (Mac, Linux, Windows)
- Auto detects serial baud rate and libraries used
- Support for `*.ino` and `*.pde` sketches as well as raw `*.c` and `*.cpp`
- Support for Arduino Software versions 1.0.x as well as 0.x.
Support for Arduino 1.5.x is still work in progress
- Automatic dependency tracking. Referred libraries are automatically included
in the build process. Changes in `*.h` files lead to recompilation of sources which include them

## Installation

### Through package

If you're using FreeBSD, Debian, Raspbian or Ubuntu, you can find this in the `arduino-mk`
package which can be installed using `apt-get` or `aptitude`.

Arch Linux users can use the unofficial AUR package [arduino-mk](https://aur.archlinux.org/packages/arduino-mk/)
and install using `yaourt -S arduino-mk`

Fedora Linux users can use our packaging instructions [here](https://github.com/sudar/Arduino-Makefile/tree/master/packaging/fedora)
to build an RPM.

### From source

- Download the latest release
- Or clone it from Github using the command `git clone git@github.com:sudar/Arduino-Makefile.git`
- Check the [usage section](https://github.com/sudar/Arduino-Makefile#usage) in this readme about setting usage options

## Requirements

You need to have the Arduino IDE. You can either install it through the
installer or download the distribution zip file and extract it.

The Makefile also delegates resetting the board to a short Python program.
You'll need to install `pySerial` to use it though.

On Debian or Ubuntu:

       apt-get install python-serial

On Fedora:

       yum install pyserial

On openSUSE:

      zypper install python-serial

On Mac using MacPorts:

      sudo port install py27-serial

On Windows:

You need to install Cygwin and its packages for Make, Perl and the following Serial library.

       pySerial can be downloaded from PyPi

On other systems:

       pip install pyserial

        or

       easy_install -U pyserial

## Usage

You can also find more [detailed instructions in this guide](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile).

You can also checkout the sample makefiles inside the `examples/` directory, e.g. [Makefile-example](examples/MakefileExample/Makefile-example.mk).

Download a copy of this repo some where in your system or install it through a package.

On the Mac you might want to set:

    ARDUINO_DIR   = /Applications/Arduino.app/Contents/Resources/Java
    ARDMK_DIR     = /usr/local
    AVR_TOOLS_DIR = /usr
    MONITOR_PORT  = /dev/ttyACM0
    BOARD_TAG     = mega2560

On Linux (if you have installed through package), you shouldn't need to set anything other than your board type and port:

    BOARD_TAG     = mega2560
    MONITOR_PORT  = /dev/ttyACM0

On Windows (using cygwin), you might want to set:

    ARDUINO_DIR   = ../../arduino
    ARDMK_DIR     = path/to/mkfile
    MONITOR_PORT  = com3
    BOARD_TAG     = mega2560

On Arduino 1.5.x installs, you should set the architecture to either `avr` or `sam` and if using a submenu CPU, then also set that:

	ARCHITECTURE  = avr
    BOARD_SUB     = atmega168

It is recommended in Windows that you create a symbolic link to avoid problems with file naming conventions on Windows. For example, if your your Arduino directory is in:

    c:\Program Files (x86)\Arduino

You will get problems with the special characters on the directory name. More details about this can be found in [issue #94](https://github.com/sudar/Arduino-Makefile/issues/94)

To create a symbolic link, you can use the command “mklink” on Windows, e.g.

    mklink /d c:\Arduino c:\Program Files (x86)\Arduino

After which, the variables should be:

    ARDUINO_DIR=../../../../../Arduino

Instead of:

    ARDUINO_DIR=../../../../../Program\ Files\ \(x86\)/Arduino


- `BOARD_TAG` - Type of board, for a list see boards.txt or `make show_boards`
- `MONITOR_PORT` - The port where your Arduino is plugged in, usually `/dev/ttyACM0` or `/dev/ttyUSB0` in Linux or Mac OS X and `com3`, `com4`, etc. in Windows.
- `ARDUINO_DIR` - Path to Arduino installation. In Cygwin in Windows this path must be
  relative, not absolute (e.g. "../../arduino" and not "/c/cygwin/Arduino").
- `ARDMK_DIR`   - Path where the `*.mk` are present. If you installed the package, then it is usually `/usr/share/arduino`
- `AVR_TOOLS_DIR` - Path where the avr tools chain binaries are present. If you are going to use the binaries that came with Arduino installation, then you don't have to set it. Otherwise set it realtive and not absolute.

The list of all variables that can be overridden is available at [arduino-mk-vars.md](arduino-mk-vars.md) file.

## Including Libraries

You can specify space separated list of libraries that are needed for your sketch to the variable `ARDUINO_LIBS`.

`ARDUINO_LIBS = Wire SoftwareSerial`

The libraries will be searched in the following places in the following order.

- `/libraries` directory inside your sketchbook directory. Sketchbook directory will be auto detected from your Arduino preference file. You can also manually set it through `ARDUINO_SKETCHBOOK`.
- `/libraries` directory inside your Arduino directory, which is read from `ARDUINO_DIR`.

The libraries inside user directories will take precedence over libraries present in Arduino core directory.

The makefile can autodetect the libraries that are included from your sketch and can include them automatically. But it can't detect libraries that are included from other libraries. (see [issue #93](https://github.com/sudar/Arduino-Makefile/issues/93))

## avrdude

To upload compiled files, `avrdude` is used. This Makefile tries to find `avrdude` and it's config (`avrdude.conf`) below `ARDUINO_DIR`. If you like to use the one installed on your system instead of the one which came with Arduino, you can try to set the variables `AVRDUDE` and `AVRDUDE_CONF`. On a typical Linux system these could be set to

      AVRDUDE     = /usr/bin/avrdude
      AVRDUDE_CONF = /etc/avrdude.conf

## Versioning

The current version of the makefile is `1.3.4`. You can find the full history in the [HISTORY.md](HISTORY.md) file

This project adheres to Semantic [Versioning 2.0](http://semver.org/).

## License

This makefile and the related documentation and examples are free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

## Contribution

All contributions (even documentation) are welcome :) Open a pull request and I would be happy to merge them.
Also checkout the [contribution guide](CONTRIBUTING.md) for more details.

If you are looking for ideas to work on, then check out the following TODO items or the [issue tracker](https://github.com/sudar/Arduino-Makefile/issues/).

## Limitations / Know Issues / TODO's

- Doesn't work with Arduino 1.5.x yet. Follow [issue #45](https://github.com/sudar/Arduino-Makefile/issues/45) for progress.
- Since it doesn't do any pre processing like Arduino IDE, you have to declare all methods before you use them ([issue #59](https://github.com/sudar/Arduino-Makefile/issues/59))
- More than one .ino or .pde file is not supported yet ([issue #49](https://github.com/sudar/Arduino-Makefile/issues/49))
- When you compile for the first time, it builds all libs inside Arduino directory even if it is not needed. But while linking only the relevant files are linked. ([issue #29](https://github.com/sudar/Arduino-Makefile/issues/29)). Even Arduino IDE does the same thing though.

If you find an issue or have an idea for a feature then log them in the [issue tracker](https://github.com/sudar/Arduino-Makefile/issues/)

## Interfacing with other projects/frameworks/IDE's

### Colorgcc

It is possible to use [`colorgcc`](https://github.com/colorgcc/colorgcc) with this makefile. Check out [this comment](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile#comment-1408) to find usage instructions.

### Emacs/Flymake support

On-the-fly syntax checking in Emacs using the [Flymake](http://www.emacswiki.org/emacs/FlyMake) minor mode is now possible.

First, the flymake mode must be configured to recognize ino files :

Edit the flymake configuration :

```
    M-x customize-option RET
    flymake-allowed-file-name-masks RET
```

Add the line :

```
      ("\\.ino\\'" flymake-simple-make-init)
```

Then click on "Apply and Save" button

Then, the following line must be added to the project Makefile :

```
    check-syntax:
        $(CXX_NAME) -c -include Arduino.h   -x c++ $(CXXFLAGS)   $(CPPFLAGS)  -fsyntax-only $(CHK_SOURCES)
```

## Test Suite

This project includes a suite of example Makefiles and small Arduino and chipKIT
programs to assist the maintainers of the Makefile. Run
`tests/script/bootstrap.sh` to attempt to automatically install the dependencies
(Arduino IDE, MPIDE, etc.). Run `tests/script/runtests.sh` to attempt to compile
all of the examples. The bootstrap script is primarily intended for use by a
continuous integration server, specifically Travis CI. It is not intended for
normal users.

### Bare-Arduino–Project

If you are planning on using this makefile in a larger/professional project, you might want to take a look at the [Bare-Arduino–Project](https://github.com/WeAreLeka/Bare-Arduino-Project) framework.

Similar to HTML frameworks, [Bare-Arduino–Project](https://github.com/WeAreLeka/Bare-Arduino-Project) aims at providing a basic `tree` organization, `Makefile` configurations for both OS X and Linux and a handful of instruction on how to get started with a robust Arduino project architecture.

Further information are available in the [README.md](https://github.com/WeAreLeka/Bare-Arduino-Project/blob/master/README.md) as well as in the [use/installation procedure](https://github.com/WeAreLeka/Bare-Arduino-Project/blob/master/INSTALL.md).

Please be sure to report issues to [Bare-Arduino–Project](https://github.com/WeAreLeka/Bare-Arduino-Project/issues) if you use it instead of this project.

## Credits

This makefile was originally created by [Martin Oldfield](http://mjo.tc/atelier/2009/02/arduino-cli.html) and he maintained it till v0.10.2.
From May 2013, it is maintained by [Sudar](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile)

## Similar works
- It's not a derivative of this, but Alan Burlison has written a [similar thing](http://bleaklow.com/2010/06/04/a_makefile_for_arduino_sketches.html).
- Alan's Makefile was used in a [Pragmatic Programmer's article](http://pragprog.com/magazines/2011-04/advanced-arduino-hacking).
- Rei Vilo wrote to tell me that he's using the Makefile ina Xcode 4 template called [embedXcode](http://embedxcode.weebly.com/). Apparently it supports many platforms and boards, including AVR-based Arduino, AVR-based Wiring, PIC32-based chipKIT, MSP430-based LaunchPad and ARM3-based Maple.
