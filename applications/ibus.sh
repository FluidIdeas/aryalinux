#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:iso-codes
#REQ:libarchive
#REQ:vala
#REQ:dconf
#REQ:glib2
#REQ:gtk3
#REQ:libnotify

cd $SOURCE_DIR
NAME=ibus
VERSION=1.5.33
URL=https://github.com/ibus/ibus/archive/1.5.33/ibus-1.5.33.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/ibus/ibus/archive/1.5.33/ibus-1.5.33.tar.gz


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

sed -e 's@/desktop/ibus@/org/freedesktop/ibus@g' \
    -i data/dconf/org.freedesktop.ibus.gschema.xml
if ! [ -e /usr/bin/gtkdocize ]; then
  sed '/docs/d;/GTK_DOC/d' -i Makefile.am configure.ac
fi
SAVE_DIST_FILES=1 NOCONFIGURE=1 ./autogen.sh
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-python2      \
            --disable-appindicator \
            --disable-gtk2         \
            --disable-emoji-dict
make
gtk-query-immodules-3.0 --update-cache
mkdir -p               /usr/share/unicode/ucd
unzip -o ../UCD.zip -d /usr/share/unicode/ucd


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd