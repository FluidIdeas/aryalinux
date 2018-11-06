#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Balsa package contains abr3ak GNOME-2 based mail client.br3ak"
SECTION="xsoft"
VERSION=2.5.6
NAME="balsa"

#REQ:aspell
#REQ:enchant
#REQ:gmime
#REQ:libesmtp
#REQ:rarian
#REC:pcre
#OPT:compface
#OPT:gtksourceview
#OPT:libnotify
#OPT:mitkrb
#OPT:openldap
#OPT:sqlite
#OPT:webkitgtk
#OPT:gpgme


cd $SOURCE_DIR

URL=http://pawsa.fedorapeople.org/balsa/balsa-2.5.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://pawsa.fedorapeople.org/balsa/balsa-2.5.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/balsa/balsa-2.5.6.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/balsa/balsa-2.5.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/balsa/balsa-2.5.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/balsa/balsa-2.5.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/balsa/balsa-2.5.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/balsa/balsa-2.5.6.tar.bz2

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

./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --without-html-widget    \
            --without-libnotify      &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
