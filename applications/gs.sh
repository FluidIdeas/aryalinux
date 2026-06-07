#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cups
#REQ:libjpeg
#REQ:libpng
#REQ:openjpeg2

cd $SOURCE_DIR
NAME=gs
VERSION=10.06.0
URL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10060/ghostscript-10.06.0.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs10060/ghostscript-10.06.0.tar.xz


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

rm -rf freetype lcms2mt jpeg libpng openjpeg
rm -rf zlib
./configure --prefix=/usr           \
            --disable-compile-inits \
            --with-system-libtiff   \
            CFLAGS="${CFLAGS:--g -O3} -fPIC"
make
make so
gs -q -dBATCH /usr/share/ghostscript/10.06.0/examples/tiger.eps
make soinstall
ln -sfvn ghostscript /usr/include/ps
mv -v /usr/share/doc/ghostscript/10.06.0 /usr/share/doc/ghostscript-10.06.0
rmdir /usr/share/doc/ghostscript
cp -r examples/ -T /usr/share/ghostscript/10.06.0/examples
tar -xvf ../ghostscript-fonts-std-8.11.tar.gz -C /usr/share/ghostscript --no-same-owner
tar -xvf ../gnu-gs-fonts-other-6.0.tar.gz     -C /usr/share/ghostscript --no-same-owner
fc-cache -v /usr/share/ghostscript/fonts/


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m644 base/*.h /usr/include/ghostscript
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd