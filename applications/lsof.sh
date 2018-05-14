#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The lsof package is useful to LiStbr3ak Open Files for a given running application or process.br3ak"
SECTION="general"
VERSION=4.91
NAME="lsof"

#REQ:libtirpc


cd $SOURCE_DIR

URL=ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.91.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lsof/lsof_4.91.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lsof/lsof_4.91.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsof/lsof_4.91.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsof/lsof_4.91.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lsof/lsof_4.91.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lsof/lsof_4.91.tar.gz

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

tar -xf lsof_4.91_src.tar  &&
cd lsof_4.91_src           &&
./Configure -n linux       &&
make CFGL="-L./lib -ltirpc"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m0755 -o root -g root lsof /usr/bin &&
install -v lsof.8 /usr/share/man/man8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
