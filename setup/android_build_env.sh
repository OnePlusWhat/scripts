#!/usr/bin/env bash

# Copyright (C) 2018 Harsh 'MSF Jarvis' Shandilya
# Copyright (C) 2018 Akhil Narang
# SPDX-License-Identifier: GPL-3.0-only

# Script to setup an AOSP Build environment on Linux Mint and Ubuntu

LATEST_MAKE_VERSION="4.2.1"
UBUNTU_14_PACKAGES="binutils-static curl figlet libesd0-dev libwxgtk2.8-dev"
UBUNTU_16_PACKAGES="libesd0-dev"
UBUNTU_18_PACKAGES="curl"
PACKAGES=""

LSB_RELEASE="$(lsb_release -d)"

if [[ "${LSB_RELEASE}" =~ "Ubuntu 14" ]]; then
    PACKAGES="${UBUNTU_14_PACKAGES}"
elif [[ "${LSB_RELEASE}" =~ "Mint 18" || "${LSB_RELEASE}" =~ "Ubuntu 16" ]]; then
    PACKAGES="${UBUNTU_16_PACKAGES}"
elif [[ "${LSB_RELEASE}" =~ "Ubuntu 18" ]]; then
    PACKAGES="${UBUNTU_18_PACKAGES}"
fi

sudo apt update -y
sudo apt install -y adb autoconf automake axel bc bison build-essential clang cmake \
expat fastboot flex g++ g++-multilib gawk gcc gcc-multilib gnupg gperf htop imagemagick \
lib32ncurses5-dev lib32z1-dev libc6-dev libcap-dev libexpat1-dev libgmp-dev liblz4-* \
liblzma* libmpc-dev libmpfr-dev libncurses5-dev libsdl1.2-dev libssl-dev libtinfo5 \
libtool libxml2 libxml2-utils lzma* lzop maven ncftp ncurses-dev patch patchelf \
pkg-config pngcrush pngquant python python-all-dev re2c schedtool squashfs-tools \
subversion texinfo unzip w3m xsltproc zip zlib1g-dev "${PACKAGES}"

if [[ "$(command -v make)" ]]; then
    makeversion="$(make -v | head -1 | awk '{print $3}')"
    if [[ "${makeversion}" != "${LATEST_MAKE_VERSION}" ]]; then
        echo "Installing make ${LATEST_MAKE_VERSION} instead of ${makeversion}"
        ./setup/make.sh "${LATEST_MAKE_VERSION}"
    fi
fi

echo "Installing repo"
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+x /usr/local/bin/repo

./setup/ccache.sh
./setup/ninja.sh
