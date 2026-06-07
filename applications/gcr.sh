#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:glib2
#REQ:libgcrypt
#REQ:gnupg
#REQ:libsecret

cd $SOURCE_DIR
NAME=gcr
VERSION=3.41.2
URL=https://download.gnome.org/sources/gcr/3.41/gcr-3.41.2.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gcr/3.41/gcr-3.41.2.tar.xz


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

sed '/ssh.add/d; /ssh.agent/d' -i meson.build
sed -i 's:"/desktop:"/org:' schema/*.xml
mkdir build
cd    build
meson setup --prefix=/usr       \
            --buildtype=release \
            -D gtk_doc=false    \
            -D ssh_agent=false  \
            ..
ninja
sed -e "/install_dir/s@,\$@ / 'gcr-3.41.2'&@" \
    -i ../docs/*/meson.build
meson configure -D gtk_doc=true
ninja


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