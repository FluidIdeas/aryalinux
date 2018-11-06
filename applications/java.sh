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

URL=http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/OpenJDK-10.0.2+13-i686-bin.tar.xz

if [ ! -z $URL ]
then
wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/OpenJDK-10.0.2+13-i686-bin.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-i686-bin.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-i686-bin.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-i686-bin.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-i686-bin.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-i686-bin.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-i686-bin.tar.xz
wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/OpenJDK-10.0.2+13-x86_64-bin.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-x86_64-bin.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-x86_64-bin.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-x86_64-bin.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-x86_64-bin.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-x86_64-bin.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/OpenJDK-10.0.2+13-x86_64-bin.tar.xz

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/OpenJDK-10.0.2+13-bin &&
mv -v * /opt/OpenJDK-10.0.2+13-bin         &&
chown -R root:root /opt/OpenJDK-10.0.2+13-bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfn OpenJDK-10.0.2+13-bin /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
