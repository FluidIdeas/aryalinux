#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:which
#OPT:icu
#OPT:python2

cd $SOURCE_DIR

wget -nc https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2

URL=https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2

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

./bootstrap.sh --prefix=/usr &&
./b2 stage threading=multi link=shared

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
./b2 install threading=multi link=shared                 &&
ln -svf detail/sha1.hpp /usr/include/boost/uuid/sha1.hpp
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
