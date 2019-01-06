#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:gtk2
#REQ:gtk3
#REC:desktop-file-utils
#OPT:enchant
#OPT:gucharmap
#OPT:pcre

cd $SOURCE_DIR

wget -nc http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.10.tar.bz2

NAME=bluefish
VERSION=2.2.10.
URL=http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.10.tar.bz2

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

./configure --prefix=/usr --docdir=/usr/share/doc/bluefish-2.2.10 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
