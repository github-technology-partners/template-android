#!/bin/bash

# Define a function to check if the 'su-exec' command exists
checkbin() {
    command -v su-exec >/dev/null
}

# Change ownership of the '/opt/android-sdk-linux' directory to 'android' user and group
chown android:android /opt/android-sdk-linux

# Print the environment variables
printenv

# Determine how to execute the 'android-sdk-update.sh' script based on the availability of 'su-exec'
if checkbin; then
    su-exec android:android /opt/tools/android-sdk-update.sh "$@"
else
    su android -c "/opt/tools/android-sdk-update.sh $1"
fi
