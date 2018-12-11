#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libxslt
#OPT:gdb
#OPT:valgrind

cd $SOURCE_DIR

wget -nc https://files.pythonhosted.org/packages/source/l/lxml/lxml-4.2.5.tar.gz

NAME=lxml-4.2.5
VERSION=4.2.5
URL=https://files.pythonhosted.org/packages/source/l/lxml/lxml-4.2.5.tar.gz

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

python setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

python3 setup.py clean &&
python3 setup.py build

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python3 setup.py install --optimize=1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
