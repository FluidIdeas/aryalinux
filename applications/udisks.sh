#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The UDisks package provides abr3ak storage daemon that implements well-defined D-Bus interfaces thatbr3ak can be used to query and manipulate storage devices.br3ak"
SECTION="general"
VERSION=1.0.5
NAME="udisks"

#REQ:dbus-glib
#REQ:libatasmart
#REQ:libgudev
#REQ:lvm2
#REQ:parted
#REQ:polkit
#REQ:sg3_utils
#REC:systemd
#OPT:gtk-doc
#OPT:libxslt
#OPT:sudo


cd $SOURCE_DIR

URL=https://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz

if [ ! -z $URL ]
then
wget -nc https://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz

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

sed 's@#include <stdio\.h>@#include <sys/stat.h>\n#include <stdio.h>@' \
    -i src/helpers/job-drive-detach.c


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make profiledir=/etc/bash_completion.d install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
