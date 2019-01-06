#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:docbook
#REQ:docbook-xsl
#REQ:itstool
#REQ:libxslt
#REQ:python2
#REQ:six
#REC:highlight
#OPT:fop
#OPT:glib2
#OPT:which

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz

NAME=gtk-doc
VERSION=1.29
URL=http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz

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
