# Documentation of variables

The following are the different variables that can be overwritten in the user makefiles.

*	[Global variables](#global-variables)
*	[Installation/Directory variables](#installationdirectory-variables)
*	[Arduino IDE variables](#arduino-ide-variables)
*	[Sketch related variables](#sketch-related-variables)
*	[ISP programming variables](#isp-programming-variables)
*	[Compiler/Executable variables](#compilerexecutable-variables)
*	[Avrdude setting variables](#avrdude-setting-variables)
*	[Bootloader variables](#bootloader-variables)
*	[ChipKIT variables](#chipkit-variables)

## Global variables

### ARDUINO_QUIET

**Description:**

Suppress printing of Arduino-Makefile configuration.

Defaults to `0` (unset/disabled).

**Example:**

```Makefile
ARDUINO_QUIET = 1
```

**Requirement:** *Optional*

----

## Installation/Directory variables

### ARDMK_DIR

**Description:**

Directory where the `*.mk` files are stored.

Usually can be auto-detected as parent of `Arduino.mk`.

**Example:**

```Makefile
ARDMK_DIR = /usr/share/arduino
```

**Requirement:** *Optional*

----

### AVR_TOOLS_DIR

**Description:**

Directory where tools such as `avrdude`, `avr-g++`, `avr-gcc`, etc. are stored in the `bin/` subdirectory.

Usually can be auto-detected from `$PATH` as `SYSTEMPATH_AVR_TOOLS_DIR` or as `BUNDLED_AVR_TOOLS_DIR` within the Arduino distribution.

**Example:**

```Makefile
AVR_TOOLS_DIR = /usr
# or
AVR_TOOLS_DIR = /usr/share/arduino/hardware/tools/avr
```

**Requirement:** *Optional*

----

### RESET_CMD

**Description:**

Command to reset the MCU.

Defaults to `ard-reset-arduino` with the extra `--caterina` flag for atmega32u4 boards.

**Example:**

```Makefile
RESET_CMD = ~/gertduino/reset
```

**Requirement:** *Optional*

----

## Arduino IDE variables

### ARDUINO_DIR

**Description:**

Directory where the Arduino IDE and/or core files are stored. Usually can be auto-detected as `AUTO_ARDUINO_DIR`.

**Example:**

```Makefile
# Linux
ARDUINO_DIR = /usr/share/arduino
# Mac OS X
ARDUINO_DIR = /Applications/Arduino.app/Contents/Resources/Java
# Mac OSX with IDE 1.5+
ARDUINO_DIR = /Applications/Arduino.app/Contents/Java
```

**Requirement:** *Optional*

----

### ARDUINO_PLATFORM_LIB_PATH

**Description:**

Directory where the Arduino platform dependent libraries are stored.
(Used only for Arduino 1.5+)

**Example:**

```Makefile
ARDUINO_PLATFORM_LIB_PATH = /usr/share/arduino/hardware/arduino/avr/libraries
```

**Requirement:** *Optional*

----

### ARDUINO_VERSION

**Description:**

Version string for Arduino IDE and/or core.

Usually can be auto-detected as `AUTO_ARDUINO_VERSION` from `/usr/share/arduino/lib/version.txt`

**Example:**

```Makefile
ARDUINO_VERSION = 105
```

**Requirement:** *Optional*

----

### ARCHITECTURE

**Description:**

Architecture for Arduino 1.5+

Defaults to unset for 1.0 or `avr` for 1.5+

**Example:**

```Makefile
ARCHITECTURE = sam
```

**Requirement:** *Optional*

----

### ARDMK_VENDOR

**Description:**

Board vendor/maintainer.

Defaults to `arduino`

**Example:**

```Makefile
ARDMK_VENDOR = sparkfun
```

**Requirement:** *Optional*

----

### ARDUINO_SKETCHBOOK

**Description:**

Path to `sketchbook` directory.

Usually can be auto-detected from the Arduino `preferences.txt` file or the default `~/sketchbook`

**Example:**

```Makefile
ARDUINO_SKETCHBOOK = ~/sketches
```

**Requirement:** *Optional*

----

### ARDUINO_PREFERENCES_PATH

**Description:**

Path to Arduino `preferences.txt` file.

Usually can be auto-detected as `AUTO_ARDUINO_PREFERENCES` from the defaults:

*	on Linux (1.0):     `~/.arduino/preferences.txt`
*	on Linux (1.5+):    `~/.arduino15/preferences.txt`
*	on Mac OS X (1.0):  `~/Library/Arduino/preferences.txt`
*	on Mac OS X (1.5+): `~/Library/Arduino15/preferences.txt`

**Example:**

```Makefile
ARDUINO_PREFERENCES_PATH = ~/sketches/preferences.txt
```

**Requirement:** *Optional*

----

### ARDUINO_CORE_PATH

**Description:**

Path to standard Arduino core files.

**Example:**

```Makefile
ARDUINO_CORE_PATH = /usr/share/arduino/hardware/arduino/cores/arduino
```

**Requirement:** *Optional*

----

## Sketch related variables

### ARDUINO_LIBS

**Description:**

Any libraries you intend to include.

Usually can be auto-detected from the sketch. Separated by spaces. If the library has a `/utility` folder (like `SD` or `Wire` library), then the utility folder should also be specified.

**Example:**

```Makefile
ARDUINO_LIBS = SD SD/utility Wire Wire/utility
```

**Requirement:** *Optional*

----

### BOARD_TAG

**Description:**

Device type as listed in `boards.txt` or `make show_boards`.

**Example:**

```Makefile
BOARD_TAG = uno or mega2560
```

**Requirement:** *Mandatory*

----

### BOARD_SUB

**Description:**

1.5+ submenu as listed in `boards.txt`

**Example:**

```Makefile
# diecimila.name=Arduino Duemilanove or Diecimila
BOARD_TAG=diecimila

# diecimila.menu.cpu.atmega168=ATmega168
BOARD_SUB=atmega168
```

**Requirement:** *Mandatory for 1.5+ if using a submenu CPU*

----

### MONITOR_PORT

**Description:**

Path to serial (USB) device used for uploading/serial comms.

**Example:**

```Makefile
# Linux
MONITOR_PORT = /dev/ttyUSB0
# or
MONITOR_PORT = /dev/ttyACM0
# Mac OS X
MONITOR_PORT = /dev/cu.usb*
# Windows
MONITOR_PORT = com3
```

**Requirement:** *Mandatory*

----

### FORCE_MONITOR_PORT

**Description:**

Skip the MONITOR_PORT existance check.

**Example:**

```Makefile
# Enable
FORCE_MONITOR_PORT = true
# Disable (default)
undefine FORCE_MONITOR_PORT
```

**Requirement:** *Optional*

----

### USER_LIB_PATH

**Description:**

Directory where additional libraries are stored.

Defaults to `libraries` directory within user's sketchbook.

**Example:**

```Makefile
# Linux
USER_LIB_PATH = ~/sketchbook/libraries
# For a random project on *nix
USER_LIB_PATH = /path/to/my/project
```

**Requirement:** *Optional*

----

### OBJDIR

**Description:**

Directory where binaries and compiled files are put.

Defaults to `build-$(BOARD_TAG)` in your `Makefile` directory.

**Example:**

```Makefile
OBJDIR = /path/to/my/project-directory/bin
```

**Requirement:** *Optional*

----

### TARGET

**Description:**

What name you would like for generated target files.

Defaults to the name of your current working directory, but with underscores (_) instead of spaces.

**Example:**

```Makefile
TARGET = my-project
```

Will generate targets like `my-project.hex` and `my-project.elf`.

**Requirement:** *Optional*

----

### ALTERNATE_CORE

**Description:**

Non-standard core for Arduino-unsupported chips like the ATtiny.

**Example:**

```Makefile
# HLT core
ALTERNATE_CORE = attiny-master
# tiny core
ALTERNATE_CORE = arduino-tiny
# tiny core 2
ALTERNATE_CORE = tiny2
```

**Requirement:** *Optional*

----

### ARDUINO_VAR_PATH

**Description:**

Path to non-standard core's variant files.

**Example:**

```Makefile
ARDUINO_VAR_PATH = ~/sketchbook/hardware/arduino-tiny/cores/tiny
```

**Requirement:** *Optional*

----

### CORE

**Description:**

Name of the core *inside* the ALTERNATE_CORE or the standard core.

Usually can be auto-detected as `build.core` from `boards.txt`.

**Example:**

```Makefile
# standard Arduino core (undefine ALTERNATE_CORE)
CORE = arduino
# or
CORE = robot
# tiny core (ALTERNATE_CORE = arduino-tiny)
CORE = tiny
```

**Requirement:** *Optional*

----

### VARIANT

**Description:**

Variant of a standard board design.

Usually can be auto-detected as `build.variant` from `boards.txt`.

**Example:**

```Makefile
VARIANT = leonardo
```

**Requirement:** *Optional*

----

### USB_TYPE

**Description:**

Define Teensy 3.1 usb device type. Default is USB_SERIAL

**Example:**

```Makefile
USB_TYPE = USB_SERIAL
# or
USB_TYPE = USB_HID
# or
USB_TYPE = USB_SERIAL_HID
# or
USB_TYPE = USB_MIDI
# or
USB_TYPE = USB_RAWHID
# or
USB_TYPE = USB_FLIGHTSIM
```

**Requirement:** *Optional*

----

### USB_VID

**Description:**

Override `USB VID` for atmega32u4 boards.

Usually can be auto-detected as `build.vid` from `boards.txt`

**Example:**

```Makefile
USB_VID = 0x2341
```

**Requirement:** *Optional*

----

### USB_PID

**Description:**

Override `USB PID` for atmega32u4 boards.

Usually can be auto-detected as `build.pid` from `boards.txt`

**Example:**

```Makefile
USB_PID = 0x8039
```

**Requirement:** *Optional*

----

### F_CPU

**Description:**

CPU speed in Hz

Usually can be auto-detected as `build.f_cpu` from `boards.txt`, except in
some 1.5+ cores like attiny where there is a clock submenu.

**Example:**

```Makefile
F_CPU = 8000000L
```

**Requirement:** *Optional*

----

### HEX_MAXIMUM_SIZE

**Description:**

Maximum hex file size

Usually can be auto-detected as `upload.maximum_size` from `boards.txt`

**Example:**

```Makefile
HEX_MAXIMUM_SIZE = 14336
```

**Requirement:** *Optional*

----

### MCU

**Description:**

Microcontroller model.

Usually can be auto-detected as `build.mcu` from `boards.txt`

**Example:**

```Makefile
MCU = atmega32u4
```

**Requirement:** *Optional*

----

### MCU_FLAG_NAME

**Description:**

Override default MCU flags.

Defaults to `mmcu`

**Example:**

```Makefile
MCU_FLAG_NAME = mprocessor
```

**Requirement:** *Optional*

----

### MONITOR_BAUDRATE

**Description:**

Baudrate of the serial monitor.

Defaults to `9600` if it can't find it in the sketch `Serial.begin()`

**Example:**

```Makefile
MONITOR_BAUDRATE = 57600
```

**Requirement:** *Optional*

----

## ISP programming variables

### ISP_PROG

**Description:**

Type of ISP. Either a USB device or ArduinoISP protocol.

**Example:**

```Makefile
ISP_PROG = usbasp
# or
ISP_PROG = usbtiny
# or
ISP_PROG = stk500v2
# or
ISP_PROG = stk500v1
```

**Requirement:** *Optional*

----

### ISP_PORT

**Description:**

Device path to ArduinoISP. Not needed for hardware ISP's.

**Example:**

```Makefile
# Linux
ISP_PORT = /dev/ttyACM0
```

**Requirement:** *Optional*

----

### ISP_LOCK_FUSE_PRE

**Description:**

Bootloader unlock bits.

Usually can be auto-detected from `boards.txt`

**Example:**

```Makefile
ISP_LOCK_FUSE_PRE = 0x3f
```

**Requirement:** *Optional*

----

### ISP_LOCK_FUSE_POST

**Description:**

Bootloader lock bits.

Usually can be auto-detected from `boards.txt`

**Example:**

```Makefile
ISP_LOCK_FUSE_POST = 0xcf
```

**Requirement:** *Optional*

----

### ISP_HIGH_FUSE

**Description:**

`ISP_LOW_FUSE/ISP_EXT_FUSE` - high/low/extended fuse bits.

Usually can be auto-detected from `boards.txt`

**Example:**

```Makefile
ISP_HIGH_FUSE = 0xdf # or 0xff or 0x01
```

**Requirement:** *Optional*

----

### ISP_EEPROM

**Description:**

Whether to upload the EEPROM file or not.

Defaults to `0`

**Example:**

```Makefile
ISP_EEPROM = 1
```

**Requirement:** *Optional*

----

## Compiler/Executable variables

### CC_NAME

**Description:**

C compiler.

Defaults to `avr-gcc`

**Example:**

```Makefile
CC_NAME = pic32-gcc
```

**Requirement:** *Optional*

----

### CXX_NAME

**Description:**

C++ compiler.

Defaults to `avr-g++`

**Example:**

```Makefile
CXX_NAME = pic32-g++
```

**Requirement:** *Optional*

----

### OBJCOPY_NAME

**Description:**

Objcopy utility.

Defaults to `avr-objcopy`

**Example:**

```Makefile
OBJCOPY_NAME = pic32-objcopy
```

**Requirement:** *Optional*

----

### OBJDUMP_NAME

**Description:**

Objdump utility.

Defaults to `avr-objdump`

**Example:**

```Makefile
OBJDUMP_NAME = pic32-objdump
```

**Requirement:** *Optional*

----

### AR_NAME

**Description:**

Archive utility.

Defaults to `avr-ar`

**Example:**

```Makefile
AR_NAME = pic32-ar
```

**Requirement:** *Optional*

----

### SIZE_NAME

**Description:**

Size utility.

Defaults to `avr-size`

**Example:**

```Makefile
SIZE_NAME = pic32-size
```

**Requirement:** *Optional*

----

### NM_NAME

**Description:**

Nm utility.

Defaults to `avr-nm`

**Example:**

```Makefile
NM_NAME = pic32-nm
```

**Requirement:** *Optional*

----

### OPTIMIZATION_LEVEL

**Description:**

Linker's `-O` flag

Defaults to `s`, which shouldn't really be changed as it breaks `SoftwareSerial` and usually results in bigger hex files.

**Example:**

```Makefile
OPTIMIZATION_LEVEL = 3
```

**Requirement:** *Optional*

----

### CFLAGS_STD

**Description:**

Controls, *exclusively*, which C standard is to be used for compilation.

Defaults to `undefined`

Possible values:

*	With `avr-gcc 4.3`, shipped with the Arduino IDE:
	*	`undefined`
	*	`-std=c99`
	*	`-std=gnu89` - This is the default for C code
	*	`-std=gnu99`
*	With `avr-gcc 4.7, 4.8 or 4.9`, installed by you
	*	`undefined`
	*	`-std=c99`
	*	`-std=c11`
	*	`-std=gnu89` - This is the default for C code
	*	`-std=gnu99`
	*	`-std=gnu11`

For more information, please refer to the [Options Controlling C Dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html)

**Example:**

```Makefile
CFLAGS_STD = = -std=gnu89
```

**Requirement:** *Optional*

----

### CXXFLAGS_STD

**Description:**

Controls, *exclusively*, which C++ standard is to be used for compilation.

Defaults to `undefined`

Possible values:

*	With `avr-gcc 4.3`, shipped with the Arduino IDE:
	*	`undefined`
	*	`-std=c++98`
	*	`-std=c++0x`
	*	`-std=gnu++98` - This is the default for C code
	*	`-std=gnu++0x`
*	With `avr-gcc 4.7, 4.8 or 4.9`, installed by you
	*	`undefined`
	*	`-std=c++98`
	*	`-std=c++11`
	*	`-std=c++1y`
	*	`-std=c++14`
	*	`-std=gnu++98` - This is the default for C++ code
	*	`-std=gnu++11`
	*	`-std=gnu++1y`
	*	`-std=gnu++14`

For more information, please refer to the [Options Controlling C Dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html)

**Example:**

```Makefile
CXXFLAGS_STD = = -std=gnu++98
```

**Requirement:** *Optional*

----

### CFLAGS

**Description:**

Flags passed to compiler for files compiled as C. Add more flags to this
variable using `+=`.

Defaults to all flags required for a typical build.

**Example:**

```Makefile
CFLAGS += -my-c-only-flag
```

**Requirement:** *Optional*

----

### CXXFLAGS

**Description:**

Flags passed to the compiler for files compiled as C++. Add more flags to this
variable using `+=`.

Defaults to all flags required for a typical build.

**Example:**

```Makefile
CXXFLAGS += -my-c++-onlyflag
```

**Requirement:** *Optional*

----

### ASFLAGS

**Description:**

Flags passed to compiler for files compiled as assembly (e.g. `.S` files). Add
more flags to this variable using `+=`.

Defaults to all flags required for a typical build.

**Example:**

```Makefile
ASFLAGS += -my-as-only-flag
```

**Requirement:** *Optional*

----

### CPPFLAGS

**Description:**

Flags passed to the C pre-processor (for C, C++ and assembly source flies). Add
more flags to this variable using `+=`.

Defaults to all flags required for a typical build.

**Example:**

```Makefile
CPPFLAGS += -DMY_DEFINE_FOR_ALL_SOURCE_TYPES
```

**Requirement:** *Optional*

----

### OVERRIDE_EXECUTABLES

**Description:**

Override the default build tools.

If set to `1`, each tool (`CC`, `CXX`, `AS`, `OBJCOPY`, `OBJDUMP`, `AR`, `SIZE`, `NM`) must have its path explicitly defined. See `chipKIT.mk`.

**Example:**

```Makefile
OVERRIDE_EXECUTABLES = 1
```

**Requirement:** *Optional*

----

### MONITOR_CMD

**Description:**

Command to run the serial monitor.

Defaults to `screen`

**Example:**

```Makefile
MONITOR_CMD = minicom
```

**Requirement:** *Optional*

----

### PRE_BUILD_HOOK

**Description:**

Path to shell script to be executed before build. Could be used to automatically
bump revision number for example.

Defaults to `pre-build-hook.sh`

**Example:**

```Makefile
PRE_BUILD_HOOK = ~/bin/bump-revision.sh
```

**Requirement:** *Optional*

----

## Avrdude setting variables

### AVRDUDE

**Description:**

Path to `avrdude` utility

Usually can be auto-detected within the parent of `AVR_TOOLS_DIR` or in the `$PATH`

**Example:**

```Makefile
AVRDUDE = /usr/bin/avrdude
```

**Requirement:** *Optional*

----

### AVRDUDE_CONF

**Description:**

Path to `avrdude.conf` file

Usually can be auto-detected within the parent of `AVR_TOOLS_DIR`

**Example:**

```Makefile
AVRDUDE_CONF = /etc/avrdude.conf
# or
AVRDUDE_CONF = /usr/share/arduino/hardware/tools/avrdude.conf
```

**Requirement:** *Optional*

----

### AVR_TOOLS_PATH

**Description:**

Directory where tools such as `avrdude`, `avr-g++`, `avr-gcc` etc. are stored.

Usually can be auto-detected from `AVR_TOOLS_DIR/bin`

**Example:**

```Makefile
AVR_TOOLS_PATH = /usr/bin
# or
AVR_TOOLS_PATH = /usr/share/arduino/hardware/tools/avr/bin
```

**Requirement:** *Optional*

----

### ARDUINO_LIB_PATH

**Description:**

Directory where the standard Arduino libraries are stored.

Defaults to `ARDUINO_DIR/libraries`

**Example:**

```Makefile
# Linux
ARDUINO_LIB_PATH = /usr/share/arduino/libraries
```

**Requirement:** *Optional*

----

### ARDUINO_CORE_PATH

**Description:**

Directory where the standard Arduino cores are stored.

Defaults to `ARDUINO_DIR/hardware/arduino/cores/arduino`

**Example:**

```Makefile
ARDUINO_CORE_PATH = /usr/share/arduino/hardware/arduino/cores/robot
```

**Requirement:** *Optional*

----

### ALTERNATE_CORE_PATH

**Description:**

Path to non-standard cores.

Defaults to `ARDUINO_SKETCHBOOK/hardware/ALTERNATE_CORE`

**Example:**

```Makefile
ALTERNATE_CORE_PATH = ~/sketchbook/hardware/arduino-tiny/cores/tiny
```

**Requirement:** *Optional*

----

### BOARDS_TXT

**Description:**

Path to `boards.txt`

Defaults to `ARDUINO_DIR/hardware/arduino/boards.txt`

**Example:**

```Makefile
BOARD_TXT = ~/sketchbook/hardware/boards.txt
# or
BOARD_TXT = /usr/share/arduino/hardware/arduino/boards.txt
```

**Requirement:** *Optional*

----

### AVRDUDE_ARD_BAUDRATE

**Description:**

Upload speed

Usually can be auto-detected as `upload.speed` from `boards.txt`

**Example:**

```Makefile
AVRDUDE_ARD_BAUDRATE = 19200
```

**Requirement:** *Optional*

----

### AVRDUDE_ARD_PROGRAMMER

**Description:**

Upload protocol

Usually can be auto-detected as `upload.protocol` from `boards.txt`

**Example:**

```Makefile
AVRDUDE_ARD_PROGRAMMER = stk500v1
```

**Requirement:** *Optional*

----

### AVRDUDE_ISP_BAUDRATE

**Description:**

ISP speed if different to `upload.speed`

Defaults to same as `AVRDUDE_ARD_BAUDRATE` or `19200`

**Example:**

```Makefile
AVRDUDE_ISP_BAUDRATE = 19200
```

**Requirement:** *Optional*

----

### AVRDUDE_OPTS

**Description:**

Options to pass to `avrdude`.

Defaults to `-q -V` (quiet, don't verify). User values are not *ANDed* to the defaults, you have to set each option you require.

**Example:**

```Makefile
AVRDUDE_OPTS = -v
```

**Requirement:** *Optional*

----

## Bootloader variables

### BOOTLOADER_FILE

**Description:**

File for bootloader.

Usually can be auto-detected as `bootloader.file` from `boards.txt`

**Example:**

```Makefile
BOOTLOADER_FILE = optiboot_atmega328.hex
```

**Requirement:** *Optional*

----

### BOOTLOADER_PATH

**Description:**

Relative path to bootloader directory.

Usually can be auto-detected as a relative `bootloader.path` from `boards.txt`

Deprecated in 1.5, now part of bootloader.file

**Example:**

```Makefile
BOOTLOADER_PATH = optiboot
# or
BOOTLOADER_PATH = arduino:atmega
```

**Requirement:** *Optional*

----

### BOOTLOADER_PARENT

**Description:**

Absolute path to bootloader file's parent directory.

Defaults to `/usr/share/arduino/hardware/arduino/bootloaders` (Linux)

**Example:**

```Makefile
BOOTLOADER_PARENT = ~/sketchbook/hardware/promicro/bootloaders
BOOTLOADER_PATH  = caterina
BOOTLOADER_FILE  = Caterina-promicro16.hex
```

Would result in an absolute path to the bootloader hex file of `~/sketchbook/hardware/promicro/bootloaders/caterina/Caterina-promicro16.hex`

**Requirement:** *Optional, unless BOOTLOADER_FILE and/or BOOTLOADER_PATH are user-defined*

----

## ChipKIT variables

### MPIDE_DIR

**Description:**

Path to chipKIT MP IDE

Usually can be auto-detected as `AUTO_MPIDE_DIR` from the defaults `/usr/share/mpide` (Linux) or `/Applications/Mpide.app/Contents/Resources/Java` (OSX)

**Example:**

```Makefile
MPIDE_DIR = ~/mpide
```

**Requirement:** *Optional*

----

### MPIDE_PREFERENCES_PATH

**Description:**

Path to chipKIT `preferences.txt` file.

Usually can be auto-detected as `AUTO_MPIDE_PREFERENCES_PATH` from the defaults `~/.mpide/preferences.txt` (Linux) or `~/Library/Mpide/preferences.txt` (OSX)

**Example:**

```Makefile
MPIDE_PREFERENCES_PATH = ~/chipkit/preferences.txt
```

**Requirement:** *Optional*
