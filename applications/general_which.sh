#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="The which utility displays the full path for executables that are present in the PATH"
SECTION="general"
VERSION=2.21
NAME="general_which"



cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/which/which-2.21.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.gnu.org/gnu/which/which-2.21.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc http://ftp.gnu.org/gnu/which/which-2.21.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/which/which-2.21.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/which/which-2.21.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
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
sudo ./rootscript.sh
sudo rm rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
