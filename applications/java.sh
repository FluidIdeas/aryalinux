#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:alsa-lib
#REQ:cups
#REQ:giflib
#REQ:x7lib


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-11.0.2/OpenJDK-11.0.2+9-i686-bin.tar.xz
wget -nc https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_linux-x64_bin.tar.gz


NAME=java
VERSION=11.0.
URL=http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-11.0.2/OpenJDK-11.0.2+9-i686-bin.tar.xz
SECTION="General Libraries and Utilities"
DESCRIPTION="Creating a JVM from source requires a set of circular dependencies. The first thing that's needed is a set of programs called a Java Development Kit (JDK). This set of programs includes java, javac, jar, and several others. It also includes several base jar files."

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /opt/OpenJDK-12.0.2+10-bin &&
mv -v * /opt/OpenJDK-12.0.2+10-bin         &&
chown -R root:root /opt/OpenJDK-12.0.2+10-bin
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -sfn OpenJDK-12.0.2+10-bin /opt/jdk
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

