#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:python2
#OPT:docbook-xsl
#OPT:python-modules#libxml2py2
#OPT:libxslt

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/scons/scons-3.0.0.tar.gz

URL=https://downloads.sourceforge.net/scons/scons-3.0.0.tar.gz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
python setup.py install --prefix=/usr  \
                        --standard-lib \
                        --optimize=1   \
                        --install-data=/usr/share
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
