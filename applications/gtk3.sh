#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:at-spi2-atk
#REQ:gdk-pixbuf
#REQ:libepoxy
#REQ:pango
#REQ:six
#REC:adwaita-icon-theme
#REC:hicolor-icon-theme
#REC:iso-codes
#REC:libxkbcommon
#REC:wayland
#REC:wayland-protocols
#REC:gobject-introspection
#OPT:colord
#OPT:cups
#OPT:docbook-utils
#OPT:json-glib
#OPT:pyatspi2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.2.tar.xz

NAME=gtk3
VERSION=""
URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.2.tar.xz

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

sed -i 's/dfeault/default/' docs/tools/shooter.c &&

./configure --prefix=/usr \
--sysconfdir=/etc \
--enable-broadway-backend \
--enable-x11-backend \
--enable-wayland-backend &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
gtk-query-immodules-3.0 --update-cache
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir -vp ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << "EOF"
<code class="literal">[Settings]
gtk-theme-name = <em class="replaceable"><code>Adwaita</code></em>
gtk-icon-theme-name = <em class="replaceable"><code>oxygen</code></em>
gtk-font-name = <em class="replaceable"><code>DejaVu Sans 12</code></em>
gtk-cursor-theme-size = <em class="replaceable"><code>18</code></em>
gtk-toolbar-style = <em class="replaceable"><code>GTK_TOOLBAR_BOTH_HORIZ</code></em>
gtk-xft-antialias = <em class="replaceable"><code>1</code></em>
gtk-xft-hinting = <em class="replaceable"><code>1</code></em>
gtk-xft-hintstyle = <em class="replaceable"><code>hintslight</code></em>
gtk-xft-rgba = <em class="replaceable"><code>rgb</code></em>
gtk-cursor-theme-name = <em class="replaceable"><code>Adwaita</code></em></code>
EOF

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
