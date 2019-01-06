#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:which

cd $SOURCE_DIR

wget -nc https://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2
wget -nc ftp://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2

NAME=lm_sensors
VERSION=3.4.0.
URL=https://ftp.gwdg.de/pub/linux/misc/lm-sensors/lm_sensors-3.4.0.tar.bz2

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

make PREFIX=/usr \
BUILD_STATIC_LIB=0 \
MANDIR=/usr/share/man

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make PREFIX=/usr \
BUILD_STATIC_LIB=0 \
MANDIR=/usr/share/man install &&

install -v -m755 -d /usr/share/doc/lm_sensors-3.4.0 &&
cp -rv README INSTALL doc/* \
/usr/share/doc/lm_sensors-3.4.0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
sensors-detect
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
