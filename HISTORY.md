A Makefile for Arduino Sketches
===============================

The following is the rough list of changes that went into different versions.
I tried to give credit whenever possible. If I have missed anyone, kindly add it to the list.

### In Development
- Fix: Add -fno-devirtualize flag to workaround g++ segfault bug (issue #486). (https://github.com/sej7278)
- Fix: Quote the prefix tag in the space_pad_to function
- Tweak: Set ARDMK_VERSION to 1.6 (https://github.com/sej7278)
- New: Added -fdiagnostics-color to *STD flags (https://github.com/sej7278)

### 1.6.0 (2017-07-11)
- Fix: Allowed for SparkFun's weird usb pid/vid submenu shenanigans (issue #499). (https://github.com/sej7278)
- Fix: Do not include the Arduino header when calling generate_assembly on .cpp files. (https://github.com/Batchyx)
- Fix: Auto-detect F_CPU on Teensy from boards.txt (https://github.com/DaWelter)
- Fix: params typo in PuTTY section (issue #487) (https://github.com/ericdand)
- Fix: Fixed sed expression to properly format show_submenu (issue #488) (https://github.com/cbosdo)
- Tweak: Removed tilde from documentation (issue #497). (https://github.com/sej7278)
- New: Add support for good old cu as monitor command (issue #492) (https://github.com/mwm)
- New: Add a documentation how to setup Makefile for 3rd party boards (issue #499). (https://github.com/MilanV)
- New: Add support for Robotis OpenCM boards

### 1.5.2 (2017-01-11)

- New: Add LTO support for users with avr-gcc > 4.9 (issue #446 & #456) (https://github.com/sej7278)
- Tweak: Updated Linux instructions and sync documentation from the old blog(), README.md and Arduino.mk (https://github.com/az-z)
- Tweak: Documentation for Windows updated to include installation of PySerial (https://github.com/sovcik) 
- Fix: Updated CXXFLAGS_STD to match upstream 1.6 (issue #424) (https://github.com/calvinli)
- Fix: Added support for attiny core's use of chip instead of cpu in submenus (https://github.com/straccio)
- Fix: ARDUINO_VERSION can cope with the longer 1.6.10 version string (issue #444) (https://github.com/sej7278)
- Fix: Changed PARSE_BOARD to handle colons in e.g. CORE or VARIANT (issue #461) (https://github.com/sej7278)
- Fix: Changed Teensy.mk to support Arduino 1.6.12 and Teensyduino 1.30 (issues #383 , #431) (https://github.com/georgeharker)

### 1.5.1 (Debian version: 1.5-3) (2016-02-22)

- New: Add show_submenu target (https://github.com/drewhutchison)
- New: Add AVR Dragon to list of ISP's without a port (https://github.com/mtnocean)
- New: Add more board examples to Blink demo (https://github.com/sej7278)
- New: Add option to split avrdude MCU from avr-gcc MCU (Issue #357) (https://github.com/hhgarnes)
- New: Add support for /dev/tty.wchusbserial* (comes with cheap clones - DCCduino) (https://github.com/biesiad)
- New: Add support for picocom as serial monitor (https://github.com/biesiad)
- Tweak: Add support for Adafruit trinket3/trinket5/protrinket3/protrinket5 by improved BOARDS_TXT parsing (Issue #393) (https://github/com/zabereer)
- Tweak: Looks for submenu items first when parsing BOARDS_TXT (Issue #347) (https://github.com/sej7278)
- Tweak: Various spelling/grammar/typo fixes (https://github.com/dcousens)
- Tweak: Clarified some 1.5+ issues in docs (Issue #352) (https://github.com/sej7278)
- Tweak: Added some more Continuous Integration tests (https://github.com/sej7278)
- Tweak: Updated Fedora instructions (https://github.com/sej7278)
- Fix: Preserve original extension for object files, support asm sources in core, fixes pulseInASM (Issue #255, #364) (https://github.com/sej7278)
- Fix: Make sure TARGET is set correctly when CURDIR contains spaces (https://github.com/svendahlstrand)
- Fix: Ensure AVRDUDE_CONF is set when AVR_TOOLS_DIR is, not just on Windows (Issue #381) (https://github.com/sej7278)
- Fix: Rename VENDOR to ARDMK_VENDOR to workaround tcsh issue (Issue #386) (https://github.com/sej7278)
- Fix: Document OSX 1.0/1.6 ARDUINO_DIR differences (https://github.com/thomaskilian)
- Fix: Fix regex to support BOARD_TAGs with hyphens e.g. attiny44-20 (https://github.com/sej7278)
- Fix: Remove check for BOOTLOADER_PATH, just check for BOOTLOADER_FILE (Issue #402) (https://github.com/sej7278)
- Fix: Port ard-reset-arduino to pyserial 3.0 (#407, #408) (https://github.com/gauteh)

### 1.5 (2015-04-07)
- New: Add support for new 1.5.x library layout (Issue #275) (https://github.com/lukasz-e)
- New: Add support for 1.5.x vendor/hardware architecture library location (Issue #276) (https://github.com/lukasz-e)
- New: Added test suite and integration with travis CI. (https://github.com/peplin)
- New: Add information about `Bare-Arduino–Project` in README. (https://github.com/ladislas)
- New: Add information about reporting bugs to the correct project (Issue #231). (https://github.com/sej7278)
- New: Add documentation about CFLAGS_STD and CXXFLAGS_STD (Issue #234) (https://github.com/ladislas)
- New: Allow "make clean" target to be extended (Issue #239). (https://github.com/sej7278)
- New: Add makefile and gcc version info to config output. (https://github.com/sej7278)
- New: Support for Teensy 3.x (https://github.com/stepcut)
- New: Support for PuTTY under Windows (https://github.com/PeterMosmans)
- New: Add support for installation using homebrew(https://github.com/ladislas)
- New: Add support and example for flashing on a remote RPi. (https://github.com/Gaboose)
- Tweak: Update Makefile-example.mk with STD flags (https://github.com/ladislas)
- Tweak: Allow remove of any OBJDIR with `$(REMOVE) $(OBJDIR)`. (https://github.com/ladislas)
- Tweak: Add cpp to extensions supported by "make generate_assembly". (https://github.com/sej7278)
- Tweak: Update travis-ci to test against Arduino 1.0.6. (https://github.com/sej7278)
- Tweak: Updated package instructions for Arch/Fedora/Raspbian. (https://github.com/sej7278)
- Tweak: Remove $(EXTRA_XXX) variables (Issue #234) (https://github.com/ladislas)
- Tweak: Moved location of avrdude for 1.5.8 on Linux (Issue #301) (https://github.com/sej7278)
- Tweak: Allow 'build.core' param as found in [arduino-tiny](https://code.google.com/p/arduino-tiny/) Prospective Boards.txt. (https://github.com/Gaboose)
- Tweak: Replace CXX_NAME with CXX as per the Emacs Flymake Wiki (Issue #309) (https://github.com/sej7278)
- Tweak: Ability to override `USB_TYPE` in Teensy.md (Issue #313) (https://github.com/Poofjunior)
- Tweak: Integration instructions for CodeBlocks IDE (Issue #321) (https://github.com/fbielejec)
- Tweak: Add BOARD_SUB to OBJDIR if defined in 1.5+ (https://github.com/sej7278)
- Tweak: Add = to PARSE_BOARD regex to make it less greedy and not match vid.0, vid.1 and vid (https://github.com/sej7278)
- Tweak: Added note about clock submenu's being used as F_CPU (https://github.com/sej7278)
- Tweak: Better autodetection of ARDUINO_SKETCHBOOK and ARDUINO_DIR on OSX (https://github.com/sej7278)
- Fix: Improved Windows (Cygwin/MSYS) support (https://github.com/PeterMosmans)
- Fix: Change "tinyladi" username to "ladislas" in HISTORY.md. (https://github.com/ladislas)
- Fix: Make avr-g++ use CXXFLAGS instead of CFLAGS. (https://github.com/sej7278)
- Fix: Allow the use of CFLAGS_STD and CXXFLAGS_STD and set defaults (Issue #234) (https://github.com/ladislas)
- Fix: Update "make show_boards" regex to work with the Due in 1.5. (https://github.com/sej7278)
- Fix: Allow user libaries/sketches to have the same name as system libs. (Issue #244, #229). (https://github.com/sej7278)
- Fix: Remove impact of travis-ci from regular users. (Issue #258). (https://github.com/sej7278)
- Fix: objcopy quoting issue on Windows. (Issue #272). (https://github.com/sej7278)
- Fix: Add "avrispmkii" to the list of isp that don't have a port. (Issue #279). (https://github.com/sej7278)
- Fix: Make CXX compile .cpp files instead of CC. (Issue #285). (https://github.com/sej7278)
- Fix: Changed IDE download URL *again* for Travis-CI. (https://github.com/sej7278)
- Fix: Allow avrdude to erase the chip before programming during ispload (https://github.com/tchebb)
- Fix: Fix speed regression. Thanks ladislas (Issue #280) (https://github.com/sej7278)
- Fix: Removed some double quotes that were breaking variable expansion. (https://github.com/sej7278)
- Fix: Fixed PLATFORM_LIB support for 1.5+ and removed duplicate libs (https://github.com/sej7278)
- Fix: Added ARCHITECTURE to ALTERNATE_CORE_PATH to support 1.5+ cores like arduino-tiny (https://github.com/sej7278)
- Fix: Can now find IDE 1.5+ preferences.txt on Linux and Mac (https://github.com/sej7278)
- Fix: Added support for VARIANT being a submenu item in 1.6 cores like attiny (https://github.com/sej7278)
- Fix: Replaced copyright symbol causing sed problems on OSX (Issue #335). (https://github.com/sej7278)
- Fix: Fix issues with resetting Leonardo and Micro boards(Issue #340) (https://github.com/calvinli)

### 1.3.4 (2014-07-12)
- Tweak: Allow spaces in "Serial.begin (....)". (Issue #190) (https://github.com/pdav)
- Add: Add support for compiling assembler code. (Issue #195) (https://github.com/hrobeers)
- Add: Try to guess port from wildcards if not specified. (Issue #197) (https://github.com/tuzz)
- Fix: Check that on windows ARDUINO_DIR (and MPIDE_DIR) is a relative path. (Issue #201 and #202) (https://github.com/sej7278)
- Add: List board name as well as tag in `make show_boards`. (Issue #204) (https://github.com/sej7278)
- Fix: Add missing newlines at end of some echo's (Issue #207) (https://github.com/sej7278)
- Fix: Add missing/reorder/reword targets in `make help` (https://github.com/sej7278)
- New: Arduino.mk is now compatible with Flymake mode (https://github.com/rbarzic)
- Fix: MONITOR_PORT detection (Issue #213, #215) (https://github.com/sej7278)
- Tweak: Audited regexes/quoting/wildcards (Issue #192) (https://github.com/sej7278)
- New: Build core objects in subdirectory (Issue #82) (https://github.com/sej7278)

### 1.3.3 (2014-04-12)
- Fix: Make a new manpage for ard-reset-arduino. Fixes issue #188 (https://github.com/sej7278)

### 1.3.2 (2014-04-11)
- Fix: Add arduino-mk-vars.md file to RPM SPECfile. (https://github.com/sej7278)
- Fix: Add avr-libc/malloc.c and realloc.c to included core files. Fixes issue #163 (https://github.com/sej7278)
- Fix: Add "gpio" to the list of isp that don't have a port. (Issue #165, #166) (https://github.com/sej7278)
- Fix: Add "-D__PROG_TYPES_COMPAT__" to the avr-g++ compiler flags to match IDE. (https://github.com/sej7278)
- New: Create `Makefile-example-mk`, a *real life* `Makefile` example, to be used as a reference. (https://github.com/ladislas)
- Tweak: Add `OBJDIR` to `arduino-mk-vars.md` (https://github.com/ladislas)
- Tweak: *Beautify* `arduino-mk-vars.md` with code blocks. (https://github.com/ladislas)
- Fix: AVR tools paths for chipKIT in Linux. (https://github.com/peplin)
- Fix: Consider usb or usb:... to be a valid ISP_PORT (https://github.com/geoffholden)
- Add: Add phony target to run pre-build hook script (https://github.com/jrid)
- Fix: Add BOOTLOADER_PARENT to `arduino-mk-vars.md` and fixed BOOTLOADER_PATH example. (https://github.com/sej7278)
- Tweak: Replace perl reset script with Python script. (https://github.com/sej7278)
- Tweak: Made choice of Python2/3 interpreter up to the OS. (https://github.com/peplin)
- Tweak: Simplified packaging dependencies. (https://github.com/sej7278)
- Tweak: Tweak AVRDUDE conf detection in windows. (https://github.com/EAGMnor)

### 1.3.1 (2014-02-04)
- Fix: BUNDLED_AVR_TOOLS_DIR is now set properly when using only arduino-core and not the whole arduino package. (https://github.com/sej7278)
- New: Document all variables that can be overridden. (https://github.com/sej7278)
- New: Add a new `help_vars` target to display information about variables that can be overridden.

### 1.3.0 (2014-01-29)
- Fix: Use more reliable serial device naming in Windows. Fix issue #139 and #155 (https://github.com/peplin)
- Fix: Document that ARDUINO_DIR must be a relative path in Windows. Fix issue #156 (https://github.com/peplin)
- Tweak: Don't hard code MONITOR_PORT in examples, for more flexible testing. (Issue #157) (https://github.com/peplin)
- Tweak: Silence the stderr output from call to `which`. (Issue #158) (https://github.com/peplin)
- Fix: Override complete compiler tool paths for chipKIT. (Issue #159) (https://github.com/peplin)
- New: The makefile is compatible with Windows
- New: Update `README.md` file about usage and Windows compatibility

### 1.2.0 (2014-01-14)
- Add: Add RPM SPECfile and new `package` directory to store package instructions and files (https://github.com/sej7278)
- Fix: Remove use of arduino-mk subdirectory in git. Fix issue #151, #152 and #147 (https://github.com/sej7278)
- Fix: Remove `arduino-mk` directory from all examples. Fix #154

### 1.1.0 (2013-12-26)
- Don't append port details to avrdude for usbasp. See #123
- Ignore commented lines while parsing boards.txt file. See #124
- In ISP mode, read baudrate and programmer from boards.txt. See #125
- Add `burn_bootloader` target. See #85
- Show correct path to `arduino.mk` file in help message. Fix #120
- Change echo for printf. Fix #129 (https://github.com/thomassigurdsen)
- Add support for ChipKiT 2013. Fix #136 (https://github.com/peplin)
- Auto detect and include libraries specified in `USER_LIB_PATH`. Fix #135 (https://github.com/ladislas)
- Use `MAKEFILE_LIST` to get the name of the make file. Fix #130 (https://github.com/cantora)
- New: Add option to set fuses without burning a bootloader. Fix #141 (https://github.com/sej7278)
- Tweak: Don't append port details to avrdude for usbtiny. Fix #140 and #138 (https://github.com/PPvG)
- Fix: Handle relative paths of bootloader file while burning bootloaders. Fix #126 and #142 (https://github.com/sej7278)
- New: Add `CONTRIBUTING.md` explaining how to contribute to the project.
- New: Force -Os optimization for SoftwareSerial. Add `OPTIMIZATION_FLAGS` and `DEBUG_FLAGS`. (https://github.com/mahoy)
- Fix: Use `ARDUINO_HEADER` variable instead of hardcoded file names. Fix #131

### 1.0.1 (2013-09-25)
- Unconditionally add -D in avrdude options. See #114

### 1.0.0 (2013-09-22)
- Add $OBJDIR to the list of configuration that gets printed. Fix issue #77
- Add support for specifying optimization level. Fix issue #81
- Add support for reseting "Micro" Arduino. Fix issue #80 (https://github.com/sej7278)
- Remove "utility" from example makefiles. Fix issue #84
- Auto detect alternate core path from sketchbook folder. Fix issue #86
- Remove redundant checks for ARDUINO_DIR
- Improve avrdude and avrdude.conf path auto detection. Fix issue #48
- Move binary sketch size verification logic inside makefile. Fix issue #54
- Remove dependency on wait-connection-leonardo shell script. Fix issue #95
- Add support for the Digilent chipKIT platform. (https://github.com/peplin)
- Implement ard-parse-boards with shell scripting instead of Perl (https://github.com/peplin)
- Compile with debugging symbols only when DEBUG=1 (https://github.com/peplin)
- Replace Leonardo detection with Caterina detection (https://github.com/sej7278)
- Autodetect baudrate only if either a .ino/.pde is present
- Allow building with Arduino core, without a .ino/.pde file
- Ability to support different Arduino cores (https://github.com/sej7278)

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
