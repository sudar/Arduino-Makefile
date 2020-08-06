#!/usr/bin/env bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TESTS_DIR=examples
export ARDMK_DIR="${ARDMK_DIR:-$SCRIPTS_DIR/../..}"

failures=()

if [[ "$1" == "-q" ]]; then
  QUIET=1
fi

runtest() {
  if [[ $QUIET ]]; then
    make $* TEST=1 > /dev/null 2>&1
  else
    output=`make $* TEST=1`
  fi
}

run() {
  if [[ $QUIET ]]; then
    "$@" > /dev/null 2>&1
  else
    "$@"
  fi
}

info() {
  if [[ $QUIET ]]; then
    return
  fi

  echo "$@"
}

run pushd $SCRIPTS_DIR/../..

# These examples cannot be tested easily at the moment as they require
# alternate cores. The MakefileExample doesn't actually contain any source code
# to compile.
NON_TESTABLE_EXAMPLES=(ATtinyBlink MakefileExample TinySoftWareSerial BlinkOpenCM BlinkOpenCR BlinkTeensy BlinkNetworkRPi BlinkInAVRC DueBlink)

for dir in $TESTS_DIR/*/
do
    dir=${dir%*/}
    example=${dir##*/}
    example_is_testable=true
    for non_testable_example in "${NON_TESTABLE_EXAMPLES[@]}"; do
        if [[ $example == $non_testable_example ]]; then
            example_is_testable=false
            break
        fi
    done

    if ! $example_is_testable; then
        info "Skipping non-testable example $example..."
        continue
    fi

    run pushd $dir
    info "Compiling $example..."
    runtest clean
    runtest

    if [[ $? -ne 0 ]]; then
        failures+=("$example")
        info "Example $example failed"
    fi

    runtest disasm
    if [[ $? -ne 0 ]]; then
        failures+=("$example disasm")
        info "Example $example disasm failed"
    fi

    runtest generate_assembly
    if [[ $? -ne 0 ]]; then
        failures+=("$example generate_assembly")
        info "Example $example generate_assembly failed"
    fi

    runtest symbol_sizes
    if [[ $? -ne 0 ]]; then
        failures+=("$example symbol_sizes")
        info "Example $example symbol_sizes failed"
    fi

    run popd
done

if [[ ${#failures[@]} -eq 0 ]]; then
    echo "All tests passed."
else
  for failure in "${failures[@]}"; do
      echo "Example $failure failed"
  done

  exit 1
fi
