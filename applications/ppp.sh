#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libpcap

cd $SOURCE_DIR

wget -nc https://download.samba.org/pub/ppp/ppp-2.4.9.tar.gz

NAME=ppp
VERSION=2.4
URL=https://download.samba.org/pub/ppp/ppp-2.4.9.tar.gz

DESCRIPTION="ppp (Paul's PPP Package) is an open source package which implements the Point-to-Point Protocol (PPP) on Linux and Solaris systems."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr
make
sudo make install
cd ..

rm -rf ppp


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

