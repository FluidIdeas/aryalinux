#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:java#java-bin
#REQ:openjdk
#REQ:glib2

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/ant/source/apache-ant-1.10.4-src.tar.xz

URL=https://archive.apache.org/dist/ant/source/apache-ant-1.10.4-src.tar.xz

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

./bootstrap.sh
bootstrap/bin/ant -f fetch.xml -Ddest=system &&
cp -v lib/*.jar lib/optional/
./build.sh -Ddist.dir=$PWD/ant-1.10.4 dist

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cp -rv ant-1.10.4 /opt/            &&
chown -R root:root /opt/ant-1.10.4 &&
ln -sfv ant-1.10.4 /opt/ant
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/profile.d/ant.sh << EOF
<code class="literal"># Begin /etc/profile.d/ant.sh pathappend /opt/ant/bin export ANT_HOME=/opt/ant # End /etc/profile.d/ant.sh</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
