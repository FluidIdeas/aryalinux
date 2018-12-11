#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:doxygen
#OPT:lynx

cd $SOURCE_DIR

wget -nc http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz

NAME=libdaemon
VERSION=0.14
URL=http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz

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

./configure --prefix=/usr --disable-static &&
make
make -C doc doxygen

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make docdir=/usr/share/doc/libdaemon-0.14 install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /usr/share/doc/libdaemon-0.14/api &&
install -v -m644 doc/reference/html/* /usr/share/doc/libdaemon-0.14/api &&
install -v -m644 doc/reference/man/man3/* /usr/share/man/man3
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
