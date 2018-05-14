#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Gtk VNC package contains a VNCbr3ak viewer widget for GTK+. It isbr3ak built using coroutines allowing it to be completely asynchronousbr3ak while remaining single threaded.br3ak"
SECTION="x"
VERSION=0.7.2
NAME="gtk-vnc"

#REQ:gnutls
#REQ:gtk3
#REQ:libgcrypt
#REC:gobject-introspection
#REC:vala
#OPT:cyrus-sasl
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.7/gtk-vnc-0.7.2.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.7/gtk-vnc-0.7.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-vnc/gtk-vnc-0.7.2.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtk-vnc/gtk-vnc-0.7.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.7.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.7.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.7.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.7.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.7/gtk-vnc-0.7.2.tar.xz

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

./configure --prefix=/usr  \
            --with-gtk=3.0 \
            --enable-vala  \
            --without-sasl &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
