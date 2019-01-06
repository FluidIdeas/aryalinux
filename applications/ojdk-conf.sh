#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


cd $SOURCE_DIR


NAME=ojdk-conf
VERSION=""
URL=""

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/profile.d/openjdk.sh << "EOF"
<code class="literal"># Begin /etc/profile.d/openjdk.sh # Set JAVA_HOME directory JAVA_HOME=/opt/jdk # Adjust PATH pathappend $JAVA_HOME/bin # Add to MANPATH pathappend $JAVA_HOME/man MANPATH # Auto Java CLASSPATH: Copy jar files to, or create symlinks in, the # /usr/share/java directory. Note that having gcj jars with OpenJDK 8 # may lead to errors. AUTO_CLASSPATH_DIR=/usr/share/java pathprepend . CLASSPATH for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do pathappend $dir CLASSPATH done for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do pathappend $jar CLASSPATH done export JAVA_HOME unset AUTO_CLASSPATH_DIR dir jar # End /etc/profile.d/openjdk.sh</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/sudoers.d/java << "EOF"
<code class="literal">Defaults env_keep += JAVA_HOME Defaults env_keep += CLASSPATH</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/man_db.conf << "EOF" &&
<code class="literal"># Begin Java addition MANDATORY_MANPATH /opt/jdk/man MANPATH_MAP /opt/jdk/bin /opt/jdk/man MANDB_MAP /opt/jdk/man /var/cache/man/jdk # End Java addition</code>
EOF

mkdir -p /var/cache/man &&
mandb -c /opt/jdk/man
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
/usr/sbin/make-ca -g --force &&
ln -sfv /etc/pki/tls/java/cacerts /opt/jdk/lib/security/cacerts
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cd /opt/jdk
bin/keytool -list -cacerts
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
