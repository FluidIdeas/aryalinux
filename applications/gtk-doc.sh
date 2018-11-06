#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GTK-Doc package contains abr3ak code documenter. This is useful for extracting specially formattedbr3ak comments from the code to create API documentation. This package isbr3ak <span class=\"emphasis\"><em>optional</em>; if it is notbr3ak installed, packages will not build the documentation. This does notbr3ak mean that you will not have any documentation. If GTK-Doc is not available, the install processbr3ak will copy any pre-built documentation to your system.br3ak"
SECTION="general"
VERSION=1.29
NAME="gtk-doc"

#REQ:docbook
#REQ:docbook-xsl
#REQ:itstool
#REQ:libxslt
#REQ:python2
#REQ:python-modules#six
#REC:highlight
#OPT:fop
#OPT:glib2
#OPT:general_which


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-doc/gtk-doc-1.29.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtk-doc/gtk-doc-1.29.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.29.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.29.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.29.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.29.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz

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
