#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=052-shadow

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=shadow-4.9.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                \
    -i etc/login.defs
sed -i 's:DICTPATH.*:DICTPATH\t/lib/cracklib/pw_dict:' etc/login.defs
sed -e "224s/rounds/min_rounds/" -i libmisc/salt.c
touch /usr/bin/passwd
./configure --sysconfdir=/etc \
            --with-group-name-max-length=32
make
make exec_prefix=/usr install
make -C man install-man
mkdir -p /etc/default
useradd -D --gid 999
pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd

fi

cleanup $DIRECTORY
log $NAME