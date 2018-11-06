#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Talloc provides a hierarchical,br3ak reference counted memory pool system with destructors. It is thebr3ak core memory allocator used in Samba.br3ak"
SECTION="general"
VERSION=2.1.14
NAME="talloc"

#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:python2
#OPT:gdb
#OPT:git
#OPT:xfsprogs
#OPT:libtirpc
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.samba.org/ftp/talloc/talloc-2.1.14.tar.gz

if [ ! -z $URL ]
then
wget -nc https://www.samba.org/ftp/talloc/talloc-2.1.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/talloc/talloc-2.1.14.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/talloc/talloc-2.1.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/talloc/talloc-2.1.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/talloc/talloc-2.1.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/talloc/talloc-2.1.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/talloc/talloc-2.1.14.tar.gz

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
