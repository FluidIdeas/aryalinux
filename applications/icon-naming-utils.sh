#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The icon-naming-utils packagebr3ak contains a Perl script used forbr3ak maintaining backwards compatibility with current desktop iconbr3ak themes, while migrating to the names specified in the <a class=\"ulink\" href=\"http://standards.freedesktop.org/icon-naming-spec/latest/\">Iconbr3ak Naming Specification</a>.br3ak"
SECTION="x"
VERSION=0.8.90
NAME="icon-naming-utils"

#REQ:perl-modules#perl-xml-simple


cd $SOURCE_DIR

URL=http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
