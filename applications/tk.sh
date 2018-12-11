#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Tk package contains a TCL GUIbr3ak Toolkit.br3ak"
SECTION="general"
VERSION=8.6.8
NAME="tk"

#REQ:tcl
#REQ:x7lib


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/tcl/tk8.6.8-src.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/tcl/tk8.6.8-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tk/tk8.6.8-src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tk/tk8.6.8-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tk/tk8.6.8-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tk/tk8.6.8-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tk/tk8.6.8-src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tk/tk8.6.8-src.tar.gz

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

cd unix &&
./configure --prefix=/usr \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make &&
sed -e "s@^\(TK_SRC_DIR='\).*@\1/usr/include'@" \
    -e "/TK_B/s@='\(-L\)\?.*unix@='\1/usr/lib@" \
    -i tkConfig.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
make install-private-headers &&
ln -v -sf wish8.6 /usr/bin/wish &&
chmod -v 755 /usr/lib/libtk8.6.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
