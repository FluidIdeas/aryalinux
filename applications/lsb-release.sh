#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lsb_release script givesbr3ak information about the Linux Standards Base (LSB) status of thebr3ak distribution.br3ak"
SECTION="postlfs"
VERSION=1.4
NAME="lsb-release"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/lsb/lsb-release-1.4.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/lsb/lsb-release-1.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lsb-release/lsb-release-1.4.tar.gz

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

sed -i "s|n/a|unavailable|" lsb_release


./help2man -N --include ./lsb_release.examples \
              --alt_version_key=program_version ./lsb_release > lsb_release.1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m 644 lsb_release.1 /usr/share/man/man1 &&
install -v -m 755 lsb_release   /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
