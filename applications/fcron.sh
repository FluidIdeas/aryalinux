#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Fcron package contains abr3ak periodical command scheduler which aims at replacing Vixie Cron.br3ak"
SECTION="general"
VERSION=3.2.0
NAME="fcron"

#OPT:vim
#OPT:linux-pam
#OPT:docbook-utils


cd $SOURCE_DIR

URL=http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz

if [ ! -z $URL ]
then
wget -nc http://fcron.free.fr/archives/fcron-3.2.0.src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fcron/fcron-3.2.0.src.tar.gz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 22 fcron &&
useradd -d /dev/null -c "Fcron User" -g fcron -s /bin/false -u 22 fcron

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --without-sendmail     \
            --with-boot-install=no &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable fcron

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
