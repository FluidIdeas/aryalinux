#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#REQ:gnutls
#REQ:gsettings-desktop-schemas
#REC:make-ca
#REC:p11-kit

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.58/glib-networking-2.58.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib-networking/2.58/glib-networking-2.58.0.tar.xz

NAME=glib-networking
VERSION=2.58.0
URL=http://ftp.gnome.org/pub/gnome/sources/glib-networking/2.58/glib-networking-2.58.0.tar.xz

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

mkdir build &&
cd build &&

meson --prefix=/usr \
-Dlibproxy_support=false \
-Dpkcs11_support=true .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/profile.d/gio.sh << "EOF"
<code class="literal"># Begin gio.sh

export GIO_USE_TLS=gnutls-pkcs11

# End gio.sh</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
