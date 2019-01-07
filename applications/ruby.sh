#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:db
#OPT:doxygen
#OPT:graphviz
#OPT:tk
#OPT:valgrind
#OPT:yaml

cd $SOURCE_DIR

wget -nc http://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.0.tar.xz

NAME=ruby
VERSION=2.6.0
URL=http://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.0.tar.xz

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
--enable-shared \
--docdir=/usr/share/doc/ruby-2.6.0 &&
make
make capi

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
