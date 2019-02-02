#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:cups
#REC:fontconfig
#REC:freetype2
#REC:libjpeg
#REC:libpng
#REC:libtiff
#REC:lcms2

cd $SOURCE_DIR

wget -nc https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26.tar.gz
wget -nc https://downloads.sourceforge.net/gs-fonts/ghostscript-fonts-std-8.11.tar.gz
wget -nc https://downloads.sourceforge.net/gs-fonts/gnu-gs-fonts-other-6.0.tar.gz

NAME=gs
VERSION=9.26
URL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26.tar.gz

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

rm -rf freetype lcms2mt jpeg libpng
rm -rf zlib &&

./configure --prefix=/usr \
--disable-compile-inits \
--enable-dynamic \
--with-system-libtiff &&
make
make so

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make soinstall &&
install -v -m644 base/*.h /usr/include/ghostscript &&
ln -sfvn ghostscript /usr/include/ps
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -sfvn ../ghostscript/9.26/doc /usr/share/doc/ghostscript-9.26 &&
cp -a examples/ /usr/share/ghostscript/9.26/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf ../ghostscript-fonts-std-8.11.tar.gz -C /usr/share/ghostscript --no-same-owner &&
tar -xvf ../gnu-gs-fonts-other-6.0.tar.gz -C /usr/share/ghostscript --no-same-owner &&
fc-cache -v /usr/share/ghostscript/fonts/
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
