#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="The Java programming language is a versatile multi-platform supporting programming language."
SECTION="general"
VERSION=10.0.2+13
NAME="openjdk10"

#REQ:java
#REQ:java10
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

sudo /usr/sbin/make-ca -g --force &&
sudo ln -sfv /etc/ssl/java/cacerts.jks /opt/jdk/lib/security/cacerts
unset JAVA_HOME                             &&
bash configure --enable-unlimited-crypto    \
               --disable-warnings-as-errors \
               --with-stdc++lib=dynamic     \
               --with-giflib=system         \
               --with-lcms=system           \
               --with-libjpeg=system        \
               --with-libpng=system         \
               --with-zlib=system           \
               --with-version-build="10"    \
               --with-version-pre=""        \
               --with-version-opt=""        \
               --with-cacerts-file=/etc/ssl/java/cacerts.jks
make images



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /opt/jdk-10.0.1+10             &&
cp -Rv build/*/images/jdk/* /opt/jdk-10.0.1+10 &&
chown -R root:root /opt/jdk-10.0.1+10          &&
find /opt/jdk-10.0.1+10 -name \*.diz -delete   &&
for s in 16 24 32 48; do
  install -Dm 644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/java.png
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -nsf jdk-10.0.1+10 /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
cat > /usr/share/applications/openjdk-java.desktop << "EOF" &&
[Desktop Entry]
Name=OpenJDK Java 10.0.1 Runtime
Comment=OpenJDK Java 10.0.1 Runtime
Exec=/opt/jdk/bin/java -jar
Terminal=false
Type=Application
Icon=java
MimeType=application/x-java-archive;application/java-archive;application/x-jar;
NoDisplay=true
EOF
cat > /usr/share/applications/openjdk-jconsole.desktop << "EOF"
[Desktop Entry]
Name=OpenJDK Java 10.0.1 Console
Comment=OpenJDK Java 10.0.1 Console
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
ln -sfv /etc/ssl/java/cacerts.jks /opt/jdk/lib/security/cacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rf OpenJDK-10.0.1+10-x86_64-bin
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
