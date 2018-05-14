#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The keybinder package contains abr3ak utility library registering global X keyboard shortcuts.br3ak"
SECTION="x"
VERSION=0.3.0
NAME="keybinder"

#REQ:gtk2
#REC:gobject-introspection
#REC:python-modules#pygtk
#OPT:gtk-doc
#OPT:lua


cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz

if [ ! -z $URL ]
then
wget -nc http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz

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

./configure --prefix=/usr --disable-lua &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
