#!/bin/bash

set -e
set +h

. /sources/build-properties

./umountal.sh

DIR=$1

if [ ! -d "$LFS/opt/$DIR" ]; then
	sudo mkdir -pv "$LFS/opt/$DIR"
	pushd "$LFS/opt"
	sudo ln -svf "$DIR" "desktop-environment"
	popd
fi
