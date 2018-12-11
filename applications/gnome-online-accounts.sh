#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.28/gnome-online-accounts-3.28.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.28/gnome-online-accounts-3.28.0.tar.xz

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-online-accounts/3.28/gnome-online-accounts-3.28.0.tar.xz

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

./configure --prefix=/usr \
            --disable-static \
            --with-google-client-secret=5ntt6GbbkjnTVXx-MSxbmx5e \
            --with-google-client-id=595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
