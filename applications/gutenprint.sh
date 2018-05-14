#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gutenprint (formerlybr3ak Gimp-Print) package contains highbr3ak quality drivers for many brands and models of printers for use withbr3ak <a class=\"xref\" href=\"cups.html\" title=\"Cups-2.2.7\">Cups-2.2.7</a>br3ak and the GIMP-2.0. See a list ofbr3ak supported printers at <a class=\"ulink\" href=\"http://gutenprint.sourceforge.net/p_Supported_Printers.php\">http://gutenprint.sourceforge.net/p_Supported_Printers.php</a>.br3ak"
SECTION="pst"
VERSION=5.2.14
NAME="gutenprint"

#REC:cups
#REC:gimp
#OPT:imagemagick
#OPT:texlive
#OPT:tl-installer
#OPT:doxygen
#OPT:docbook-utils


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/gimp-print/gutenprint-5.2.14.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/gimp-print/gutenprint-5.2.14.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gutenprint/gutenprint-5.2.14.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gutenprint/gutenprint-5.2.14.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.14.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.14.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.14.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gutenprint/gutenprint-5.2.14.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
       {,doc/,doc/developer/}Makefile.in &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/gutenprint-5.2.14/api/gutenprint{,ui2} &&
install -v -m644    doc/gutenprint/html/* \
                    /usr/share/doc/gutenprint-5.2.14/api/gutenprint &&
install -v -m644    doc/gutenprintui2/html/* \
                    /usr/share/doc/gutenprint-5.2.14/api/gutenprintui2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl restart org.cups.cupsd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
