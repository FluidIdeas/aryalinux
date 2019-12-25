#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl
#REQ:cmake
#REQ:libssh2


cd $SOURCE_DIR

wget -nc https://static.rust-lang.org/dist/rustc-1.37.0-src.tar.gz


NAME=rust
VERSION=1.37.0
URL=https://static.rust-lang.org/dist/rustc-1.37.0-src.tar.gz

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

sudo mkdir /opt/rustc-1.37.0             &&
sudo ln -svfin rustc-1.37.0 /opt/rustc

cat > config.toml << EOF
[llvm]
link-shared = true

[build]
docs = false
extended = true

[install]
prefix = "/opt/rustc-1.37.0"
docdir = "share/doc/rustc-1.37.0"

[rust]
channel = "stable"
rpath = false
codegen-tests = false
EOF

export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
python3 ./x.py build --exclude src/tools/miri

export LIBSSH2_SYS_USE_PKG_CONFIG=1 &&
DESTDIR=${PWD}/install python3 ./x.py install &&
unset LIBSSH2_SYS_USE_PKG_CONFIG

sudo chown -R root:root install &&
sudo cp -a install/* /

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

if [ -d $HOME/.cargo ]; then
       rm -rf $HOME/.cargo
fi



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

