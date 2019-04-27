#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2.0/gpm-1.20.7-glibc_2.26-1.patch

NAME=gpm
VERSION=1.20.7
URL=http://anduin.linuxfromscratch.org/BLFS/gpm/gpm-1.20.7.tar.bz2

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

sed -i -e 's:<gpm.h>:"headers/gpm.h":' src/prog/{display-buttons,display-coords,get-versions}.c &&
patch -Np1 -i ../gpm-1.20.7-glibc_2.26-1.patch &&
./autogen.sh &&
./configure --prefix=/usr --sysconfdir=/etc &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install-info --dir-file=/usr/share/info/dir \
/usr/share/info/gpm.info &&

ln -sfv libgpm.so.2.1.0 /usr/lib/libgpm.so &&
install -v -m644 conf/gpm-root.conf /etc &&

install -v -m755 -d /usr/share/doc/gpm-1.20.7/support &&
install -v -m644 doc/support/* \
/usr/share/doc/gpm-1.20.7/support &&
install -v -m644 doc/{FAQ,HACK_GPM,README*} \
/usr/share/doc/gpm-1.20.7
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-gpm
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /etc/systemd/system/gpm.service.d
echo "ExecStart=/usr/sbin/gpm <list of parameters>" > /etc/systemd/system/gpm.service.d/99-user.conf
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
