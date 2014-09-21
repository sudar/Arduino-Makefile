#!/usr/bin/env bash

set -e

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $SCRIPTS_DIR/..

source $SCRIPTS_DIR/bootstrap/chipkit.sh
source $SCRIPTS_DIR/bootstrap/arduino.sh
