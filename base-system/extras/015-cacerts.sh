#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="014-cacerts.sh"
TARBALL="make-ca-0.7.tar.gz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

install -vdm755 /etc/ssl/local

install -vdm755 /etc/ssl/local &&
openssl x509 -in ../root.crt -text -fingerprint -setalias "CAcert Class 1 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_1_root.pem &&
openssl x509 -in ../class3.crt -text -fingerprint -setalias "CAcert Class 3 root" \
        -addtrust serverAuth -addtrust emailProtection -addtrust codeSigning \
        > /etc/ssl/local/CAcert_Class_3_root.pem

export CFLAGS="-march=skylake -mtune=generic -O3"
export CXXFLAGS="-march=skylake -mtune=generic -O3"
export CPPFLAGS="-march=skylake -mtune=generic -O3"

make install
sed -e 's%= /etc/ssl;%= "/etc/ssl";%' \
    -e 's%= /usr;%= "/usr";%'         \
    -i /usr/bin/c_rehash              &&
/usr/sbin/make-ca -f -C ../certdata.txt

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
