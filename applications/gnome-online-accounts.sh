#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GNOME Online Accounts packagebr3ak contains a framework used to access the user's online accounts.br3ak"
SECTION="gnome"
VERSION=3.28.0
NAME="gnome-online-accounts"

#REQ:gcr
#REQ:json-glib
#REQ:rest
#REQ:telepathy-glib
#REQ:vala
#REQ:webkitgtk
#REC:gobject-introspection
#OPT:cheese
#OPT:gtk-doc
#OPT:mitkrb
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.28/gnome-online-accounts-3.28.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.28/gnome-online-accounts-3.28.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-online-accounts/gnome-online-accounts-3.28.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gnome-online-accounts/gnome-online-accounts-3.28.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-online-accounts/gnome-online-accounts-3.28.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-online-accounts/gnome-online-accounts-3.28.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-online-accounts/gnome-online-accounts-3.28.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-online-accounts/gnome-online-accounts-3.28.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.28/gnome-online-accounts-3.28.0.tar.xz

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
            --disable-static \
            --with-google-client-secret=5ntt6GbbkjnTVXx-MSxbmx5e \
            --with-google-client-id=595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
