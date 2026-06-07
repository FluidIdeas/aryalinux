#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:x7lib
#REQ:freeglut
#REQ:openjpeg2
#REQ:installing

cd $SOURCE_DIR
NAME=mupdf
VERSION=1.26.12
URL=https://www.mupdf.com/downloads/archive/mupdf-1.26.12-source.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.mupdf.com/downloads/archive/mupdf-1.26.12-source.tar.gz


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

cat > user.make << EOF
USE_SYSTEM_FREETYPE := yes
USE_SYSTEM_HARFBUZZ := yes
USE_SYSTEM_JBIG2DEC := no
USE_SYSTEM_JPEGXR := no # not used without HAVE_JPEGXR
USE_SYSTEM_LCMS2 := no # lcms2mt is strongly preferred
USE_SYSTEM_LIBJPEG := yes
USE_SYSTEM_MUJS := no # build needs source anyway
USE_SYSTEM_OPENJPEG := yes
USE_SYSTEM_ZLIB := yes
USE_SYSTEM_GLUT := yes
USE_SYSTEM_CURL := yes
USE_SYSTEM_GUMBO := no
EOF

export XCFLAGS=-fPIC
make build=release shared=yes verbose=yes
unset XCFLAGS
make prefix=/usr                         \
     shared=yes                          \
     docdir=/usr/share/doc/mupdf-1.26.12 \
     install
ln -sfv libmupdf.so.26.12 /usr/lib/libmupdf.so.26
ln -sfv libmupdf.so.26   /usr/lib/libmupdf.so
chmod 755 /usr/lib/libmupdf.so.26.12
ln -sfv mupdf-x11 /usr/bin/mupdf

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd