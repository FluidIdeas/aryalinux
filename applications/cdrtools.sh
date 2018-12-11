#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Cdrtools package contains CDbr3ak recording utilities. These are useful for reading, creating orbr3ak writing (burning) CDs, DVDs, and Blu-ray discs.br3ak"
SECTION="multimedia"
VERSION=09
NAME="cdrtools"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cdrtools/cdrtools-3.02a09.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cdrtools/cdrtools-3.02a09.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdrtools/cdrtools-3.02a09.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cdrtools/cdrtools-3.02a09.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cdrtools/cdrtools-3.02a09.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cdrtools/cdrtools-3.02a09.tar.bz2

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

export GMAKE_NOWARN=true &&
make -j1 INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export GMAKE_NOWARN=true &&
make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root install &&
install -v -m755 -d /usr/share/doc/cdrtools-3.02a09 &&
install -v -m644 README* ABOUT doc/*.ps \
                    /usr/share/doc/cdrtools-3.02a09

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
