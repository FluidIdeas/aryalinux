#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#OPT:libtiff
#OPT:libjpeg
#OPT:python2
#OPT:swig

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lcms-1.19-cve_2013_4276-1.patch

NAME=lcms
VERSION=1.19
URL=https://downloads.sourceforge.net/lcms/lcms-1.19.tar.gz

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

patch -Np1 -i ../lcms-1.19-cve_2013_4276-1.patch &&

./configure --prefix=/usr --disable-static       &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m755 -d /usr/share/doc/lcms-1.19 &&
install -v -m644    README.1ST doc/* \
                    /usr/share/doc/lcms-1.19
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
