#!/bin/bash

set -e
set +h

. /sources/build-properties

./umountal.sh

DIR=$1

if [ ! -d "$LFS/opt/$DIR" ]; then
	mkdir -pv "$LFS/opt/$DIR"
fi

if [ "x$1" == "xgnome" ] || [ "x$2" == "xkde5" ] || [ "x$2" == "xxfce" ] || [ "x$2" == "xmate" ]; then
	pushd "$LFS/opt/"
	sudo ln -svf "$DIR" "desktop-environment"
	popd
fi