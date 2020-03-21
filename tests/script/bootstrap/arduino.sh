set -e
BOOTSTRAP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $BOOTSTRAP_DIR/common.sh

echo "Installing dependencies for building for the Arduino"

if [ -z "$ARDUINO_DIR" ] || ! test -e $ARDUINO_DIR || [ $OS == "cygwin" ]; then

    echo "Installing Arduino..."

    ARDUINO_BASENAME="arduino-1.0.6"

    if [ $OS == "cygwin" ]; then
        ARDUINO_FILE="$ARDUINO_BASENAME-windows".zip
        EXTRACT_COMMAND="unzip -q"
    elif [ $OS == "mac" ]; then
        ARDUINO_FILE="$ARDUINO_BASENAME-macosx".zip
        EXTRACT_COMMAND="unzip -q"
    else
        ARDUINO_FILE="$ARDUINO_BASENAME-linux64".tgz
        EXTRACT_COMMAND="tar -xzf"
    fi

    ARDUINO_URL=https://downloads.arduino.cc/$ARDUINO_FILE

    _pushd $DEPENDENCIES_FOLDER
    if ! test -e $ARDUINO_FILE
    then
        echo "Downloading Arduino IDE..."
        download $ARDUINO_URL $ARDUINO_FILE

        download_type="$(file --mime-type $DEPENDENCIES_FOLDER/$ARDUINO_FILE)"
        if [[ ! "$download_type" =~ zip ]]; then
          mv $ARDUINO_FILE "bad-$ARDUINO_FILE"

          echo
          echo "[ERROR] Unable to download valid IDE for testing"
          echo "        Downloaded file should be a zip but is: ${download_type##* }."
          echo
          echo "  Download the IDE manually then try again."
          echo "  Download from: https://www.arduino.cc/en/Main/Software"
          echo "  Save to      :  $DEPENDENCIES_FOLDER"
          exit 1
        fi
    fi

    if ! test -d $ARDUINO_BASENAME
    then
        echo "Installing Arduino to local folder..."
        $EXTRACT_COMMAND $ARDUINO_FILE
        echo "Arduino installed"
    fi

    _popd

fi

echo
echo "${bldgreen}Arduino dependencies installed.$txtrst"
