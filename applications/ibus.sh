#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:dconf
#REQ:iso-codes
#REQ:vala
#REC:gobject-introspection
#REC:gtk2
#REC:libnotify
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject3
#OPT:gtk-doc
#OPT:python-modules#pyxdg
#OPT:libxkbcommon
#OPT:wayland

cd $SOURCE_DIR

wget -nc https://github.com/ibus/ibus/releases/download/1.5.19/ibus-1.5.19.tar.gz
wget -nc https://www.unicode.org/Public/zipped/10.0.0/UCD.zip

URL=https://github.com/ibus/ibus/releases/download/1.5.19/ibus-1.5.19.tar.gz

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

mkdir -p               /usr/share/unicode/ucd &&
unzip -u ../UCD.zip -d /usr/share/unicode/ucd
sed -i 's@/desktop/ibus@/org/freedesktop/ibus@g' \
    data/ibus.schemas.in \
    data/dconf/org.freedesktop.ibus.gschema.xml.in
./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --disable-unicode-dict    \
            --disable-emoji-dict      &&
rm -f tools/main.c                    &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
