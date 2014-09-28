#!/usr/bin/env bash

TESTS_DIR=examples

failures=()

# These examples cannot be tested easily at the moment as they require
# alternate cores. The MakefileExample doesn't actually contain any source code
# to compile.
NON_TESTABLE_EXAMPLES=(ATtinyBlink MakefileExample TinySoftWareSerial)

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
        echo "Skipping non-testable example $example..."
        continue
    fi

    pushd $dir
    echo "Compiling $example..."
    make_output=`make clean TEST=1`
    make_output=`make TEST=1`
    if [[ $? -ne 0 ]]; then
        failures+=("$example")
        echo "Example $example failed"
    fi
    popd
done

for failure in "${failures[@]}"; do
    echo "Example $failure failed"
done

if [[ ${#failures[@]} -eq 0 ]]; then
    echo "All tests passed."
else
    exit 1
fi
