#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cmake
#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen

cd $SOURCE_DIR

wget -nc https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/openjpeg-2.3.0-only_shared-1.patch

URL=https://github.com/uclouvain/openjpeg/archive/v2.3.0/openjpeg-2.3.0.tar.gz

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

patch -Np1 -i ../openjpeg-2.3.0-only_shared-1.patch &&

mkdir -v build &&
cd       build &&

cmake -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DBUILD_STATIC_LIBS=OFF .. &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&

pushd ../doc &&
  for man in man/man?/* ; do
      install -v -D -m 644 $man /usr/share/$man
  done 
popd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
