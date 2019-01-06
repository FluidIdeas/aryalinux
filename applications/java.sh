#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:alsa-lib
#REQ:cups
#REQ:giflib
#REQ:x7lib

cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/OpenJDK-10.0.2+13-i686-bin.tar.xz
wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/OpenJDK-10.0.2+13-x86_64-bin.tar.xz

NAME=java
VERSION=10.0.2+13-i686-bin
URL=http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/OpenJDK-10.0.2+13-i686-bin.tar.xz

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
cat > /tmp/rootscript.sh <<"EOF"
install -vdm755 /opt/OpenJDK-10.0.2+13-bin &&
mv -v * /opt/OpenJDK-10.0.2+13-bin &&
chown -R root:root /opt/OpenJDK-10.0.2+13-bin
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ln -sfn OpenJDK-10.0.2+13-bin /opt/jdk
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
