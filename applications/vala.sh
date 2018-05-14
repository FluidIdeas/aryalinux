#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Vala is a new programming languagebr3ak that aims to bring modern programming language features tobr3ak GNOME developers without imposingbr3ak any additional runtime requirements and without using a differentbr3ak ABI compared to applications and libraries written in C.br3ak"
SECTION="general"
VERSION=0.40.3
NAME="vala"

#REQ:glib2
#OPT:dbus
#OPT:graphviz
#OPT:libxslt


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/vala/0.40/vala-0.40.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/vala/0.40/vala-0.40.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vala/vala-0.40.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/vala/vala-0.40.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vala/vala-0.40.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vala/vala-0.40.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vala/vala-0.40.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vala/vala-0.40.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vala/0.40/vala-0.40.3.tar.xz

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

sed -i '115d; 121,137d; 139,140d'  configure.ac &&
sed -i '/valadoc/d' Makefile.am                 &&
ACLOCAL= autoreconf -fiv                        &&
./configure --prefix=/usr                       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
