#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="%DESCRIPTION%"
SECTION="general"
NAME="ojdk-conf"



cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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
cat > /etc/profile.d/openjdk.sh << "EOF"
# Begin /etc/profile.d/openjdk.sh
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
# End /etc/profile.d/openjdk.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/man_db.conf << "EOF" &&
# Begin Java addition
MANDATORY_MANPATH /opt/jdk/man
MANPATH_MAP /opt/jdk/bin /opt/jdk/man
MANDB_MAP /opt/jdk/man /var/cache/man/jdk
# End Java addition
EOF
mkdir -p /var/cache/man &&
mandb -c /opt/jdk/man

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
/usr/sbin/make-ca -g --force &&
ln -sfv /etc/ssl/java/cacerts.jks /opt/jdk/lib/security/cacerts

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
