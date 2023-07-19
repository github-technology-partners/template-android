#!/bin/bash

# Create necessary directories and copy android-env.sh to the SDK bin directory
mkdir -p /opt/android-sdk-linux/bin/
cp /opt/tools/android-env.sh /opt/android-sdk-linux/bin/
source /opt/android-sdk-linux/bin/android-env.sh

# Default to built-in SDK flavor
built_in_sdk=1

# Check the command-line argument to set the SDK flavor
if [ "$1" == "lazy-dl" ]; then
    echo "Using Lazy Download Flavour"
    built_in_sdk=0
elif [ "$1" == "built-in" ]; then
    echo "Using Built-In SDK Flavour"
else
    echo "Please use either 'built-in' or 'lazy-dl' as a parameter"
    exit 1
fi

# Change the working directory to the Android SDK location
cd "${ANDROID_HOME}"
echo "Set ANDROID_HOME to ${ANDROID_HOME}"

# Check if SDK tools have already been bootstrapped
if [ -f .bootstrapped ]; then
    echo "SDK Tools already bootstrapped. Skipping initial setup"
else
    echo "Bootstrapping SDK-Tools"
    # Download the latest SDK tools from Google's repository and extract them
    mkdir -p cmdline-tools/latest/ \
        && curl -sSL http://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip -o sdk-tools-linux.zip \
        && bsdtar xvf sdk-tools-linux.zip --strip-components=1 -C cmdline-tools/latest \
        && rm sdk-tools-linux.zip \
        && touch .bootstrapped
fi

# Ensure that repositories.cfg exists in the user's home directory for compatibility
echo "Make sure repositories.cfg exists"
mkdir -p ~/.android/
touch ~/.android/repositories.cfg

# Copy licenses and tools to the Android SDK directories
echo "Copying Licences"
cp -rv /opt/licenses "${ANDROID_HOME}/licenses"
echo "Copying Tools"
mkdir -p "${ANDROID_HOME}/bin"
cp -v /opt/tools/*.sh "${ANDROID_HOME}/bin"

# Print sdkmanager version
echo "Print sdkmanager version"
sdkmanager --version

# Install packages based on the chosen SDK flavor
echo "Installing packages"
while read p; do 
    android-accept-licenses.sh "sdkmanager ${SDKMNGR_OPTS} ${p}"
done < "/opt/tools/package-list${built_in_sdk}.txt"

# Update the Android SDK
echo "Updating SDK"
update_sdk

# Accept Android SDK licenses
echo "Accepting Licenses"
android-accept-licenses.sh "sdkmanager ${SDKMNGR_OPTS} --licenses"

# Create symbolic links for certain NDK architectures
if [ -d /opt/android-sdk-linux/ndk-bundle/toolchains ]; then
    (
        cd /opt/android-sdk-linux/ndk-bundle/toolchains \
        && ln -sf aarch64-linux-android-4.9 mips64el-linux-android \
        && ln -sf arm-linux-androideabi-4.9 mipsel-linux-android
    )
fi
