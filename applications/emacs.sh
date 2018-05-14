#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Emacs package contains anbr3ak extensible, customizable, self-documenting real-time displaybr3ak editor.br3ak"
SECTION="postlfs"
VERSION=25.3
NAME="emacs"

#REC:giflib
#OPT:alsa-lib
#OPT:dbus
#OPT:GConf
#OPT:gnutls
#OPT:gobject-introspection
#OPT:gsettings-desktop-schemas
#OPT:gpm
#OPT:gtk2
#OPT:gtk3
#OPT:imagemagick6
#OPT:libjpeg
#OPT:libpng
#OPT:librsvg
#OPT:libtiff
#OPT:libxml2
#OPT:mitkrb
#OPT:valgrind
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/emacs/emacs-25.3.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/emacs/emacs-25.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/emacs/emacs-25.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/emacs/emacs-25.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/emacs/emacs-25.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/emacs/emacs-25.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/emacs/emacs-25.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/emacs/emacs-25.3.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/emacs/emacs-25.3.tar.xz

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

./configure --prefix=/usr --localstatedir=/var &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chown -v -R root:root /usr/share/emacs/25.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
