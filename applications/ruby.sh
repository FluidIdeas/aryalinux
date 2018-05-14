#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Ruby package contains thebr3ak Ruby development environment. Thisbr3ak is useful for object-oriented scripting.br3ak"
SECTION="general"
VERSION=2.5.1
NAME="ruby"

#OPT:db
#OPT:doxygen
#OPT:graphviz
#OPT:tk
#OPT:valgrind
#OPT:yaml


cd $SOURCE_DIR

URL=http://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ruby/ruby-2.5.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/ruby/ruby-2.5.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ruby/ruby-2.5.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ruby/ruby-2.5.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ruby/ruby-2.5.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ruby/ruby-2.5.1.tar.xz

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

./configure --prefix=/usr   \
            --enable-shared \
            --docdir=/usr/share/doc/ruby-2.5.1 &&
make "-j`nproc`" || make


make capi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
