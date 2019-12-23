#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=026-perl

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=perl-5.30.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
make
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.30.1
cp -Rv lib/* /tools/lib/perl5/5.30.1

fi

cleanup $DIRECTORY
log $NAME