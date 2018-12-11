#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:exo
#REQ:libxfce4ui
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REC:libgudev
#REC:libnotify
#REC:xfce4-panel
#OPT:gvfs
#OPT:libexif
#OPT:tumbler

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/thunar/1.7/Thunar-1.7.0.tar.bz2

URL=http://archive.xfce.org/src/xfce/thunar/1.7/Thunar-1.7.0.tar.bz2

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

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-1.7.0 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
