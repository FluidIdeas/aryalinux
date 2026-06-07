#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:java
#REQ:glib2

cd $SOURCE_DIR
NAME=apache-ant
VERSION=1.10.15
URL=https://archive.apache.org/dist/ant/source/apache-ant-1.10.15-src.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.apache.org/dist/ant/source/apache-ant-1.10.15-src.tar.xz


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

./bootstrap.sh
bootstrap/bin/ant -f fetch.xml -Ddest=optional
./build.sh -Ddist.dir=$PWD/ant-1.10.15 dist
cp -rv ant-1.10.15 /opt/
chown -R root:root /opt/ant-1.10.15
ln -sfv ant-1.10.15 /opt/ant
cat > /etc/profile.d/ant.sh << EOF
# Begin /etc/profile.d/ant.sh

pathappend /opt/ant/bin
export ANT_HOME=/opt/ant

# End /etc/profile.d/ant.sh
EOF

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd