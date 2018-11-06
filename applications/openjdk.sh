#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak OpenJDK is an open-sourcebr3ak implementation of Oracle's Java Standard Edition platform.br3ak OpenJDK is useful for developingbr3ak Java programs, and provides abr3ak complete runtime environment to run Java programs.br3ak"
SECTION="general"
VERSION=10.0.2+13
NAME="openjdk"

#REQ:java
#REQ:ojdk-conf
#REQ:alsa-lib
#REQ:cpio
#REQ:cups
#REQ:unzip
#REQ:general_which
#REQ:x7lib
#REQ:zip
#REC:make-ca
#REC:giflib
#REC:lcms2
#REC:libjpeg
#REC:libpng
#REC:wget
#OPT:graphviz
#OPT:mercurial
#OPT:twm


cd $SOURCE_DIR

URL=http://hg.openjdk.java.net/jdk-updates/jdk10u/archive/jdk-10.0.2+13.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://hg.openjdk.java.net/jdk-updates/jdk10u/archive/jdk-10.0.2+13.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jdk/jdk-10.0.2+13.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/jdk/jdk-10.0.2+13.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk-10.0.2+13.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk-10.0.2+13.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk-10.0.2+13.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk-10.0.2+13.tar.bz2
wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-10.0.2/jtreg-4.2-b13-433.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b13-433.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b13-433.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b13-433.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b13-433.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b13-433.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b13-433.tar.gz

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

tar -xf ../jtreg-4.2-b13-433.tar.gz


unset JAVA_HOME                             &&
bash configure --enable-unlimited-crypto    \
               --disable-warnings-as-errors \
               --with-stdc++lib=dynamic     \
               --with-giflib=system         \
               --with-jtreg=$PWD/jtreg      \
               --with-lcms=system           \
               --with-libjpeg=system        \
               --with-libpng=system         \
               --with-zlib=system           \
               --with-version-build="13"    \
               --with-version-pre=""        \
               --with-version-opt=""        \
               --with-cacerts-file=/etc/ssl/java/cacerts &&
make images


export JT_JAVA=$(echo $PWD/build/*/jdk) &&
jtreg/bin/jtreg -jdk:$JT_JAVA -automatic -ignore:quiet -v1 \
    test/jdk:tier1 test/langtools:tier1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/jdk-10.0.2+13             &&
cp -Rv build/*/images/jdk/* /opt/jdk-10.0.2+13 &&
chown -R root:root /opt/jdk-10.0.2+13          &&
for s in 16 24 32 48; do
  install -vDm644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/java.png
done &&
unset JT_JAVA

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -nsf jdk-10.0.2+13 /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
cat > /usr/share/applications/openjdk-java.desktop << "EOF" &&
[Desktop Entry]
Name=OpenJDK Java 10.0.2 Runtime
Comment=OpenJDK Java 10.0.2 Runtime
Exec=/opt/jdk/bin/java -jar
Terminal=false
Type=Application
Icon=java
MimeType=application/x-java-archive;application/java-archive;application/x-jar;
NoDisplay=true
EOF
cat > /usr/share/applications/openjdk-jconsole.desktop << "EOF"
[Desktop Entry]
Name=OpenJDK Java 10.0.2 Console
Comment=OpenJDK Java 10.0.2 Console
Keywords=java;console;monotoring
Exec=/opt/jdk/bin/jconsole
Terminal=false
Type=Application
Icon=java
Categories=Application;System;
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfv /etc/ssl/java/cacerts /opt/jdk/lib/security/cacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /opt/jdk
bin/keytool -list -cacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
