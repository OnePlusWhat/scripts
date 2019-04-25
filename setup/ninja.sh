#!/usr/bin/env bash

cd /tmp || exit 1
git clone https://github.com/ninja-build/ninja.git -b release
cd ninja || exit 1
./configure.py --bootstrap
sudo install ./ninja /usr/local/bin/ninja
rm -rf "${PWD}"
cd - || exit 1
