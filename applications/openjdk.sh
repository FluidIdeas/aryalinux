#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:java
#REQ:ojdk-conf
#REQ:libarchive
#REQ:x7lib
#REQ:zip
#REQ:make-ca
#REQ:harfbuzz
#REQ:libjpeg
#REQ:libpng
#REQ:wget

cd $SOURCE_DIR
NAME=openjdk
VERSION=21.0.10
URL=https://github.com/openjdk/jdk21u/archive/jdk-21.0.10-ga.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/openjdk/jdk21u/archive/jdk-21.0.10-ga.tar.gz


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

tar -xf ../jtreg-8.2.1+1.tar.gz
export MAKEFLAGS_HOLD=$MAKEFLAGS
unset  JAVA_HOME
unset  CLASSPATH
unset  MAKEFLAGS
bash configure --enable-unlimited-crypto    \
               --disable-warnings-as-errors \
               --with-stdc++lib=dynamic     \
               --with-giflib=system         \
               --with-harfbuzz=system       \
               --with-jtreg=$PWD/jtreg      \
               --with-lcms=system           \
               --with-libjpeg=system        \
               --with-libpng=system         \
               --with-zlib=system           \
               --with-version-build="6"    \
               --with-version-pre=""        \
               --with-version-opt=""        \
               --with-jobs=$(nproc)         \
               --with-cacerts-file=/etc/pki/tls/java/cacerts
make images
export JT_JAVA=$(echo $PWD/build/*/jdk)
jtreg/bin/jtreg -jdk:$JT_JAVA -automatic -ignore:quiet -v1 \
    test/jdk:tier1 test/langtools:tier1
unset JT_JAVA
export MAKEFLAGS=$MAKEFLAGS_HOLD
unset  MAKEFLAGS_HOLD
cp -Rv build/*/images/jdk/* /opt/jdk-21.0.10+6
chown -R root:root /opt/jdk-21.0.10+6
for s in 16 24 32 48; do
  install -vDm644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/java.png
done
find /opt/jdk-21.0.10+6 -name *.debuginfo -delete
ln -v -nsf jdk-21.0.10+6 /opt/jdk
mkdir -pv /usr/share/applications
cat > /usr/share/applications/openjdk-java.desktop << "EOF"
[Desktop Entry]
Name=OpenJDK Java 21.0.10 Runtime
Comment=OpenJDK Java 21.0.10 Runtime
Exec=/opt/jdk/bin/java -jar
Terminal=false
Type=Application
Icon=java
MimeType=application/x-java-archive;application/java-archive;application/x-jar;
NoDisplay=true
EOF
cat > /usr/share/applications/openjdk-jconsole.desktop << "EOF"
[Desktop Entry]
Name=OpenJDK Java 21.0.10 Console
Comment=OpenJDK Java 21.0.10 Console
Keywords=java;console;monitoring
Exec=/opt/jdk/bin/jconsole
Terminal=false
Type=Application
Icon=java
Categories=Application;System;
EOF
ln -sfv /etc/pki/tls/java/cacerts /opt/jdk/lib/security/cacerts
cd /opt/jdk
bin/keytool -list -cacerts


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /opt/jdk-21.0.10+6
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd