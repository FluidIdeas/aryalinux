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

URL=http://hg.openjdk.java.net/jdk-updates/jdk10u/archive/jdk-$VERSION.tar.bz2

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



sudo install -vdm755 /opt/jdk-$VERSION             &&
sudo cp -Rv build/*/images/jdk/* /opt/jdk-$VERSION &&
sudo chown -R root:root /opt/jdk-$VERSION          &&
sudo find /opt/jdk-$VERSION -name \*.diz -delete   &&
for s in 16 24 32 48; do
  sudo install -Dm 644 src/java.desktop/unix/classes/sun/awt/X11/java-icon${s}.png \
                  /usr/share/icons/hicolor/${s}x${s}/apps/java.png
done



sudo ln -v -nsf jdk-$VERSION /opt/jdk
sudo tee /etc/profile.d/jdk.sh << "EOF"
# Begin /etc/profile.d/jdk.sh

# Set JAVA_HOME directory
JAVA_HOME=/opt/jdk

# Adjust PATH
pathappend $JAVA_HOME/bin

# Add to MANPATH
pathappend $JAVA_HOME/man MANPATH

# Auto Java CLASSPATH: Copy jar files to, or create symlinks in, the
# /usr/share/java directory. Note that having gcj jars with OpenJDK 8
# may lead to errors.

AUTO_CLASSPATH_DIR=/usr/share/java

pathprepend . CLASSPATH

for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
    pathappend $dir CLASSPATH
done

for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do
    pathappend $jar CLASSPATH
done

export JAVA_HOME
unset AUTO_CLASSPATH_DIR dir jar

# End /etc/profile.d/jdk.sh
EOF

if ! grep '/opt/jdk/man' /etc/man_db.conf &> /dev/null; then

sudo tee -a /etc/man_db.conf << EOF &&
# Begin Java addition
MANDATORY_MANPATH     /opt/jdk/man
MANPATH_MAP           /opt/jdk/bin     /opt/jdk/man
MANDB_MAP             /opt/jdk/man     /var/cache/man/jdk
# End Java addition
EOF

fi

sudo mkdir -p /var/cache/man
sudo mandb -c /opt/jdk/man

sudo mkdir -pv /usr/share/applications &&
sudo tee /usr/share/applications/openjdk-java.desktop << "EOF" &&
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

sudo tee /usr/share/applications/openjdk-jconsole.desktop << "EOF"
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


sudo ln -sfv /etc/ssl/java/cacerts.jks /opt/jdk/lib/security/cacerts
sudo rm -rf OpenJDK-10.0.1+10-x86_64-bin



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
