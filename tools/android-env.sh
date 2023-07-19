#!/usr/bin/env bash

# Set environment variables for the Android SDK
export ANDROID_HOME=/opt/android-sdk-linux
export ANDROID_SDK_ROOT=${ANDROID_HOME}
export ANDROID_SDK_HOME=${ANDROID_HOME}
export ANDROID_SDK=${ANDROID_HOME}

# Append Android SDK directories to the PATH environment variable
export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/bin:

# Check if there are proxy settings and configure Java options accordingly
if [[ ! -z "$http_proxy" ]] || [[ ! -z "$https_proxy" ]]; then
    export JAVA_OPTS="-Djava.net.useSystemProxies=true $JAVA_OPTS -Dhttp.noProxyHosts=${no_proxy}"
    # The following options work when the container is started with --net=host and a proxy is listening on the Docker host machine.
    export SDKMNGR_OPTS=" --proxy=http --proxy_host=127.0.0.1 --proxy_port=3128 --no_https "
fi

# Function to print a header using the "figlet" command
function print_header() {
    figlet SBB CFF FFS
    figlet welcome to
    figlet andep
    echo ''
    echo ''
    echo ''
}

# Function to display usage instructions
function help() {
    figlet "usage:"
    echo "update_sdk: Updates the SDK"
    echo "andep: Installs one or more Android packages."
    echo "   -Example: andep \"platforms;android-26\""
    echo "help: Shows this help"
    echo ''
    echo ''
    echo ''
}

# Function to update the Android SDK
function update_sdk() {
    android-accept-licenses.sh "sdkmanager ${SDKMNGR_OPTS} --update"
}

# Function to install Android packages
function andep() {
    if [ -z "${1}" ]; then
        help
        return 1
    fi
    android-accept-licenses.sh  "sdkmanager ${SDKMNGR_OPTS} ${1}"
}

# Export the functions so they can be used as commands in the container
export -f help
export -f update_sdk
export -f andep
