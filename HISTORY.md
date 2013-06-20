A Makefile for Arduino Sketches
===============================

The following is the rough list of changes that went into different versions. I tried to give credit whenever possible. If I have missed anyone, kindly add it to the list.

### 0.12.0 (2013-06-20)
- Fix "generated_assembly" target, which got broken earlier. Fix issue #76 (https://github.com/matthijskooijman)
- Deprecate "generated_assembly" target in favour of "generate_assembly". Fix issue #79

### 0.11.0 (2013-06-15)
- Replace hardcoded executables with variable
- Fix whitespace issues
- Add a warning when HEX_MAXIMUM_SIZE is not specified
- Add the ability to configure avrdude options. Fix issue #53
- Handle cases where certain fuse bits are not present. Fix issue #61
- Add support for compiling plain AVR C files. Fix issue #63
- Add an example to show how to compile AVR C files. Fix issue #73

### 0.10.6 (2013-06-14)
- Fix whitespace and add /dev/null redirection (https://github.com/sej7278)
- Change the way AUTO_ARDUINO_VERSION is computed (https://github.com/sej7278)
- Make serial monitor baudrate detection work in Mac as well(https://github.com/sej7278)
- Fix directory creation for library source files (https://github.com/matthijskooijman)
- Rewrite ard-leonardo-reset script in perl (https://github.com/sej7278)

### 0.10.5 (2013-06-11)
- Add USB_VID and USB_PID to CPPFLAGS only if the board is Leonardo.
- Allow adding extra common dependencies (COMMON_DEPS) (https://github.com/gaftech)
- Added ifndef ARDUINO_VAR_PATH for compiling for the attiny (https://github.com/danielesteban)
- Strip extra whitespace from the `BOARD_TAG` variable
- Enhanced support for programming using Arduino as ISP
- Added example to show how to program using Arduino as ISP
- Add support for Leonardo boards. Took code from (https://github.com/guicho271828)

### 0.10.4 (2013-05-31) @matthijskooijman
- Improved BAUD_RATE detection logic
- Added logic to check if there is only .ino or .pde file
- Compile .ino/.pde files directly
- Output configuration only once
- Try to read Version.txt file only if it is present
- Refactored dependency code

###	0.10.3 16.xii 2012 gaftech
- Enabling creation of EEPROM file (.eep)
- EEPROM upload: eeprom and raw_eeprom targets
- Auto EEPROM upload with isp mode: ISP_EEPROM option.
- Allow custom OBJDIR

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
- Added installation notes for Fedora (ex Rickard Lindberg).
- Changed size target so that it looks at the ELF object, 
    not the hexfile (ex Jared Szechy and Scott Howard).
- Fixed ARDUNIO typo in README.md (ex Kalin Kozhuharov).
- Tweaked OBJDIR handling (ex Matthias Urlichs and Scott Howard).
- Changed the name of the Debian/Ubuntu package (ex
    Scott Howard).
- Only set AVRDUDE_CONF if it's not set (ex Tom Hall).
- Added support for USB_PID/VID used by the Leonardo (ex Dan
    Villiom Podlaski Christiansen and Marc Plano-Lesay).

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

Note: Many other people sent me similar patches, but I didn't get around to using them. In the end, I took the patch from Debian and Ubuntu: there seems merit in not forking the code and using a tested version. So, thanks and apologies to Nick Andrew, Leandro Coletto Biazon, Thibaud Chupin, Craig Hollabaugh, Johannes H. Jensen, Fabien Le Lez, Craig Leres, and Mark Sproul.

### 2010-05-24, version 0.4
Tweaked rules for the reset target on Philip Hands’ advice.

### 2010-05-21, version 0.3
- Tidied up the licensing, making it clear that it’s released under LGPL 2.1.
- [Philip Hands](http://hands.com/~phil/) sent me some code to reset the Arduino by dropping DTR for 100ms, and I added it.
- Tweaked the Makefile to handle version 0018 of the Arduino software which now includes main.cpp. Accordingly we don’t need to—and indeed must not—add main.cxx to the .pde sketch file. The paths seem to have changed a bit too.

