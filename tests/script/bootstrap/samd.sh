set -e
BOOTSTRAP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $BOOTSTRAP_DIR/common.sh

echo "Installing dependencies for building for the SAMD boards"

# these extract to dirs without versions...
SAMD_PACKAGE="samd-1.8.6"
CMSIS_PACKAGE="CMSIS-4.5.0"
CMSIS_ATMEL_PACKAGE="CMSIS-Atmel-1.2.0"

if [ $OS == "mac" ]; then
  TOOLCHAIN_PACKAGE="gcc-arm-none-eabi-7-2017-q4-major-mac"
else
  TOOLCHAIN_PACKAGE="gcc-arm-none-eabi-7-2017-q4-major-linux"
fi

ARDUINO_URL=https://downloads.arduino.cc
TOOLCHAIN_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2017q4

EXTRACT_COMMAND="tar -xjf"

_pushd $DEPENDENCIES_FOLDER
if ! test -e $SAMD_PACKAGE
then
    echo "Downloading SAMD packages..."
    download $ARDUINO_URL/cores/$SAMD_PACKAGE.tar.bz2 $SAMD_PACKAGE.tar.bz2
    download $ARDUINO_URL/$CMSIS_PACKAGE.tar.bz2 $CMSIS_PACKAGE.tar.bz2
    download $ARDUINO_URL/$CMSIS_ATMEL_PACKAGE.tar.bz2 $CMSIS_ATMEL_PACKAGE.tar.bz2
    download $TOOLCHAIN_URL/$TOOLCHAIN_PACKAGE.tar.bz2 $TOOLCHAIN_PACKAGE.tar.bz2
fi

if ! test -d $SAMD_PACKAGE
then
    echo "Installing packages to local folder..."
    $EXTRACT_COMMAND $SAMD_PACKAGE.tar.bz2
    $EXTRACT_COMMAND $CMSIS_PACKAGE.tar.bz2
    $EXTRACT_COMMAND $CMSIS_ATMEL_PACKAGE.tar.bz2
    $EXTRACT_COMMAND $TOOLCHAIN_PACKAGE.tar.bz2
    echo "SAMD support installed"
fi

_popd

echo
echo "${bldgreen}SAMD dependencies installed.$txtrst"
