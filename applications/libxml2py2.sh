#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libxml2
#REQ:python2

cd $SOURCE_DIR

wget -nc http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz

NAME=libxml2-2.9.8 (for its python2 module)
VERSION=2.9.8
URL=http://xmlsoft.org/sources/libxml2-2.9.8.tar.gz

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

cd python             &&
python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
