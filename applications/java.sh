#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Creating a JVM from source requires a set of circular dependencies.br3ak The first thing that's needed is a set of programs called a Javabr3ak Development Kit (JDK). This set of programs includes <span class=\"command\"><strong>java</strong>, <span class=\"command\"><strong>javac</strong>, <span class=\"command\"><strong>jar</strong>, and several others. It alsobr3ak includes several base <span class=\"emphasis\"><em>jar</em>br3ak files.br3ak"
SECTION="general"
VERSION=686
NAME="java"

#REQ:alsa-lib
#REQ:cups
#REQ:giflib
#REQ:x7lib


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-1.8.0.141/OpenJDK-1.8.0.141-$(uname -m)-bin.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo install -vdm755 /opt/$DIRECTORY &&
sudo mv -v * /opt/$DIRECTORY         &&
sudo chown -R root:root /opt/$DIRECTORY
sudo ln -svfn $DIRECTORY /opt/jdk
sudo tee /etc/profile.d/openjdk.sh<<EOF
export JAVA_HOME=/opt/jdk
export PATH=$JAVA_HOME/bin
EOF

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
