#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Khelpcenter is an application tobr3ak show KDE Applications' documentation.br3ak"
SECTION="kde"
VERSION=18.08.0
NAME="khelpcenter"

#REQ:grantlee
#REQ:libxml2
#REQ:xapian
#REQ:kframeworks5


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/18.08.0/src/khelpcenter-18.08.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.kde.org/stable/applications/18.08.0/src/khelpcenter-18.08.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/khelpcenter/khelpcenter-18.08.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/khelpcenter/khelpcenter-18.08.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/khelpcenter/khelpcenter-18.08.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/khelpcenter/khelpcenter-18.08.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/khelpcenter/khelpcenter-18.08.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/khelpcenter/khelpcenter-18.08.0.tar.xz

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

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/opt/kf5 \
      -DCMAKE_BUILD_TYPE=Release         \
      -DBUILD_TESTING=OFF                \
      -Wno-dev .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install  &&
mv -v /opt/kf5/share/kde4/services/khelpcenter.desktop /usr/share/applications/ &&
rm -rv /opt/kf5/share/kde4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
