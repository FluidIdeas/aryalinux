#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:cyrus-sasl

cd $SOURCE_DIR

wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.47.tgz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/openldap-2.4.47-consolidated-1.patch

NAME=openldap
VERSION=2.4.47
URL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.47.tgz

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

patch -Np1 -i ../openldap-2.4.47-consolidated-1.patch &&
autoconf &&

./configure --prefix=/usr \
--sysconfdir=/etc \
--disable-static \
--enable-dynamic \
--disable-debug \
--disable-slapd &&

make depend &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install

ln -sf ../lib/slapd /usr/sbin/slapd


ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
