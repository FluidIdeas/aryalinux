#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:python-modules#docutils

cd $SOURCE_DIR
NAME=glib2
VERSION=2.86.4
URL=https://download.gnome.org/sources/glib/2.86/glib-2.86.4.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/glib/2.86/glib-2.86.4.tar.xz


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

patch -Np1 -i ../glib-skip_warnings-1.patch
patch -Np1 -i ../glib-2.86.4-upstream_fixes-1.patch
mkdir build
cd    build
meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D introspection=disabled \
      -D glib_debug=disabled    \
      -D man-pages=enabled      \
      -D sysprof=disabled
ninja
tar xf ../../gobject-introspection-1.86.0.tar.xz
meson setup gobject-introspection-1.86.0 gi-build \
            --prefix=/usr --buildtype=release
ninja -C gi-build
meson configure -D introspection=enabled
ninja
sed "/docs_dir =/s|$| / 'glib-' + meson.project_version()|" \
    -i ../docs/reference/meson.build
meson configure -D documentation=true
ninja
if [ -e /usr/include/glib-2.0 ]; then
    rm -rf /usr/include/glib-2.0.old
mv -vf /usr/include/glib-2.0{,.old}
fi
ninja -C gi-build install


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd