#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:db
#REQ:gcr
#REQ:libical
#REQ:libsecret
#REQ:nss
#REQ:python2
#REQ:sqlite
#REC:gnome-online-accounts
#REC:gobject-introspection
#REC:gtk3
#REC:icu
#REC:libgdata
#REC:libgweather
#REC:vala
#OPT:gtk-doc
#OPT:mitkrb
#OPT:mail
#OPT:openldap

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.28/evolution-data-server-3.28.5.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.28/evolution-data-server-3.28.5.tar.xz

NAME=evolution-data-server
VERSION=3.28.5
URL=http://ftp.gnome.org/pub/gnome/sources/evolution-data-server/3.28/evolution-data-server-3.28.5.tar.xz

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
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr   \
      -DENABLE_UOA=OFF              \
      -DENABLE_VALA_BINDINGS=ON     \
      -DENABLE_INSTALLED_TESTS=ON   \
      -DENABLE_GOOGLE=ON            \
      -DENABLE_GOOGLE_AUTH=OFF      \
      -DWITH_OPENLDAP=OFF           \
      -DWITH_KRB5=OFF               \
      -DENABLE_INTROSPECTION=ON     \
      -DENABLE_GTK_DOC=OFF          \
      .. &&
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
