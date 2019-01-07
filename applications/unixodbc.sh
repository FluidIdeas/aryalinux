#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:pth

cd $SOURCE_DIR

wget -nc ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.7.tar.gz

NAME=unixodbc
VERSION=2.3.7
URL=ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.7.tar.gz

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
--sysconfdir=/etc/unixODBC &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

find doc -name "Makefile*" -delete &&
chmod 644 doc/{lst,ProgrammerManual/Tutorial}/* &&

install -v -m755 -d /usr/share/doc/unixODBC-2.3.7 &&
cp -v -R doc/* /usr/share/doc/unixODBC-2.3.7
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
