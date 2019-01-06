#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:make-ca
#OPT:libpcap
#OPT:python2
#OPT:swig
#OPT:doxygen

cd $SOURCE_DIR

wget -nc http://www.nlnetlabs.nl/downloads/ldns/ldns-1.7.0.tar.gz

NAME=ldns
VERSION=1.7.0
URL=http://www.nlnetlabs.nl/downloads/ldns/ldns-1.7.0.tar.gz

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
--sysconfdir=/etc \
--disable-static \
--with-drill &&
make
make doc

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m755 -d /usr/share/doc/ldns-1.7.0 &&
install -v -m644 doc/html/* /usr/share/doc/ldns-1.7.0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
