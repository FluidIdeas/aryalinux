#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:openjdk


cd $SOURCE_DIR



NAME=apache-ant
VERSION=1.9.14


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

version=1.9.14
wget https://www-us.apache.org/dist//ant/binaries/apache-ant-$version-bin.tar.bz2
dir=$(tar tf apache-ant-$version-bin.tar.bz2 | cut -d/ -f1 | uniq)
sudo tar xf apache-ant-$version-bin.tar.bz2 -C /opt/
sudo tee /etc/profile.d/ant.sh<<"EOF"
export PATH=$PATH:/opt/ant-dir/bin
EOF

sudo sed -i "s@ant-dir@$dir@g" /etc/profile.d/ant.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

