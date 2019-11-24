#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dconf
#REQ:iso-codes
#REQ:vala
#REQ:gobject-introspection
#REQ:gtk2
#REQ:libnotify


cd $SOURCE_DIR

wget -nc https://github.com/ibus/ibus/releases/download/1.5.21/ibus-1.5.21.tar.gz
wget -nc https://www.unicode.org/Public/zipped/10.0.0/UCD.zip


NAME=ibus
VERSION=1.5.21
URL=https://github.com/ibus/ibus/releases/download/1.5.21/ibus-1.5.21.tar.gz

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

sudo mkdir -p               /usr/share/unicode/ucd &&
sudo unzip -u ../UCD.zip -d /usr/share/unicode/ucd

sed -i 's@/desktop/ibus@/org/freedesktop/ibus@g' \
    data/dconf/org.freedesktop.ibus.gschema.xml

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --disable-unicode-dict    \
            --disable-dconf              \
            --disable-emoji-dict      &&
rm -f tools/main.c                    &&
make

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

