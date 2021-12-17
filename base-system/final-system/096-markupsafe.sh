#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=096-markupsafe

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


python3 setup.py build
python3 setup.py install --optimize=1

fi

cleanup $DIRECTORY
log $NAME