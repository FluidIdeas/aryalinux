#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Java is a platform independent Object oriented programming language"
SECTION="Programming Languages"
VERSION=1.8.0_112
NAME="oracle-java8"

#REQ:alsa-lib
#REQ:cups
#REQ:giflib


cd $SOURCE_DIR

URL=http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
wget -nc --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $URL
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

sudo tar xvf $TARBALL -C /opt &&
sudo chown -R root:root /opt/$DIRECTORY
sudo ln -svfn /opt/$DIRECTORY /opt/jdk

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


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
