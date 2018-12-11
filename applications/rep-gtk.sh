#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The rep-gtk package contains abr3ak Lisp and GTK binding. This is useful for extendingbr3ak GTK-2 and GDK libraries with Lisp. Starting at rep-gtk-0.15, the package contains thebr3ak bindings to GTK and uses the samebr3ak instructions. Both can be installed, if needed.br3ak"
SECTION="general"
VERSION=0.90.8.3
NAME="rep-gtk"

#REQ:gtk2
#REQ:librep


cd $SOURCE_DIR

URL=http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz

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

./autogen.sh --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
