#!/bin/bash

set +e

timeout=600
sleeptime=10
maxfail=$((timeout / sleeptime))

wait_for_emulator_start() {
    local bootcomplete=""
    local failcounter=0

    while [[ $failcounter -le $maxfail ]]; do
        bootcomplete=$(adb -e shell getprop dev.bootcomplete 2>&1)
        if [[ "$bootcomplete" == "1" ]]; then
            echo "Emulator is ready"
            return 0
        fi
        ((failcounter++))
        echo "Waiting for emulator to start"
        sleep "$sleeptime"
    done

    echo "Timeout ($timeout seconds) reached; failed to start emulator"
    while pkill -9 "emulator" >/dev/null 2>&1; do
        echo "Killing emulator process..."
        pgrep "emulator"
    done
    echo "Process terminated"
    pgrep "emulator"
    return 1
}

wait_for_emulator_start
