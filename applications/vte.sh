#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libxml2
#REQ:fast_float
#REQ:icu
#REQ:gnutls
#REQ:gtk3
#REQ:vala

cd $SOURCE_DIR
NAME=vte
VERSION=0.82.3
URL=https://gitlab.gnome.org/GNOME/vte/-/archive/0.82.3/vte-0.82.3.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.gnome.org/GNOME/vte/-/archive/0.82.3/vte-0.82.3.tar.gz


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser

mkdir build
cd    build
meson setup --prefix=/usr --buildtype=release ..
ninja
sed -e "/docdir =/s@\$@/ 'vte-0.82.3'@" \
    -i ../doc/reference/meson.build
meson configure -D docs=true
ninja
rm -v /etc/profile.d/vte.*


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd