#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:popt
#OPT:icu

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/gptfdisk-1.0.4-convenience-1.patch

NAME=gptfdisk
VERSION=1.0.4
URL=https://downloads.sourceforge.net/gptfdisk/gptfdisk-1.0.4.tar.gz

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

patch -Np1 -i ../gptfdisk-1.0.4-convenience-1.patch &&
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
