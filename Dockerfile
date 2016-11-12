FROM ubuntu:16.04

MAINTAINER Yasutaka Kawamoto

# update
RUN apt-get update

# for slack notification
RUN apt-get -y install curl

# Install for running 32-bit applications
# 64-bit distribution capable of running 32-bit applications
# https://developer.android.com/studio/index.html
RUN apt-get -y install lib32stdc++6 lib32z1

# For DeployGate
RUN apt-get -y install build-essential ruby ruby-dev

# Install Java8
RUN apt-get install -y openjdk-8-jdk

RUN mkdir -p /user/local/android-sdk-linux

RUN cd /user/local/android-sdk-linux && wget --output-document=tools_r25.2.2-linux.zip --quiet https://dl.google.com/android/repository/tools_r25.2.2-linux.zip && \
  unzip tools_r25.2.2-linux.zip

# # Download Android SDK
# RUN apt-get -y install wget \
#   && cd /usr/local \
#   && wget https://dl.google.com/android/repository/tools_r25.2.2-linux.zip \
#   && unzip tools_r25.2.2-linux.zip \
#   && rm -rf /usr/local/tools_r25.2.2-linux.zip

# Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_HOME /user/local/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
#ENV ANDROID_EMULATOR_FORCE_32BIT true


RUN sudo ls -lah /user/local/android-sdk-linux/tools

# Update of Android SDK
# RUN echo y | android update sdk --no-ui --all --filter "android-25,build-tools-25.0.0" \
#   && echo y | android update sdk --no-ui --all --filter "extra-android-support,extra-google-m2repository,extra-android-m2repository,extra-google-google_play_services" \
#   && echo y | android update sdk -a -u -t "sys-img-armeabi-v7a-android-24"

RUN echo y | android update sdk --all --no-ui --filter platform-tools,tools && \
    echo y | android update sdk --all --no-ui --filter platform-tools,tools,build-tools-24.0.1,android-24,addon-google_apis-google-24,extra-android-support,extra-android-m2repository,extra-google-m2repository,sys-img-armeabi-v7a-android-24


RUN which adb
RUN which android


# Create emulator
RUN echo "no" | android create avd \
                --force \
                --device "Nexus 5" \
                --name test \
                --target android-24 \
                --abi armeabi-v7a \
                --skin WVGA800 \
                --sdcard 512M

# Cleaning
RUN apt-get clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace


