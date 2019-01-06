#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cups
#REQ:glib2
#REQ:gs
#REQ:lcms2
#REQ:poppler
#REQ:qpdf
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:mupdf
#OPT:avahi
#OPT:TTF-and-OTF-fonts#dejavu-fonts
#OPT:ijs
#OPT:openldap
#OPT:php
#OPT:gutenprint

cd $SOURCE_DIR

wget -nc https://www.openprinting.org/download/cups-filters/cups-filters-1.21.6.tar.xz

NAME=cups-filters
VERSION=1.21.6
URL=https://www.openprinting.org/download/cups-filters/cups-filters-1.21.6.tar.xz

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

sed -i "s:cups.service:org.cups.cupsd.service:g" utils/cups-browsed.service
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --without-rcdir      \
            --disable-static     \
            --disable-avahi      \
            --docdir=/usr/share/doc/cups-filters-1.21.6 &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 utils/cups-browsed.service /lib/systemd/system/cups-browsed.service
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
systemctl enable cups-browsed
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
