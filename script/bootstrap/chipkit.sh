set -e
BOOTSTRAP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $BOOTSTRAP_DIR/common.sh

echo "Installing dependencies for building for the chipKIT"


if [ -z "$MPIDE_DIR" ] || ! test -e $MPIDE_DIR || [ $OS == "cygwin" ]; then

    echo "Installing MPIDE..."

    MPIDE_BUILD=20140821
    if [ $OS == "cygwin" ]; then
        MPIDE_BASENAME="mpide-0023-windows-$MPIDE_BUILD"
        MPIDE_FILE="$MPIDE_BASENAME".zip
        EXTRACT_COMMAND="unzip -q"
    elif [ $OS == "mac" ]; then
        MPIDE_BASENAME=mpide-0023-macosx-$MPIDE_BUILD
        MPIDE_FILE="$MPIDE_BASENAME".dmg.zip
        EXTRACT_COMMAND="unzip -q"
    else
        MPIDE_BASENAME=mpide-0023-linux64-$MPIDE_BUILD
        MPIDE_FILE="$MPIDE_BASENAME".tgz
        EXTRACT_COMMAND="tar -xzf"
    fi

    MPIDE_URL=http://chipkit.s3.amazonaws.com/builds/$MPIDE_FILE

    _pushd $DEPENDENCIES_FOLDER
    if ! test -e $MPIDE_FILE
    then
        echo "Downloading MPIDE..."
        download $MPIDE_URL $MPIDE_FILE
    fi

    if ! test -d $MPIDE_BASENAME
    then
        echo "Installing MPIDE to local folder..."
        $EXTRACT_COMMAND $MPIDE_FILE
        if [ $OS == "mac" ]; then
            hdiutil attach $MPIDE_FILE
            cp -R /Volumes/Mpide/Mpide.app/Contents/Resources/Java $MPIDE_BASENAME
            hdiutil detach /Volumes/Mpide
        fi
        rm -rf mpide-0023-$MPIDE_BUILD
        cp -R $MPIDE_BASENAME mpide-0023-$MPIDE_BUILD
        echo "MPIDE installed"
    fi

    if [ $OS == "cygwin" ]; then
        chmod a+x mpide/hardware/pic32/compiler/pic32-tools/bin/*
        chmod a+x -R mpide/hardware/pic32/compiler/pic32-tools/pic32mx/
        chmod a+x mpide/*.dll
        chmod a+x mpide/hardware/tools/avr/bin/*
    fi
    _popd

fi

echo
echo "${bldgreen}chipKIT dependencies installed.$txtrst"
