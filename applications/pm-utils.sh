#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Power Management Utilitiesbr3ak provide simple shell command line tools to suspend and hibernatebr3ak the computer. They can be used to run user supplied scripts onbr3ak suspend and resume.br3ak"
SECTION="general"
VERSION=1.4.1
NAME="pm-utils"

#OPT:xmlto
#OPT:hdparm
#OPT:wireless_tools


cd $SOURCE_DIR

URL=https://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://pm-utils.freedesktop.org/releases/pm-utils-1.4.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pm-utils/pm-utils-1.4.1.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/pm-utils-1.4.1 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 man/*.1 /usr/share/man/man1 &&
install -v -m644 man/*.8 /usr/share/man/man8 &&
ln -sv pm-action.8 /usr/share/man/man8/pm-suspend.8 &&
ln -sv pm-action.8 /usr/share/man/man8/pm-hibernate.8 &&
ln -sv pm-action.8 /usr/share/man/man8/pm-suspend-hybrid.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
