# A Makefile for Arduino Sketches [![Build Status](https://travis-ci.org/sudar/Arduino-Makefile.svg)](https://travis-ci.org/sudar/Arduino-Makefile)

This is a very simple Makefile which knows how to build Arduino sketches. It defines entire workflows for compiling code, flashing it to Arduino and even communicating through Serial monitor. You don't need to change anything in the Arduino sketches.

## Features

- Very robust
- Highly customizable
- Supports all official AVR-based Arduino boards
- Supports official ARM-based Arduino boards using Atmel SAM chip family
and includes on-device debugging targets.
- Supports chipKIT
- Supports Teensy 3.x (via Teensyduino)
- Supports Robotis OpenCR 1.0
- Works on all three major OS (Mac, Linux, Windows)
- Auto detects serial baud rate and libraries used
- Support for `*.ino` and `*.pde` sketches as well as raw `*.c` and `*.cpp`
- Support for Arduino Software versions 0.x, 1.0.x, 1.5.x and 1.6.x except 1.6.2.
We recommend 1.6.3 or above version of Arduino IDE.
- Automatic dependency tracking. Referred libraries are automatically included
in the build process. Changes in `*.h` files lead to recompilation of sources which include them

## Installation

### Through package

#### Using apt-get (or aptitude)

If you're using FreeBSD, Debian, Raspbian or Ubuntu, you can find this in the `arduino-mk`
package which can be installed using `apt-get` or `aptitude`.

```sh
sudo apt-get install arduino-mk
```

#### homebrew (or linuxbrew)

If you're using homebrew (or [linuxbrew](https://github.com/Homebrew/linuxbrew)) then you can find this in the
`arduino-mk` package which can be installed using the following commands.

Also make sure you have the necessary dependencies installed. Refer to the [Requirements](#requirements) section below to install the dependencies.

```sh
# add tap
$ brew tap sudar/arduino-mk

# to install the last stable release
$ brew install arduino-mk

# to install the development version
$ brew install --HEAD arduino-mk
```

#### Arch Linux

Arch Linux users can use the unofficial AUR package [arduino-mk](https://aur.archlinux.org/packages/arduino-mk/).
It can be installed with [AUR] helper using the following command.

```sh
yay -S arduino-mk
```

#### Fedora

Fedora Linux users can use our packaging instructions [here](https://github.com/sudar/Arduino-Makefile/tree/master/packaging/fedora)
to build an RPM.

### From source

- Download the latest release
- Or clone it from Github using the command `git clone git@github.com:sudar/Arduino-Makefile.git`
- Check the [usage section](https://github.com/sudar/Arduino-Makefile#usage) in this readme about setting usage options

## Requirements

### Arduino IDE

You need to have the Arduino IDE. You can either install it through the
installer or download the distribution zip file and extract it.

### pySerial

The Makefile also delegates resetting the board to a short Python program.
You'll need to install [`pySerial`](https://pypi.python.org/pypi/pyserial) to use it though.

On most systems you should be able to install it using either `pip3` or `easy_install3`.

```sh
pip3 install pyserial

# or if you prefer easy_install

easy_install3 -U pyserial
```

If you prefer to install it as a package, then you can do that as well.

On Debian or Ubuntu:

```sh
apt-get install python3-serial
```

On Fedora:

```sh
dnf install python3-pyserial
```

On openSUSE:

```sh
zypper install python3-serial
```

On Arch:

```sh
sudo pacman -S python-pyserial
```

On macOS using Homebrew (one can install to System Python but this is not recommend or good practice):

```sh
brew install python
pip3 install pyserial
```

On Windows:

You need to install Cygwin and its packages for Make, Perl, Python3 and the following Serial library.

Assuming you included Python in your Cygwin installation:

1. download PySerial source package from [https://pypi.python.org/pypi/pyserial](https://pypi.python.org/pypi/pyserial)
2. extract downloaded package running `tar xvzf dowloaded_package_name.tar.gz`
3. navigate to extracted package folder
4. build and install Python module: 
 
```
python3 setup.py build
python3 setup.py install
```

Alternatively, if you have setup Cygwin to use a Windows Python installation,
simply install using pip:

```
pip3 install pyserial
```

Arduino-Makefile should automatically detect the Python installation type and
use the correct device port binding.

## Usage

Download a copy of this repo somewhere to your system or install it through a package by following the above installation instruction.

Sample makefiles are provided in the `examples/` directory.  E.g. [Makefile-example](examples/MakefileExample/Makefile-example.mk) demonstrates some of the more advanced options,
whilst [Blink](examples/Blink/Makefile) demonstrates the minimal settings required for various boards like the Uno, Nano, Mega, Teensy, ATtiny etc.

### Mac

On the Mac with IDE 1.0 you might want to set:

```make
    ARDUINO_DIR   = /Applications/Arduino.app/Contents/Resources/Java
    ARDMK_DIR     = /usr/local
    AVR_TOOLS_DIR = /usr
    MONITOR_PORT  = /dev/ttyACM0
    BOARD_TAG     = mega2560
```

On the Mac with IDE 1.5+ it's like above but with

```make
    ARDUINO_DIR   = /Applications/Arduino.app/Contents/Java
```
### Linux

You can either declare following variables in your project's makefile or set them as environmental variables.

```make
    ARDUINO_DIR – Directory where Arduino is installed
    ARDMK_DIR – Directory where you have copied the makefile
    AVR_TOOLS_DIR – Directory where avr tools are installed
```

Keep in mind, that Arduino 1.5.x+ comes with it's own copy of avr tools which you can leverage in your build process here.

Example of  ~/.bashrc file:

```make
    export ARDUINO_DIR=/home/sudar/apps/arduino-1.0.5
    export ARDMK_DIR=/home/sudar/Dropbox/code/Arduino-Makefile
    export AVR_TOOLS_DIR=/usr/include
```

Example of the project's make file:

```make
    BOARD_TAG     = mega2560
    MONITOR_PORT  = /dev/ttyACM0
```

### Windows

On Windows (using Cygwin), you might want to set:

```make
    # Symbolic link to Arduino installation directory - see below
    ARDUINO_DIR   = C:/Arduino
    ARDMK_DIR     = path/to/mkfile
    MONITOR_PORT  = com3
    BOARD_TAG     = mega2560
```

**NOTE: Use forward slash not backslash and there should be no spaces or
special characters in the Windows paths (due to Win/Unix crossover). The paths
should not be *cygdrive* paths.**

On Windows (using MSYS and PuTTY), you might want to set the following extra parameters:

```make
    MONITOR_CMD   = putty
    MONITOR_PARAMS = 8,1,n,N
```

On Arduino 1.5+ installs, you should set the architecture to either `avr` or `sam` and if using a submenu CPU type, then also set that:

```make
    ARCHITECTURE  = avr
    BOARD_TAG     = atmegang
    BOARD_SUB     = atmega168
```

#### Symbolic Link

It is recommended in Windows that you create a symbolic link to avoid problems with file naming conventions on Windows; unless one installs to a non-default location. For example, if your your Arduino directory is in:

    C:\Program Files (x86)\Arduino

You will get problems with the special characters on the directory name. More details about this can be found in [issue #94](https://github.com/sudar/Arduino-Makefile/issues/94)

To create a symbolic link, you can use the command “mklink” on Windows, e.g.

```sh
mklink /d C:\Arduino C:\Program Files (x86)\Arduino
```
Alternatively if you've setup Cygwin hard symbolic links ([CYGWIN=winsymlinks:native](https://www.cygwin.com/cygwin-ug-net/using-cygwinenv.html)):

```sh
ln -s /cygdrive/c/Program Files\ \(x86\)/Arduino/ C:/Arduino
```

After which, the variables should be:

```make
    ARDUINO_DIR=C:/Arduino
```

Instead of:

```make
    ARDUINO_DIR=C:/Program\ Files\ \(x86\)/Arduino
```

### Useful Variables

The list of all variables that can be overridden is available at [arduino-mk-vars.md](arduino-mk-vars.md) file.

- `BOARD_TAG` - Type of board, for a list see boards.txt or `make show_boards`
- `MONITOR_PORT` - The port where your Arduino is plugged in, usually `/dev/ttyACM0` or `/dev/ttyUSB0` in Linux or Mac OS X and `com3`, `com4`, etc. in Windows.
- `ARDUINO_DIR` - Path to Arduino installation. Using Windows with Cygwin,
  this path must use Unix / and not Windows \\ (eg "C:/Arduino" not
  "C:\\Arduino).
- `ARDMK_DIR`   - Path where the `*.mk` are present. If you installed the package, then it is usually `/usr/share/arduino`. On Windows, this should be a path without spaces and no special characters, it can be a *cygdrive* path if necessary and must use / not \\.
- `AVR_TOOLS_DIR` - Path where the avr tools chain binaries are present. If you are going to use the binaries that came with Arduino installation, then you don't have to set it. Otherwise set it relative and not absolute.



## Including Libraries

You can specify space separated list of libraries that are needed for your sketch in the variable `ARDUINO_LIBS`.

```make
	ARDUINO_LIBS = Wire SoftwareSerial
```

The libraries will be searched for in the following places in the following order.

- `/libraries` directory inside your sketchbook directory. Sketchbook directory will be auto detected from your Arduino preference file. You can also manually set it through `ARDUINO_SKETCHBOOK`.
- `/libraries` directory inside your Arduino directory, which is read from `ARDUINO_DIR`.

The libraries inside user directories will take precedence over libraries present in Arduino core directory.

The makefile can autodetect the libraries that are included from your sketch and can include them automatically. But it can't detect libraries that are included from other libraries. (see [issue #93](https://github.com/sudar/Arduino-Makefile/issues/93))

## avrdude

To upload compiled files, `avrdude` is used. This Makefile tries to find `avrdude` and its config (`avrdude.conf`) below `ARDUINO_DIR`. If you like to use the one installed on your system instead of the one which came with Arduino, you can try to set the variables `AVRDUDE` and `AVRDUDE_CONF`. On a typical Linux system these could be set to

```make
      AVRDUDE      = /usr/bin/avrdude
      AVRDUDE_CONF = /etc/avrdude.conf
```

## Teensy 3.x

For Teensy 3.x support you must first install [Teensyduino](http://www.pjrc.com/teensy/teensyduino.html).

See examples/BlinkTeensy for example usage.

## Robotis OpenCM

For Robotis OpenCM support you must first install [the OpenCM IDE](http://support.robotis.com/en/software/robotis_opencm/robotis_opencm.htm)

See examples/BlinkOpenCM for example usage.

For large Robotis projects, [libmaple](https://github.com/Rhoban/Maple) may be more appropriate, as the OpenCM IDE uses a very old compiler release.

## Arduino ARM Boards

For Arduino boards using ARM architechure, specifically the Atmel SAM series
((SAM3X8E) Due; (SAMD21) Arduino M0 [Pro], Zero, MKR1000, Feather M0, etc.), first
install the board support package from the IDE or other distribution channels.

Define`ARDUINO_PACKAGE_DIR` as the root path containing the ARM support
package (the manufacturer folder) and the `BOARD_TAG` (see `make show_boards`
for help) within your project Makefile. Include 'Sam.mk' rather than
  'Arduino.mk' at the end of your file - see examples/ZeroBlink,
  examples/MZeroBlink and examples/DueBlink for example usage.

**Note**: The Arduino IDE does not install board support packages to
the base Arduino installation directory (the directory that will work with AVR
Makefiles). They are generally installed to a '.arduino15/packages' folder in
the users home directory. This is the reason for the new `ARDUINO_PACKAGE_DIR`
define. On Windows, the package directory is often in the user home directory
so advice is to create a symblic link to avoid slash/space in path problems.
You can also manually install support packages in your Sketchbook 'hardware'
folder, then define ARDUINO_PACKAGE_DIR as this path.

If using a SAM board from a manufacturer other than Arduino, one must still
install the Arduino board support as above (unless using externally defined
toolchain) and then define the location of the manufacturer board support core
using the ALTERNATIVE_CORE_PATH define. For example: `ALTERNATE_CORE_PATH =
$(ARDUINO_SKETCHBOOK)/hardware/sparkfun/samd`

The programing method will auto-detect based on the `BOARD_TAG` settings read
from boards.txt:

Programming using OpenOCD CMSIS-DAP with the Programming/debug USB is
currently supported (the same method used by the IDE), including burning
bootloaders. External CMSIS tools such as Atmel Ice will also work with this
method. Black Magic Probe (BMP) support is also included using GDB for both
uploading and debugging.

Native USB programing using Bossa (Due, Zero, MKR1000, Feather style bootloaders)
and avrdude (M0 bootloaders) is supported. The bootloaders on these devices
requires a double press of the reset button or open/closing the serial port at
1200 BAUD. The automatic entry of the bootloader is attempted using
`ard-reset-arduino` when using the general `make upload` target by polling
attached devices until the bootloader port re-attaches (same method as the
IDE). On Windows, the USB enumerates as differnt COM ports for the CDC Serial
and bootloader and these must be defined. On encountering problems, one can
manually enter the bootloader then upload using the `make raw_upload` target.
Note that the `make reset` target will enter the bootloader on these devices;
there is no way to reset over USB.

If using system installed tools, be aware that `openocd` and `bossa` were
orginally forked for Arduino support and system distributions may not be up
to date with merged changes. `bossa` must be version 1.7->. `openocd` should
work but there may be problems at run time
[ref](https://github.com/pda/arduino-zero-without-ide). Ideally, use the
support packaged version or compile and install the Arduino fork.

With the ARM chipset and using a CMSIS-DAP tool, on-device debugging is made available:

* `debug_init` and `debug` targets for on-device debugging using GDB. To use
  this, one must start the GDB server with `make debug_init &`, followed by
  connecting to the target with `make debug`. If using a Black Magic Probe,
  one can just use `make debug`. At the moment, a system wide `arm-none-eabi-gdb` must be
  installed as the one supplied with the Arduino toolchain
  does not appear to work. 
* Example usage: https://asciinema.org/a/Jarz7Pr3gD6mqaZvCACQBzqix
* See the examples/MZeroBlink Makefile for a commented example.

## Versioning

The current version of the makefile is `1.6.0`. You can find the full history in the [HISTORY.md](HISTORY.md) file

This project adheres to Semantic [Versioning 2.0](http://semver.org/).

## License

This makefile and the related documentation and examples are free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as
published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

## Contribution

All contributions (even documentation) are welcome :) Open a pull request and I would be happy to merge them.
Also checkout the [contribution guide](CONTRIBUTING.md) for more details.

If you are looking for ideas to work on, then check out the following TODO items or the [issue tracker](https://github.com/sudar/Arduino-Makefile/issues/).

## Limitations / Known Issues / TODO's

- Since it doesn't do any pre processing like Arduino IDE, you have to declare all methods before you use them ([issue #59](https://github.com/sudar/Arduino-Makefile/issues/59))
- More than one .ino or .pde file is not supported yet ([issue #49](https://github.com/sudar/Arduino-Makefile/issues/49))
- When you compile for the first time, it builds all libs inside Arduino directory even if it is not needed. But while linking only the relevant files are linked. ([issue #29](https://github.com/sudar/Arduino-Makefile/issues/29)). Even Arduino IDE does the same thing though.
- This makefile doesn't support boards or IDE from Arduino.org.

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

```make
    check-syntax:
        $(CXX) -c -include Arduino.h   -x c++ $(CXXFLAGS)   $(CPPFLAGS)  -fsyntax-only $(CHK_SOURCES)
```

### Code:Blocks integration

In Code:Blocks open Project -> Properties -> Project settings tab -> check "This is custom Makefile".

Now go to Settings -> Environment -> Environment variables -> Add

Add three keys with paths as values, using full paths (!):

```make
	ARDUINO_DIR=/full/path/to/arduino-1.0.6
	ARDMK_DIR=/full/path/to/sketchbook
	AVR_TOOLS_DIR=/usr
```

Now to set DEBUG target (this will compile the project) go to Build options -> Debug -> "Make" commands

In Build Project/Target remove $target:

```sh
$make -f $makefile
```

In Clean Project/Target remove $target:

```sh
$make -f $makefile clean
```

To set the RELEASE target (which will compile and upload) go to Build options -> Release -> "Make" commands

In Build Project/Target put:

```sh
$make -f $makefile upload
```

In Clean Project/Target remove $target:

```sh
$make -f $makefile clean
```

## Test Suite

This project includes a suite of example Makefiles and small Arduino and chipKIT
programs to assist the maintainers of the Makefile. Run
`tests/script/bootstrap.sh` to attempt to automatically install the dependencies
(Arduino IDE, MPIDE, etc.). Run `tests/script/runtests.sh` to attempt to compile
all of the examples. The bootstrap script is primarily intended for use by a
continuous integration server, specifically Travis CI. It is not intended for
normal users.

## Makefile Generator and Project Initialisation

`ardmk-init` within the bin/ folder is a utility Python script to create a
Arduino-mk Makefile for a project and also has option to create a traditional *tree*
organization (src, lib, bin). It can be used as with commanline arguments or
prompted - see examples below (append `$ARDMK_DIR/bin/` to command if not on path):

* Run prompted within current working directory: `ardmk-init`
* Create Arduino Uno Makefile (useful within a library example): `ardmk-init -qb uno`
* Create boilerplate Arduino Uno project in current working directory of same
  name: `ardmk-init -b uno --quiet --project`
* Create Arduino-mk nano Makefile in current working directory with template .ino: `ardmk-init -b nano -u atmega328 -qtn my-project`
* See `ardmk-init --help` for more.

### Bare-Arduino–Project

If you are planning on using this makefile in a larger/professional project, you might want to take a look at the [Bare-Arduino–Project](https://github.com/WeAreLeka/Bare-Arduino-Project) framework.

Similar to HTML frameworks, [Bare-Arduino–Project](https://github.com/WeAreLeka/Bare-Arduino-Project) aims at providing a basic `tree` organization, `Makefile` configurations for both OS X and Linux and a handful of instruction on how to get started with a robust Arduino project architecture.

Further information are available in the [README.md](https://github.com/WeAreLeka/Bare-Arduino-Project/blob/master/README.md) as well as in the [use/installation procedure](https://github.com/WeAreLeka/Bare-Arduino-Project/blob/master/INSTALL.md).

Please be sure to report issues to [Bare-Arduino–Project](https://github.com/WeAreLeka/Bare-Arduino-Project/issues) if you use it instead of this project.

## Credits

This makefile was originally created by [Martin Oldfield](http://mjo.tc/atelier/2009/02/arduino-cli.html) and he maintained it till v0.10.2.
From May 2013, it is maintained by [Sudar Muthu](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile) and [Simon John](https://github.com/sej7278) with the help of [40+ contributors](https://github.com/sudar/Arduino-Makefile/graphs/contributors).

## Similar works
- It's not a derivative of this, but Alan Burlison has written a [similar thing](http://bleaklow.com/2010/06/04/a_makefile_for_arduino_sketches.html).
- Alan's Makefile was used in a [Pragmatic Programmer's article](http://pragprog.com/magazines/2011-04/advanced-arduino-hacking).
- Rei Vilo wrote to tell me that he's using the Makefile ina Xcode 4 template called [embedXcode](http://embedxcode.weebly.com/). Apparently it supports many platforms and boards, including AVR-based Arduino, AVR-based Wiring, PIC32-based chipKIT, MSP430-based LaunchPad and ARM3-based Maple.
