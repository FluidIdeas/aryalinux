#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The tree application, as the namebr3ak suggests, is useful to display, in a terminal, directory contents,br3ak including directories, files, links.br3ak"
SECTION="general"
VERSION=1.7.0
NAME="tree"



cd $SOURCE_DIR

URL=http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz

if [ ! -z $URL ]
then
wget -nc http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://mama.indstate.edu/linux/tree/tree-1.7.0.tgz

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

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make MANDIR=/usr/share/man/man1 install &&
chmod -v 644 /usr/share/man/man1/tree.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
