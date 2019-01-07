#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:python2

cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/docutils/docutils-0.14.tar.gz

NAME=docutils-0.14
VERSION=0.14
URL=http://downloads.sourceforge.net/docutils/docutils-0.14.tar.gz

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
python setup.py install --optimize=1 &&

for f in /usr/bin/rst*.py; do
ln -svf $(basename $f) /usr/bin/$(basename $f .py)
done
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
