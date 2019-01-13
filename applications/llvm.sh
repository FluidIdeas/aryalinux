#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:cmake
#OPT:doxygen
#OPT:graphviz
#OPT:libxml2
#OPT:python2
#OPT:texlive
#OPT:valgrind
#OPT:zip

cd $SOURCE_DIR

wget -nc http://llvm.org/releases/7.0.1/llvm-7.0.1.src.tar.xz
wget -nc http://llvm.org/releases/7.0.1/cfe-7.0.1.src.tar.xz
wget -nc http://llvm.org/releases/7.0.1/compiler-rt-7.0.1.src.tar.xz

NAME=llvm
VERSION=7.0.1.src
URL=http://llvm.org/releases/7.0.1/llvm-7.0.1.src.tar.xz

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

tar -xf ../cfe-7.0.1.src.tar.xz -C tools &&
tar -xf ../compiler-rt-7.0.1.src.tar.xz -C projects &&

mv tools/cfe-7.0.1.src tools/clang &&
mv projects/compiler-rt-7.0.1.src projects/compiler-rt
mkdir -v build &&
cd build &&

CC=gcc CXX=g++ \
cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DLLVM_ENABLE_FFI=ON \
-DCMAKE_BUILD_TYPE=Release \
-DLLVM_BUILD_LLVM_DYLIB=ON \
-DLLVM_LINK_LLVM_DYLIB=ON \
-DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
-DLLVM_BUILD_TESTS=ON \
-Wno-dev -G Ninja .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
