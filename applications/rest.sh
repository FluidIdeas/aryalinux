#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The rest package contains abr3ak library that was designed to make it easier to access web servicesbr3ak that claim to be \"RESTful\". It includes convenience wrappers forbr3ak libsoup and libxml to ease remote use of the RESTful API.br3ak"
SECTION="gnome"
VERSION=0.8.1
NAME="rest"

#REQ:make-ca
#REQ:libsoup
#REC:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rest/rest-0.8.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rest/rest-0.8.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rest/rest-0.8.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rest/rest-0.8.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rest/rest-0.8.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rest/rest-0.8.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.1.tar.xz

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

./configure --prefix=/usr \
    --with-ca-certificates=/etc/ssl/ca-bundle.crt &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
