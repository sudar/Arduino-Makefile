### DISCLAIMER
### This is an example Makefile and it MUST be configured to suit your needs.
### For detailed explanations about all of the available options, please refer
### to https://github.com/sudar/Arduino-Makefile/blob/master/arduino-mk-vars.md

### How to setup a project using a board definition provided by the 3rd party
### =========================================================================

### Some vendors provide definitions/configuration of their boards separately,
### as so-called addon packages. Originally, they are supposed to be used in
### the Arduino IDE but they can be used with Arduino-Makefile as well:

### 1. get the package from the vendor
###    if they provide .json file, look into it and take the URL of the package
###       archive from there
###
### 2. extract the package into your ARDUINO_SKETCHBOOK directory
###    you have to end with the directory structure like this, in your
###    ARDUINO_SKETCHBOOK directory (sparkfun is the vendor name):

###        hardware/
###        ├── sparkfun/
###        │   └── avr/
###        │       ├── boards.txt
###        │       ├── bootloaders/
###        │       ├── driver/
###        │       ├── platform.txt
###        │       ├── signed_driver/
###        │       └── variants/

### 3. Create this Makefile (use your vendor/package name)

###        ALTERNATE_CORE      = sparkfun
###        include $(HOME)/Arduino-Makefile/Arduino.mk

### 4. run 'make show_boards'
###    check that you can see (only) boards provided by this vendor

### 5. select the name of your board
###    and add a line "BOARD_TAG = ...." to your Makefile

### 6. if your board has more cpu variants, run 'make show_submenu'
###    to see them; select your one and add a line "BOARD_SUB = ...."
###    to your Makefile

#####

### The basic configuration should be done now.
### The example follows:

ARDUINO_SKETCHBOOK  = $(HOME)/sketchbook
ALTERNATE_CORE      = sparkfun
BOARD_TAG           = promicro
BOARD_SUB	    = 8MHzatmega32U4
include /usr/share/arduino/Arduino.mk

