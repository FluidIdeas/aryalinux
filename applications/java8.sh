#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Creating a JVM from source requires a set of circular dependencies.br3ak The first thing that's needed is a set of programs called a Javabr3ak Development Kit (JDK). This set of programs includes <span class=\"command\"><strong>java</strong>, <span class=\"command\"><strong>javac</strong>, <span class=\"command\"><strong>jar</strong>, and several others. It alsobr3ak includes several base <span class=\"emphasis\"><em>jar</em>br3ak files.br3ak"
SECTION="Programming Languages"
VERSION=1.8.0.112
NAME="java8"

#REQ:alsa-lib
#REQ:cups
#REQ:giflib
#REQ:x7lib


cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2016.11/OpenJDK-1.8.0.112-x86_64-bin.tar.xz
wget -nc $URL

sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
DIR=$(tar tf OpenJDK-1.8.0.112-x86_64-bin.tar.xz | cut -d/ -f1 | uniq)
tar xf OpenJDK-1.8.0.112-x86_64-bin.tar.xz -C /opt &&
chown -R root:root /opt/$DIR
ln -sfn /opt/$DIR /opt/jdk

cat > /etc/profile.d/jdk.sh << "EOF"
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

cat >> /etc/man_db.conf << "EOF" &&
# Begin Java addition
MANDATORY_MANPATH     /opt/jdk/man
MANPATH_MAP           /opt/jdk/bin     /opt/jdk/man
MANDB_MAP             /opt/jdk/man     /var/cache/man/jdk
# End Java addition
EOF

mkdir -p /var/cache/man
mandb -c /opt/jdk/man

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
