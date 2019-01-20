#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:curl
#REQ:cmake
#REQ:libssh2
#REQ:python2
#REC:llvm
#OPT:gdb

cd $SOURCE_DIR

wget -nc https://static.rust-lang.org/dist/rustc-1.29.2-src.tar.gz

NAME=rust
VERSION=src
URL=https://static.rust-lang.org/dist/rustc-1.29.2-src.tar.gz

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

cat << EOF > config.toml
# see config.toml.example for more possible options
[llvm]
targets = "X86"

# When using system llvm prefer shared libraries
link-shared = true

[build]
# install cargo as well as rust
extended = true

[install]
prefix = "/usr"
docdir = "share/doc/rustc-1.29.2"

[rust]
channel = "stable"
rpath = false

# BLFS does not install the FileCheck executable from llvm,
# so disable codegen tests
codegen-tests = false

[target.x86_64-unknown-linux-gnu]
# delete this *section* if you are not using system llvm.
# NB the output of llvm-config (i.e. help options) may be
# dumped to the screen when config.toml is parsed.
llvm-config = "/usr/bin/llvm-config"

EOF
export RUSTFLAGS="$RUSTFLAGS -C link-args=-lffi" &&
./x.py build
export LIBSSH2_SYS_USE_PKG_CONFIG=1 &&
DESTDIR=${PWD}/install ./x.py install &&
unset LIBSSH2_SYS_USE_PKG_CONFIG

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
chown -R root:root install &&
cp -a install/* /
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
