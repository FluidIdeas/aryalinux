#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libgcrypt
#REQ:polkit
#REC:gobject-introspection
#REC:systemd
#OPT:gtk-doc
#OPT:xmlto

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/accountsservice/accountsservice-0.6.54.tar.xz

NAME=accountsservice
VERSION=0.6.54
URL=https://www.freedesktop.org/software/accountsservice/accountsservice-0.6.54.tar.xz

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

meson --prefix=/usr \
-Dadmin_group=adm \
-Dsystemd=true \
.. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable accounts-daemon
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
