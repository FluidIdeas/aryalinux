#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:icu

cd $SOURCE_DIR
NAME=libxml2
VERSION=2.15.1
URL=https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libxml2/2.15/libxml2-2.15.1.tar.xz


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

sed -i "/'git'/,+3d" meson.build
mkdir build
cd    build
meson setup ..           \
      --prefix=/usr      \
      -D history=enabled \
      -D icu=enabled
ninja
sed -e "/^dir_doc/s/\$/ + '-' + meson.project_version()/" \
    -i ../meson.build
meson configure -D docs=enabled
ninja
tar xf ../../xmlts20130923.tar.gz -C ..
systemctl stop httpd.service
sed "s/--static/--shared/" -i /usr/bin/xml2-config


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