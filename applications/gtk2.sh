#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GTK+ 2 package containsbr3ak libraries used for creating graphical user interfaces forbr3ak applications.br3ak"
SECTION="x"
VERSION=2.24.32
NAME="gtk2"

#REQ:atk
#REQ:gdk-pixbuf
#REQ:pango
#REC:hicolor-icon-theme
#OPT:cups
#OPT:docbook-utils
#OPT:gobject-introspection
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk+/gtk+-2.24.32.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gtk+/gtk+-2.24.32.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-2.24.32.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk+/gtk+-2.24.32.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-2.24.32.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk+/gtk+-2.24.32.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz

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

sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in      &&
./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-query-immodules-2.0 --update-cache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.gtkrc-2.0 << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Glider</em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>hicolor</em>"
EOF



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/<em class="replaceable"><code>Clearlooks</em>/gtk-2.0/gtkrc"
gtk-icon-theme-name = "<em class="replaceable"><code>elementary</em>"
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
