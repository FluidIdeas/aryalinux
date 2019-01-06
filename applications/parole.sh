#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gst10-plugins-base
#REQ:gst10-plugins-good
#REQ:libxfce4ui
#REC:libnotify
#REC:taglib

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/parole/1.0/parole-1.0.1.tar.bz2

NAME=parole
VERSION=1.0.1.
URL=http://archive.xfce.org/src/apps/parole/1.0/parole-1.0.1.tar.bz2

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
