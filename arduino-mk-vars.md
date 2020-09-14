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
*	[ARM variables](#arm-variables)
*	[Ctags variables](#ctags-variables)

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

### ARM_TOOLS_DIR

**Description:**

Directory where the arm toolchain is installed. `arm-none-eabi-*` should be
within a /bin subdirectory.

Can usually be detected from `$ARDUINO_PACKAGE_DIR` /tools subdirectory when ARM
device support is installed.

**Example:**

```Makefile
ARM_TOOLS_DIR = /usr
# or
ARM_TOOLS_DIR =
/usr/share/arduino/hardware/tools/arm-none-eabi-gcc/VERSION
```

**Requirement:** *Optional*

----

### ARM_TOOLS_VER

**Description:**

Sub-directory where the arm toolchain is installed - usually the tool version.

Can usually be detected from `$ARDUINO_PACKAGE_DIR` /tools subdirectory when ARM
device support is installed. Will resolve latest version if multiple found.

**Example:**

```Makefile
ARM_TOOLS_VER = 7-2017q4
```

**Requirement:** *Optional*

----

### RESET_CMD

**Description:**

Command to reset the MCU.

Defaults to `ard-reset-arduino` with the extra `--caterina` flag for atmega32u4 boards.

**Example:**

```Makefile
RESET_CMD = $(HOME)/gertduino/reset
```

**Requirement:** *Optional*

----

### PYTHON_CMD

**Description:**

Path to Python binary. Requires pyserial module installed. Makefile will error if unable to auto-find as utility scripts will not work. To override this, give it an empty define.

**Example:**

```Makefile
PYTHON_CMD = /usr/bin/python3
```

**Requirement:** *Optional*

----

### GREP_CMD

**Description:**

Path to GNU grep binary. Only added for macOS, which has BSD grep by default but results in some parsing warnings. macOS users should install GNU grep using Homebrew.

**Example:**

```Makefile
GREP_CMD = /bin/grep
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

### ARDUINO_PACKAGE_DIR

**Description:**

Directory where the Arduino package support files are stored. Can auto-detect based on default OS IDE locations.

**Example:**

```Makefile
# Linux
ARDUINO_PACKAGE_DIR = $(HOME)/.arduino15/packages
# Mac OS X
ARDUINO_PACKAGE_DIR = $(HOME)/Library/Arduino15/packages
# Windows
ARDUINO_PACKAGE_DIR = $(USERPROFILE)/AppData/Local/Arduino15/packages
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

Defaults to unset for 1.0 or `avr` for 1.5+. This value is not literally the chip architecture but will often be
the chip series within a vendor's 'hardware' folder. For example, will default to `samd` if using Sam.mk.

**Example:**

```Makefile
ARCHITECTURE = arm
```

**Requirement:** *Optional*

----

### ARDMK_VENDOR

**Description:**

Board vendor/maintainer/series.

Defaults to `arduino`.

**Example:**

```Makefile
ARDMK_VENDOR = sparkfun
```

**Requirement:** *Optional*

----

### ARDUINO_SKETCHBOOK

**Description:**

Path to `sketchbook` directory.

Usually can be auto-detected from the Arduino `preferences.txt` file or the default `$(HOME)/sketchbook`

**Example:**

```Makefile
ARDUINO_SKETCHBOOK = $(HOME)/sketches
```

**Requirement:** *Optional*

----

### ARDUINO_PREFERENCES_PATH

**Description:**

Path to Arduino `preferences.txt` file.

Usually can be auto-detected as `AUTO_ARDUINO_PREFERENCES` from the defaults:

*	on Linux (1.0):     `$(HOME)/.arduino/preferences.txt`
*	on Linux (1.5+):    `$(HOME)/.arduino15/preferences.txt`
*	on Mac OS X (1.0):  `$(HOME)/Library/Arduino/preferences.txt`
*	on Mac OS X (1.5+): `$(HOME)/Library/Arduino15/preferences.txt`

**Example:**

```Makefile
ARDUINO_PREFERENCES_PATH = $(HOME)/sketches/preferences.txt
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

1.5+ submenu as listed in `boards.txt` or `make show_submenu`.

**Example:**

```Makefile
# diecimila.name=Arduino Duemilanove or Diecimila
BOARD_TAG=diecimila

# diecimila.menu.cpu.atmega168=ATmega168
BOARD_SUB=atmega168
```

**Requirement:** *Mandatory for 1.5+ if using a submenu CPU*

----

### BOARD_CLOCK

**Description:**

Allow selection of f_cpu and fuses specified in `boards.txt` as `{BOARD_TAG}.menu.clock.{BOARD_CLOCK}`.
This works for microprocessor board definitions like ATtiny that specify not only the clock speed but fuse settings as clock overrides.

It also works for f_cpu values specified in `boards.txt` as `{BOARD_TAG}.menu.speed.{BOARD_CLOCK}`.
For example, the Watterott ATmega328PB library [https://github.com/watterott/ATmega328PB-Testing](https://github.com/watterott/ATmega328PB-Testing).

**Example:**

```Makefile
# Select external 16 MHz clock
BOARD_CLOCK=external16
```

**Example:**
```Makefile
# Select 20MHz speed
BOARD_CLOCK=20mhz
```

**Requirement:** *Optional to override main board f_cpu and/or fuse settings.*

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
USER_LIB_PATH = $(HOME)/sketchbook/libraries
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
ARDUINO_VAR_PATH = $(HOME)/sketchbook/hardware/arduino-tiny/cores/tiny
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

### BOARD

**Description:**

Board identifier that passes to a compile option as -DARDUINO_$(BOARD).

Usually can be auto-detected as `build.board` from `boards.txt`.

If not found build.board entry, use upper-case converted "$(ARCHITECTURE)_$(BOARD_TAG)".

**Example:**

```Makefile
BOARD = AVR_LEONARD
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

Device path to ArduinoISP. Not needed for hardware ISP's. Also used to define
bootloader port on SAMD devices.

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

## Compiler/Executable variables

### TOOL_PREFIX

**Description:**

The tool prefix, which gets prepended to the tools like $(TOOL_PREFIX)-gcc, $(TOOL_PREFIX)-g++, etc.
The following tools will be prefixed with '$(TOOL_PREFIX)-':

   * gcc
   * g++
   * as
   * objcopy
   * objdump
   * ar
   * size
   * nm

Defaults to `avr`

**Example:**

```Makefile
TOOL_PREFIX = arm-none-eabi
TOOL_PREFIX = pic32
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

Defaults to `avr-ar` unless you're using toolchain > 4.9.0 in which case we use avr-gcc-ar.

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

### GDB_NAME

**Description:**

GDB utility.

Defaults to `arm-none-eabi-gdb`

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

### OTHER_LIBS

**Description:**

Additional Linker lib flags, for platform support

Defaults to ""

**Example:**

```Makefile
OTHER_LIBS = -lsomeplatformlib
```

**Requirement:** *Optional*

----

### CFLAGS_STD

**Description:**

Controls, *exclusively*, which C standard is to be used for compilation.

Defaults to `undefined` on 1.0.x or `-std=gnu11` on 1.5+ or if you install AVR toolchain > 4.9.0

Possible values:

*	With `avr-gcc 4.3`, shipped with the 1.0 Arduino IDE:
	*	`undefined`
	*	`-std=c99`
	*	`-std=gnu89` - This is the default for C code
	*	`-std=gnu99`
*	With `avr-gcc 4.7, 4.8 or 4.9`, installed by you or 1.5+ IDE:
	*	`undefined`
	*	`-std=c99`
	*	`-std=c11`
	*	`-std=gnu89`
	*	`-std=gnu99`
	*	`-std=gnu11` - This is the default for C code

For more information, please refer to the [Options Controlling C Dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html)

**Example:**

```Makefile
CFLAGS_STD = -std=gnu89
```

**Requirement:** *Optional*

----

### CXXFLAGS_STD

**Description:**

Controls, *exclusively*, which C++ standard is to be used for compilation.

Defaults to `undefined` on 1.0 or `-std=gnu++11` on AVR toolchain > 4.9.0 (e.g. IDE 1.6.10+)

Possible values:

*	With `avr-gcc 4.3`, shipped with the 1.0 Arduino IDE:
	*	`undefined`
	*	`-std=c++98`
	*	`-std=c++0x`
	*	`-std=gnu++98` - This is the default for C code
	*	`-std=gnu++0x`
*	With `avr-gcc 4.7, 4.8 or 4.9`, installed by you or 1.5+ IDE:
	*	`undefined`
	*	`-std=c++98`
	*	`-std=c++11`
	*	`-std=c++1y`
	*	`-std=c++14`
	*	`-std=gnu++98`
	*	`-std=gnu++11` - This is the default for C++ code
	*	`-std=gnu++1y`
	*	`-std=gnu++14`

For more information, please refer to the [Options Controlling C Dialect](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html)

**Example:**

```Makefile
CXXFLAGS_STD = -std=gnu++98
```

**Requirement:** *Optional*

----

### CFLAGS

**Description:**

Flags passed to compiler for files compiled as C. Add more flags to this
variable using `+=`.

Defaults to `undefined` on 1.0 or `-flto -fno-fat-lto-objects -fdiagnostics-color=$(DIAGNOSTICS_COLOR_WHEN)` on AVR toolchain > 4.9.0 (e.g. IDE 1.6.10+)

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

Defaults to `-fpermissive -fno-exceptions` on 1.0
or `-fpermissive -fno-exceptions -fno-threadsafe-statics -flto -fno-devirtualize -fdiagnostics-color`
on AVR toolchain > 4.9.0 (e.g. IDE 1.6.10+)

**Example:**

```Makefile
CXXFLAGS += -my-c++-onlyflag
```

**Requirement:** *Optional*

----

### DIAGNOSTICS_COLOR_WHEN

**Description:**

This variable controls the compiler's diagnostics-color setting, as defined
in CFLAGS or CXXFLAGS, on AVR toolchain > 4.9.0.
Supported values are: `always`, `never` and `auto`.
For more details, see: [Options to Control Diagnostic Messages Formatting]
(https://gcc.gnu.org/onlinedocs/gcc-4.9.2/gcc/Language-Independent-Options.html#Language-Independent-Options)

Defaults to `always`.

**Example:**

```Makefile
DIAGNOSTICS_COLOR_WHEN = never
# or
DIAGNOSTICS_COLOR_WHEN = auto
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

Flags passed to the C pre-processor (for C, C++ and assembly source files). Add
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

Override the default build tool paths and names.

If OVERRIDE_EXECUTABLES is defined, all tools (`CC`, `CXX`, `AS`,
`OBJCOPY`, `OBJDUMP`, `AR`, `SIZE`, `NM`) must have their paths
explicitly defined. This may be used in the rare case where
overriding a path and/or executable name is required.
The "?=" assignment cannot be used because the executable tags
are already implicitly defined by Make (e.g. $(CC) == cc).

**Example:**

```Makefile
OVERRIDE_EXECUTABLES = 1
CC      = /usr/bin/avr-gcc
CXX     = /usr/bin/avr-g++
AS      = /usr/bin/avr-as
OBJCOPY = /usr/bin/avr-objcopy
OBJDUMP = /usr/bin/avr-objdump
AR      = /usr/bin/avr-ar
SIZE    = /some_path/alternative_avr-size
NM      = /some_path/alternative_avr-nm
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

### MONITOR_PARAMS

**Description:**

Additional parameters for the putty -sercfg command line argument.

Interpreted as a comma-separated list of configuration options.

**Example:**

```Makefile
MONITOR_PARAMS = 8,1,n,N
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
PRE_BUILD_HOOK = $(HOME)/bin/bump-revision.sh
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

### AVRDUDE_AUTOERASE_FLASH

**Description:**

Enable autoerase flash.

By default disabled.

**Example:**

```Makefile
AVRDUDE_AUTOERASE_FLASH = yes
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
ALTERNATE_CORE_PATH = $(HOME)/sketchbook/hardware/arduino-tiny/cores/tiny
```

**Requirement:** *Optional*

----

### CORE_VER

**Description:**

Alternate core release version. The Arduino board support packages are within
a sub-directory indicated by this define.

Defaults to package current release.

**Example:**

```Makefile
CORE_VER = 1.6.17
```

**Requirement:** *Optional*

----

### CMSIS_DIR

**Description:**

Path to ARM CMSIS. Normally installed as part of ARM  board support.

Defaults to `ARDUINO_PACKAGE_DIR/tools/CMSIS/4.5.0/CMSIS`

**Example:**

```Makefile
CMSIS_DIR = /usr/share/CMSIS
```

**Requirement:** *Optional*

----

### CMSIS_ATMEL_DIR

**Description:**

Path to CMSIS-Atmel directory. Installed with ARM support package.

Defaults to `ARDUINO_PACKAGE_DIR/tools/CMSIS-Atmel/1.1.0/CMSIS`

**Requirement:** *Optional*
----

### BOARDS_TXT

**Description:**

Path to `boards.txt`

Defaults to `ARDUINO_DIR/hardware/arduino/boards.txt`

**Example:**

```Makefile
BOARD_TXT = $(HOME)/sketchbook/hardware/boards.txt
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
BOOTLOADER_PARENT = $(HOME)/sketchbook/hardware/promicro/bootloaders
BOOTLOADER_PATH  = caterina
BOOTLOADER_FILE  = Caterina-promicro16.hex
```

Would result in an absolute path to the bootloader hex file of `$(HOME)/sketchbook/hardware/promicro/bootloaders/caterina/Caterina-promicro16.hex`

**Requirement:** *Optional, unless BOOTLOADER_FILE and/or BOOTLOADER_PATH are user-defined*

----

### BOOTLOADER_SIZE

**Description:**

Size of bootloader on ARM devices, ensures correct start address when flashing
application area. Normally parsed from boards.txt

Defaults to `0x2000`

**Requirement:** *Optional*

----

### BOOTLOADER_UNPROTECT

**Description:**

Bootloader unprotect sequence for upload tool. Normally parsed from boards.txt

Defaults to `at91samd bootloader 0`

**Requirement:** *Optional*

----

### BOOTLOADER_PROTECT

**Description:**

Bootloader protect sequence for upload tool. Normally parsed from boards.txt

Defaults to `at91samd bootloader 16384`

**Requirement:** *Optional*

----

### BOOTLOADER_PROTECT_VERIFY

**Description:**

Bootloader protect and verify  sequence for upload tool. Normally parsed from boards.txt

Defaults to `at91samd bootloader`

**Requirement:** *Optional*

----

### BOOTLOADER_UPLOAD_TOOL

**Description:**

Bootloader upload binary to use. Normally parsed from boards.txt.

Defaults to `openocd`

**Requirement:** *Optional*

----

## ChipKIT variables

### MPIDE_DIR

**Description:**

Path to chipKIT MP IDE

Usually can be auto-detected as `AUTO_MPIDE_DIR` from the defaults `/usr/share/mpide` (Linux) or `/Applications/Mpide.app/Contents/Resources/Java` (OSX)

**Example:**

```Makefile
MPIDE_DIR = $(HOME)/mpide
```

**Requirement:** *Optional*

----

### MPIDE_PREFERENCES_PATH

**Description:**

Path to chipKIT `preferences.txt` file.

Usually can be auto-detected as `AUTO_MPIDE_PREFERENCES_PATH` from the defaults `$(HOME)/.mpide/preferences.txt` (Linux) or `$(HOME)/Library/Mpide/preferences.txt` (OSX)

**Example:**

```Makefile
MPIDE_PREFERENCES_PATH = $(HOME)/chipkit/preferences.txt
```

**Requirement:** *Optional*

----

## ARM variables

### UPLOAD_TOOL

**Description:**

Tool to upload binary to device. Normally parsed from boards.txt.

Defaults to `openocd`

**Example:**

```Makefile
UPLOAD_TOOL = gdb
```

**Requirement:** *Optional*

----

### DEBUG

**Description:**

Define to set `DEBUG_FLAGS` and allow stepping of code using GDB.

Defaults to undefined.

**Example:**

```Makefile
DEBUG = 1
```

**Requirement:** *Optional*

----

### GDB_PORT

**Description:**

Server port to use for GDB debugging or upload. Default assumes server running
on localhost but can re-define to use Black Magic Probe serial port.

Defaults to `localhost:3333`

**Example:**

```Makefile
GDB_PORT = /dev/ttyACM0
```

**Requirement:** *Optional*

----

### GDB_OPTS

**Description:**

Optional arguments to parse to GDB command.

Defaults to `-ex "target extended-remote $(GDB_PORT)" -ex "monitor swdp_scan" -ex "attach 1" -ex "load" -d $(OBJDIR) $(TARGET_ELF)`

**Requirement:** *Optional*

----

### GDB_UPLOAD_OPTS

**Description:**

Optional arguments to parse to GDB command when uploading binary only.

Defaults to `GDB_UPLOAD_OPTS = $(GDB_OPTS) -ex "set confirm off" -ex "set target-async off" -ex "set remotetimeout 30" -ex "detach" -ex "kill" -ex "quit"`

**Requirement:** *Optional*

----

### BOSSA

**Description:**

Path to bossac binary.

Can usually be detected from `$ARDUINO_PACKAGE_DIR` /tools subdirectory when ARM
device support is installed.

**Requirement:** *Optional*

----

### BOSSA_VER

**Description:**

`bossa` sub-directory - usually the tool version. Will auto-detect to highest version found.

**Requirement:** *Optional*

----

### BOSSA_OPTS

**Description:**

Flags to pass to bossac command.

Defaults to `-d --info --erase --write --verify --reset`

**Requirement:** *Optional*

----

### OPENOCD

**Description:**

Path to openocd binary.

Can usually be detected from `$ARDUINO_PACKAGE_DIR` /tools subdirectory when ARM
device support is installed.

**Requirement:** *Optional*

----

### OPENOCD_VER

**Description:**

`openocd` sub-directory - usually the tool version. Will auto-detect to highest version found.

**Requirement:** *Optional*

----

### OPENOCD_OPTS

**Description:**

Flags to pass to openocd command. If using openocd from non-Arduino
distributions, one should define this with the path to the Arduino openocd script.

Defaults to `-d2`

Example:

```Makefile
OPENOCD_OPTS = $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/tools/openocd/0.9.0-arduino6-static/share/openocd/scripts/ -f $(ARDUINO_PACKAGE_DIR)/$(ARDMK_VENDOR)/hardware/samd/1.6.17/variants/$(VARIANT)/$(OPENOCD_SCRIPT) 
```

**Requirement:** *Optional*


----

## Ctags variables

### TAGS_FILE

**Description:**

Output file name for tags. Defaults to 'tags'.

**Example:**

```Makefile
TAGS_FILE = .tags
```

**Requirement:** *Optional*

----

### CTAGS_OPTS

**Description:**

Additional options to pass to `ctags` command.

**Example:**

```Makefile
# Run ctags in verbose mode
CTAGS_OPTS = -V
```

**Requirement:** *Optional*

----

### CTAGS_EXEC

**Description:**

Path to the `ctags` binary. Defaults to user path.

**Example:**

```Makefile
CTAGS_EXEC = /usr/local/bin/ctags
```

**Requirement:** *Optional*
