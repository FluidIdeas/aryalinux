#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake


cd $SOURCE_DIR

wget -nc https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/llvm-8.0.1.src.tar.xz
wget -nc https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/cfe-8.0.1.src.tar.xz
wget -nc https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/compiler-rt-8.0.1.src.tar.xz


NAME=llvm
VERSION=8.0.1
URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/llvm-8.0.1.src.tar.xz

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


tar -xf ../cfe-8.0.1.src.tar.xz -C tools &&
tar -xf ../compiler-rt-8.0.1.src.tar.xz -C projects &&

mv tools/cfe-8.0.1.src tools/clang &&
mv projects/compiler-rt-8.0.1.src projects/compiler-rt
mkdir -v build &&
cd       build &&

CC=gcc CXX=g++                                  \
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_ENABLE_RTTI=ON                     \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -Wno-dev -G Ninja ..                      &&
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

