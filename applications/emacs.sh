#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:giflib
#OPT:installing
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
#OPT:librsvg
#OPT:libtiff
#OPT:libxml2
#OPT:mitkrb
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.xz

NAME=emacs
VERSION=26.1
URL=https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr --localstatedir=/var &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
chown -v -R root:root /usr/share/emacs/26.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
