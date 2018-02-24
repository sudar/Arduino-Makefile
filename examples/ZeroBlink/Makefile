# Arduino Zero Native Port (should work with Feather, MKR1000 etc.)
# BOOTLOADER: The bootloader on these devices loaded when reset is pressed twice
# or the port is opened/closed at 1200 BAUD. If there is no program on the device,
# you may have to manually enter bootloader by toggling reset twice.
# see http://www.avdweb.nl/arduino/samd21/virus.html
BOARD_TAG = arduino_zero_native

# Define alternative core path if using another board supplier
#ALTERNATE_CORE_PATH = $(HOME)/Arduino/hardware/sparkfun/samd

# Define monitor port and isp port (bootloader port).
# Will automatically detect if Linux/macOS but MUST be defined on Windows
#MONITOR_PORT = com40 # CDC serial
#ISP_PORT = com39 # bootloader

# Define ARM toolchain dir if not using Arduino supplied
#ARM_TOOLS_DIR = /usr

# Define AVR toolchain dir if not using Arduino supplied and using native port
#AVR_TOOLS_DIR = /usr

# Define Arduino support package installation path where SAM device support has been installed
# Linux
#ARDUINO_PACKAGE_DIR := $(HOME)/.arduino15/packages
# macOS
#ARDUINO_PACKAGE_DIR := $(HOME)/Library/Arduino15/packages
# Windows
#ARDUINO_PACKAGE_DIR := "C:/Users/$(USER)/AppData/Local/Arduino15/packages"

include ../../Sam.mk
