# Documentation of variables 

The following are the different variables that can be overwritten in the user makefiles.

- [Global variables](#global-variables)
- [Installation/Directory variables](#installationdirectory-variables)
- [Arduino IDE variables](#arduino-ide-variables)
- [Sketch related variables](#sketch-related-variables)
- [ISP programming variables](#isp-programming-variables)
- [Compiler/Executable variables](#compilerexecutable-variables)
- [Avrdude setting variables](#avrdude-setting-variables)
- [Bootloader variables](#bootloader-variables)
- [ChipKIT variables](#chipkit-variables)

## Global variables

### ARDUINO_QUIET
Suppress printing of Arduino-Makefile configuration.

Defaults to unset/disabled.

*Example*: 1

Optional.

## Installation/Directory variables

### ARDMK_DIR
Directory where the `*.mk` files are stored.

Usually can be auto-detected as `AUTO_ARDUINO_DIR` (parent of Arduino.mk).

*Example*: /usr/share/arduino

Optional.

### AVR_TOOLS_DIR
Directory where tools such as avrdude, avr-g++, avr-gcc etc. are stored in the bin/ subdirectory.

Usually can be auto-detected from `$PATH` as `SYSTEMPATH_AVR_TOOLS_DIR` or as `BUNDLED_AVR_TOOLS_DIR` within the Arduino distribution.

*Example*: /usr or /usr/share/arduino/hardware/tools/avr

Optional.

### RESET_CMD
Command to reset the MCU.

Defaults to ard-reset-arduino with the extra --caterina flag for atmega32u4 boards.

*Example*: ~/gertduino/reset

Optional.

## Arduino IDE variables

### ARDUINO_DIR
Directory where the Arduino IDE and/or core files are stored.

*Example*: /usr/share/arduino (Linux) or /Applications/Arduino.app/Contents/Resources/Java (OSX)

Optional.

### ARDUINO_VERSION
Version string for Arduino IDE and/or core.

Usually can be auto-detected as `AUTO_ARDUINO_VERSION` from /usr/share/arduino/lib/version.txt

*Example*: 105

Optional.

### ARDUINO_SKETCHBOOK
Path to sketchbook directory.

Usually can be auto-detected from the Arduino preferences.txt file or the default ~/sketchbook

*Example*: ~/sketches

Optional.

### ARDUINO_PREFERENCES_PATH
Path to Arduino preferences.txt file.

Usually can be auto-detected as `AUTO_ARDUINO_PREFERENCES` from the defaults ~/.arduino/preferences.txt (Linux) or ~/Library/Arduino/preferences.txt (OSX)

*Example*: ~/sketches/preferences.txt

Optional.

### ARDUINO_CORE_PATH
Path to standard Arduino core files.

*Example*: /usr/share/arduino/hardware/arduino/cores/arduino

Optional.

## Sketch related variables

### ARDUINO_LIBS
Any libraries you intend to include.

Usually can be auto-detected from the sketch. Separated by spaces. If the library has a /utility folder (like SD or Wire library), then the utility folder should also be specified.

*Example*: SD SD/utility Wire Wire/utility

Optional.

### BOARD_TAG
Device type as listed in boards.txt or `make show_boards`.

*Example*: uno or mega2560

Mandatory.

### MONITOR_PORT
Path to serial (USB) device used for uploading/serial comms.

*Example*: /dev/ttyUSB0 or /dev/ttyACM0 (Linux) or /dev/cu.usb* (OSX) or com3 (Windows)

Mandatory.

### USER_LIB_PATH
Directory where additional libraries are stored.

Defaults to 'libraries' directory within user's sketchbook.

*Example*: ~/sketchbook/libraries (Linux)

Optional.

### ALTERNATE_CORE
Non-standard core for Arduino-unsupported chips like the ATtiny.

*Example*: attiny-master or arduino-tiny or tiny2

Optional.

### ARDUINO_VAR_PATH
Path to non-standard core's variant files.

*Example*: ~/sketchbook/hardware/arduino-tiny/cores/tiny

Optional.

### VARIANT
Variant of a standard board design.

Usually can be auto-detected as build.variant from boards.txt

*Example*: leonardo

Optional.

### USB_VID
Override USB VID for atmega32u4 boards.

Usually can be auto-detected as build.vid from boards.txt

*Example*: 0x2341

Optional.

### USB_PID
Override USB PID for atmega32u4 boards.

Usually can be auto-detected as build.pid from boards.txt

*Example*: 0x8039

Optional.

### F_CPU
CPU speed in Hz

Usually can be auto-detected as build.f_cpu from boards.txt

*Example*: 8000000L

Optional.

### HEX_MAXIMUM_SIZE
Maximum hex file size

Usually can be auto-detected as upload.maximum_size from boards.txt

*Example*: 14336

Optional.

### MCU
Microcontroller model.

Usually can be auto-detected as build.mcu from boards.txt

*Example*: atmega32u4

Optional.

### MCU_FLAG_NAME
Override default MCU flags.

Defaults to mmcu

*Example*: mprocessor

Optional.

### MONITOR_BAUDRATE
Baudrate of the serial monitor.

Defaults to 9600 if it can't find it in the sketch Serial.begin()

*Example*: 57600

Optional.

## ISP programming variables

### ISP_PROG
Type of ISP. Either a USB device or ArduinoISP protocol.

*Example*: usbasp or usbtiny or stk500v2 or stk500v1

Optional.

### ISP_PORT
Device path to ArduinoISP. Not needed for hardware ISP's.

*Example*: /dev/ttyACM0 (Linux)

Optional.

### ISP_LOCK_FUSE_PRE
Bootloader unlock bits.

Usually can be auto-detected from boards.txt

*Example*: 0x3f

Optional.

### ISP_LOCK_FUSE_POST
Bootloader lock bits.

Usually can be auto-detected from boards.txt

*Example*: 0xcf

Optional.

### ISP_HIGH_FUSE
SP_LOW_FUSE/ISP_EXT_FUSE - high/low/extended fuse bits.

Usually can be auto-detected from boards.txt

*Example*: 0xdf or 0xff or 0x01

Optional.

### ISP_EEPROM
Whether to upload the EEPROM file or not.

Defaults to 0

*Example*: 1

Optional.

## Compiler/Executable variables

### CC_NAME
C compiler.

Defaults to avr-gcc

*Example*: pic32-gcc

Optional.

### CXX_NAME
C++ compiler.

Defaults to avr-g++

*Example*: pic32-g++

Optional.

### OBJCOPY_NAME
Objcopy utility.

Defaults to avr-objcopy

*Example*: pic32-objcopy

Optional.

### OBJDUMP_NAME
Objdump utility.

Defaults to avr-objdump

*Example*: pic32-objdump

Optional.

### AR_NAME
Archive utility.

Defaults to avr-ar

*Example*: pic32-ar

Optional.

### SIZE_NAME
Size utility.

Defaults to avr-size

*Example*: pic32-size

Optional.

### NM_NAME
Nm utility.

Defaults to avr-nm

*Example*: pic32-nm

Optional.

### OPTIMIZATION_LEVEL
Linker's -O flag

Defaults to s, which shouldn't really be changed as it breaks SoftwareSerial and usually results in bigger hex files.

*Example*: 3

Optional.

### CFLAGS_STD
Flags to pass to the C compiler.

Defaults to -std=gnu99

*Example*: <unset as per chipKIT.mk>

Optional.

### OVERRIDE_EXECUTABLES
Override the default build tools.

If set to 1 each tool (CC, CXX, AS, OBJCOPY, OBJDUMP, AR, SIZE, NM) must have its path explicitly defined. See chipKIT.mk

*Example*: 1

Optional.

### MONITOR_CMD
Command to run the serial monitor.

Defaults to screen

*Example*: minicom

Optional.

## Avrdude setting variables

### AVRDUDE
Path to avrdude utility

Usually can be auto-detected within the parent of `AVR_TOOLS_DIR` or in the $PATH

*Example*: /usr/bin/avrdude

Optional.

### AVRDUDE_CONF
Path to avrdude.conf file

Usually can be auto-detected within the parent of `AVR_TOOLS_DIR` 

*Example*: /etc/avrdude.conf or /usr/share/arduino/hardware/tools/avrdude.conf

Optional.

### AVR_TOOLS_PATH
Directory where tools such as avrdude, avr-g++, avr-gcc etc. are stored.

Usually can be auto-detected from AVR_TOOLS_DIR/bin

*Example*: /usr/bin or /usr/share/arduino/hardware/tools/avr/bin

Optional.

### ARDUINO_LIB_PATH
Directory where the standard Arduino libraries are stored.

Defaults to ARDUINO_DIR/libraries

*Example*: /usr/share/arduino/libraries (Linux)

Optional.

### ARDUINO_CORE_PATH
Directory where the standard Arduino cores are stored.

Defaults to ARDUINO_DIR/hardware/arduino/cores/arduino

*Example*: /usr/share/arduino/hardware/arduino/cores/robot

Optional.

### ALTERNATE_CORE_PATH
Path to non-standard cores.

Defaults to ARDUINO_SKETCHBOOK/hardware/ALTERNATE_CORE

*Example*: ~/sketchbook/hardware/arduino-tiny/cores/tiny

Optional.

### BOARDS_TXT
Path to boards.txt

Defaults to ARDUINO_DIR/hardware/arduino/boards.txt

*Example*: ~/sketchbook/hardware/boards.txt or /usr/share/arduino/hardware/arduino/boards.txt (Linux)

Optional.

### AVRDUDE_ARD_BAUDRATE
Upload speed

Usually can be auto-detected as upload.speed from boards.txt

*Example*: 19200

Optional.

### AVRDUDE_ARD_PROGRAMMER
Upload protocol

Usually can be auto-detected as upload.protocol from boards.txt

*Example*: stk500v1

Optional.

### AVRDUDE_ISP_BAUDRATE
ISP speed if different to upload.speed

Defaults to same as `AVRDUDE_ARD_BAUDRATE` or 19200

*Example*: 19200

Optional.

### AVRDUDE_OPTS
Options to pass to avrdude.

Defaults to '-q -V -D' (quiet, don't verify, don't auto-erase). User values are not ANDed to the defaults, you have to set each option you require.

*Example*: -v

Optional.

## Bootloader variables

### BOOTLOADER_FILE
File for bootloader.

Usually can be auto-detected as bootloader.file from boards.txt

*Example*: optiboot_atmega328.hex

Optional.

### BOOTLOADER_PATH
Path to bootloader file.

Usually can be auto-detected as a relative bootloader.path from boards.txt

*Example*: optiboot or arduino:atmega or /usr/share/arduino/hardware/arduino/bootloaders/caterina/Caterina-Esplora.hex

Optional.

## ChipKIT variables

### MPIDE_DIR
Path to chipKIT MP IDE

Usually can be auto-detected as `AUTO_MPIDE_DIR` from the defaults /usr/share/mpide (Linux) or /Applications/Mpide.app/Contents/Resources/Java (OSX)

*Example*: ~/mpide

Optional.

### MPIDE_PREFERENCES_PATH
Path to chipKIT preferences.txt file.

Usually can be auto-detected as `AUTO_MPIDE_PREFERENCES_PATH` from the defaults ~/.mpide/preferences.txt (Linux) or ~/Library/Mpide/preferences.txt (OSX)

*Example*: ~/chipkit/preferences.txt

Optional.
