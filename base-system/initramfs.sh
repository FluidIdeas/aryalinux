#!/bin/bash

set -e
set +h

. /sources/build-properties

if ! grep "initramfs" /sources/build-log &> /dev/null
then

cd /sources

tar xf cpio-2.12.tar.bz2
cd cpio-2.12

./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi
make install &&
install -v -m755 -d /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.12/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.12

cd /sources
rm -rf cpio-2.12

tar xf dash-0.5.9.1.tar.gz
cd dash-0.5.9.1
./configure --prefix=/usr --enable-static
make
make install

cd /sources
rm -rf dash-0.5.9.1

tar xf dracut-049.tar.gz
cd dracut-049
sed -i "s/enable_documentation=yes/enable_documentation=no/g" configure
./configure
make
make install

cd /sources
rm -rf dracut-049

echo "initramfs" | tee -a /sources/build-log

fi

