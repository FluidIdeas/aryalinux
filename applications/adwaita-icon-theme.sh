#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:git
#OPT:gtk2
#OPT:gtk3
#OPT:librsvg
#OPT:inkscape

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.30/adwaita-icon-theme-3.30.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.30/adwaita-icon-theme-3.30.1.tar.xz

NAME=adwaita-icon-theme
VERSION=3.30.1
URL=http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.30/adwaita-icon-theme-3.30.1.tar.xz

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

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
