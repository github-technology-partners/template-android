# Use the Microsoft dev container as the base image
FROM mcr.microsoft.com/vscode/devcontainers/universal

# Set the Android SDK environment variables
ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT $ANDROID_SDK_HOME
ENV ANDROID_HOME $ANDROID_SDK_HOME
ENV ANDROID_SDK $ANDROID_SDK_HOME

# Set Debian to not prompt for user input during package installation
ENV DEBIAN_FRONTEND noninteractive

# Update package lists and install necessary packages
RUN apt-get update -yqq && \
    apt-get install -y \
      curl \
      expect \
      git \
      make \
      wget \
      unzip \
      vim \
      openssh-client \
      locales \
      libarchive-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the locale to en_US.UTF-8
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8


# Set the system language to US English
ENV LANG en_US.UTF-8


#Creating a new non-root user (UID 1001) named "android" with a dedicated home directory in Docker 
#containers enhances security by reducing the risk of running processes as the root user. It limits privileges, 
#reducing potential vulnerabilities and unauthorized access to the container and host system. This practice 
#follows the principle of least privilege and improves overall container security.

# Create a new group and user with UID 1001
RUN addgroup --gid 1001 android && \
    adduser --home /opt/android-sdk-linux --ingroup android --uid 1001 --disabled-password --gecos "" android

#We are using the COPY command to copy the 'tools' and 'licenses' directories from the local build
#context to the '/opt' directory within the Docker image. This is a straightforward way to include 
#these directories and their contents in the image, making them available for use during container runtime.
# Copy the 'tools' and 'licenses' directories to /opt in the image
COPY tools /opt/tools
COPY licenses /opt/licenses

#We first use the WORKDIR command to set the working directory to '/opt/android-sdk-linux' inside the Docker 
#container. This sets the default location where subsequent commands will be executed.
#Next, we use the ENTRYPOINT command to specify the entrypoint script that will be executed 
#when the container starts. The script is located at '/opt/tools/entrypoint.sh', and we pass the argument "built-in" to the script.

#By using the ENTRYPOINT command, the specified script will be executed as the main process in the container,
#allowing it to run continuously and perform its intended tasks.
# Set the working directory to /opt/android-sdk-linux
WORKDIR /opt/android-sdk-linux

# Run the entrypoint script
ENTRYPOINT ["/opt/tools/startingpoint.sh", "built-in"]

