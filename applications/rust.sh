#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl
#REQ:cmake
#REQ:libssh2
#REQ:llvm


cd $SOURCE_DIR



NAME=rust
VERSION=1.37.0

SECTION="Programming"
DESCRIPTION="The Rust programming language is designed to be a safe, concurrent, practical language."

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

wget -nc http://aryalinux.info/files/2.4/rust-1.37.0-x86_64.tar.gz

sudo tar xf rust-1.37.0-x86_64.tar.gz -C /

sudo tee -a /etc/ld.so.conf << EOF
# Begin rustc addition

/opt/rustc/lib

# End rustc addition
EOF

sudo ldconfig

sudo tee /etc/profile.d/rustc.sh << "EOF"
# Begin /etc/profile.d/rustc.sh

pathprepend /opt/rustc/bin           PATH

# End /etc/profile.d/rustc.sh
EOF



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

