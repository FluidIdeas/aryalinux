#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:cups
#REC:gimp
#OPT:imagemagick
#OPT:texlive
#OPT:tl-installer
#OPT:doxygen
#OPT:docbook-utils

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/gimp-print/gutenprint-5.2.14.tar.bz2

NAME=gutenprint
VERSION=5.2.14
URL=https://downloads.sourceforge.net/gimp-print/gutenprint-5.2.14.tar.bz2

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

sed -i 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
{,doc/,doc/developer/}Makefile.in &&

./configure --prefix=/usr --disable-static &&

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/gutenprint-5.2.14/api/gutenprint{,ui2} &&
install -v -m644 doc/gutenprint/html/* \
/usr/share/doc/gutenprint-5.2.14/api/gutenprint &&
install -v -m644 doc/gutenprintui2/html/* \
/usr/share/doc/gutenprint-5.2.14/api/gutenprintui2
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl restart org.cups.cupsd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
