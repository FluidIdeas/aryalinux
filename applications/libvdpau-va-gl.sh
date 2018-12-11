#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cmake
#REQ:ffmpeg
#OPT:doxygen
#OPT:graphviz
#OPT:texlive
#OPT:tl-installer
#OPT:mesa

cd $SOURCE_DIR

wget -nc https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0/libvdpau-va-gl-0.4.0.tar.gz

URL=https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0/libvdpau-va-gl-0.4.0.tar.gz

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

mkdir build &&
cd    build &&

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$XORG_PREFIX .. &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
echo "export VDPAU_DRIVER=va_gl" &gt;&gt; /etc/profile.d/xorg.sh
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
