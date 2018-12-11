#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The startup-notification packagebr3ak contains <code class=\"filename\">startup-notificationbr3ak libraries. These are useful for building a consistent manner tobr3ak notify the user through the cursor that the application is loading.br3ak"
SECTION="x"
VERSION=0.12
NAME="startup-notification"

#REQ:x7lib
#REQ:xcb-util


cd $SOURCE_DIR

URL=https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/startup-notification/startup-notification-0.12.tar.gz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D doc/startup-notification.txt \
    /usr/share/doc/startup-notification-0.12/startup-notification.txt

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
