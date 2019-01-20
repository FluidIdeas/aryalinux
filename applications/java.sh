#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:alsa-lib
#REQ:cups
#REQ:giflib
#REQ:x7lib

cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-11.0.2/OpenJDK-11.0.2+7-i686-bin.tar.xz
wget -nc https://download.java.net/java/GA/jdk11/7/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

NAME=java
VERSION=bin
URL=http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-11.0.2/OpenJDK-11.0.2+7-i686-bin.tar.xz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /opt/OpenJDK-11.0.2+7-bin &&
mv -v * /opt/OpenJDK-11.0.2+7-bin &&
chown -R root:root /opt/OpenJDK-11.0.2+7-bin
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -sfn OpenJDK-11.0.2+7-bin /opt/jdk
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
