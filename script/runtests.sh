#!/usr/bin/env bash

failures=()

for dir in tests/*/
do
    dir=${dir%*/}
    example=${dir##*/}
    pushd $dir
    echo "Compiling $example..."
    make_output=`make clean`
    make_output=`make`
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
