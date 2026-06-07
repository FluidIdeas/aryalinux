#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:alsa-lib

cd $SOURCE_DIR
NAME=cdrtools
VERSION=3.02a09
URL=https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2


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

sed -i 's|/opt/schily|/usr|g'           DEFAULTS/Defaults.linux
sed -i 's|DEFINSGRP=.*|DEFINSGRP=root|' DEFAULTS/Defaults.linux
sed -i 's|INSDIR=\s*sbin|INSDIR=bin|'   rscsi/Makefile
export GMAKE_NOWARN=true
export CFLAGS="$CFLAGS -std=gnu89 -fno-strict-aliasing"
make -j1 INS_BASE=/usr  \
         DEFINSUSR=root \
         DEFINSGRP=root \
         VERSION_OS="LinuxFromScratch"
GMAKE_NOWARN=true
make INS_BASE=/usr    \
     DEFINSUSR=root   \
     DEFINSGRP=root   \
     MANSUFF_LIB=3cdr \
     install


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/cdrtools-3.02a09
install -v -m644 README.* READMEs/* ABOUT doc/*.ps \
                    /usr/share/doc/cdrtools-3.02a09
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd