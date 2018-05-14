#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak IBus is an Intelligent Input Bus.br3ak It is a new input framework for Linux OS. It provides a fullbr3ak featured and user friendly input method user interface.br3ak"
SECTION="general"
VERSION=1.5.18
NAME="ibus"

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

URL=https://github.com/ibus/ibus/releases/download/1.5.18/ibus-1.5.18.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/ibus/ibus/releases/download/1.5.18/ibus-1.5.18.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ibus/ibus-1.5.18.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ibus/ibus-1.5.18.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ibus/ibus-1.5.18.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ibus/ibus-1.5.18.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ibus/ibus-1.5.18.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ibus/ibus-1.5.18.tar.gz
wget -nc https://www.unicode.org/Public/zipped/10.0.0/UCD.zip

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

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
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
