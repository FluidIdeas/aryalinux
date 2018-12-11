#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GMime package contains a setbr3ak of utilities for parsing and creating messages using thebr3ak Multipurpose Internet Mail Extension (MIME) as defined by thebr3ak applicable RFCs. See the <a class=\"ulink\" href=\"http://spruce.sourceforge.net/gmime/\">GMime web site</a> for thebr3ak RFCs resourced. This is useful as it provides an API which adheresbr3ak to the MIME specification as closely as possible while alsobr3ak providing programmers with an extremely easy to use interface tobr3ak the API functions.br3ak"
SECTION="general"
VERSION=3.2.0
NAME="gmime3"

#REQ:glib2
#REQ:libgpg-error
#REC:gobject-introspection
#REC:libidn
#REC:vala
#OPT:docbook-utils
#OPT:gpgme
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gmime/3.2/gmime-3.2.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gmime/3.2/gmime-3.2.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gmime/gmime-3.2.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gmime/gmime-3.2.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gmime/gmime-3.2.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gmime/gmime-3.2.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gmime/gmime-3.2.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gmime/gmime-3.2.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gmime/3.2/gmime-3.2.0.tar.xz

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

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
