#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cyrus-sasl


cd $SOURCE_DIR

NAME=openldap
VERSION=2.6.2
URL=https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.2.tgz
SECTION="Other Server Software"
DESCRIPTION="The OpenLDAP package provides an open source implementation of the Lightweight Directory Access Protocol."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.2.tgz
wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.6.2.tgz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/5.0/openldap-2.6.2-consolidated-1.patch
wget -nc https://www.openldap.org/doc/admin26/
wget -nc http://www.openldap.org/pub/


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

echo $USER > /tmp/currentuser


patch -Np1 -i ../openldap-2.6.2-consolidated-1.patch &&
autoconf &&

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dynamic  \
            --enable-versioning=yes  \
            --disable-debug   \
            --disable-slapd &&

make depend &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd