#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cups
#REQ:glib2
#REQ:gs
#REQ:lcms2
#REQ:poppler
#REQ:qpdf
#REQ:libjpeg
#REQ:libpng
#REQ:libtiff
#REQ:mupdf


cd $SOURCE_DIR

wget -nc https://www.openprinting.org/download/cups-filters/cups-filters-1.25.2.tar.xz


NAME=cups-filters
VERSION=1.25.2
URL=https://www.openprinting.org/download/cups-filters/cups-filters-1.25.2.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


sed -i "s:cups.service:org.cups.cupsd.service:g" utils/cups-browsed.service
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --without-rcdir      \
            --disable-static     \
            --disable-avahi      \
            --docdir=/usr/share/doc/cups-filters-1.25.2 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 utils/cups-browsed.service /lib/systemd/system/cups-browsed.service
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable cups-browsed
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

