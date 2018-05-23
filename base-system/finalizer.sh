#!/bin/bash

set -e

if [ -f ./build-properties ]; then
	. build-properties
elif [ -f /sources/build-properties ]; then
	cp /sources/build-properties .
	. build-properties
fi

if [ -f /sources/distro-build.sh ]; then
	cp /sources/distro-build.sh .
fi

chmod a+x distro-build.sh
./distro-build.sh
rm distro-build.sh
