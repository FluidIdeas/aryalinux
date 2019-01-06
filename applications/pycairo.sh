#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cairo
#OPT:python2

cd $SOURCE_DIR

wget -nc https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz

NAME=pycairo-1.17.1
VERSION=1.17.1
URL=https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz

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

python2 setup.py build

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python2 setup.py install --optimize=1 &&
python2 setup.py install_pycairo_header &&
python2 setup.py install_pkgconfig
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

python3 setup.py build

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1 &&
python3 setup.py install_pycairo_header &&
python3 setup.py install_pkgconfig
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
