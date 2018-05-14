#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Fontconfig package contains abr3ak library and support programs used for configuring and customizingbr3ak font access.br3ak"
SECTION="general"
VERSION=2.13.0
NAME="fontconfig"

#REQ:freetype2
#OPT:docbook-utils
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fontconfig/fontconfig-2.13.0.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fontconfig/fontconfig-2.13.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontconfig/fontconfig-2.13.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontconfig/fontconfig-2.13.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.13.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fontconfig/fontconfig-2.13.0.tar.bz2

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

rm -f src/fcobjshash.h


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.13.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 \
        /usr/share/{man/man{1,3,5},doc/fontconfig-2.13.0/fontconfig-devel} &&
install -v -m644 fc-*/*.1         /usr/share/man/man1 &&
install -v -m644 doc/*.3          /usr/share/man/man3 &&
install -v -m644 doc/fonts-conf.5 /usr/share/man/man5 &&
install -v -m644 doc/fontconfig-devel/* \
                                  /usr/share/doc/fontconfig-2.13.0/fontconfig-devel &&
install -v -m644 doc/*.{pdf,sgml,txt,html} \
                                  /usr/share/doc/fontconfig-2.13.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
