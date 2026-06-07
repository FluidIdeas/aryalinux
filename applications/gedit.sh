#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:libhandy1
#REQ:libxml2
#REQ:gspell
#REQ:iso-codes

cd $SOURCE_DIR
NAME=gedit
VERSION=48.1
URL=https://download.gnome.org/sources/gedit/48/gedit-48.1.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gedit/48/gedit-48.1.tar.xz


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

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root
grep -A5 Ok: *test.log
bash -e
for package in \
   libgedit-amtk-5.9.2.tar.bz2            \
   libgedit-gtksourceview-299.5.0.tar.bz2 \
   libgedit-gfls-0.3.1.tar.bz2            \
   libgedit-tepl-6.13.0.tar.bz2
do
  packagedir=${package%.tar*}

  echo "Building $packagedir"
  tar -xf ../$package
  pushd $packagedir
    cd build

    meson setup ..            \
          --prefix=/usr       \
          --buildtype=release \
          -D gtk_doc=false
    ninja

    #ninja test 2>&1 | tee ../../$packagedir-test.log

    as_root ninja install
  popd

  rm -rf $packagedir
done
exit
cd build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D gtk_doc=false
ninja
glib-compile-schemas /usr/share/glib-2.0/schemas


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