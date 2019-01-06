#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cmake
#OPT:doxygen
#OPT:graphviz
#OPT:libxml2
#OPT:python2
#OPT:texlive
#OPT:tl-installer
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
cd       build &&

CC=gcc CXX=g++                                  \
cmake -DCMAKE_INSTALL_PREFIX=/usr               \
      -DLLVM_ENABLE_FFI=ON                      \
      -DCMAKE_BUILD_TYPE=Release                \
      -DLLVM_BUILD_LLVM_DYLIB=ON                \
      -DLLVM_LINK_LLVM_DYLIB=ON                 \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
      -DLLVM_BUILD_TESTS=ON                     \
      -Wno-dev -G Ninja ..                      &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

cmake -DLLVM_ENABLE_SPHINX=ON         \
      -DSPHINX_WARNINGS_AS_ERRORS=OFF \
      -Wno-dev -G Ninja ..            &&
ninja docs-llvm-html  docs-llvm-man
ninja docs-clang-html docs-clang-man

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 docs/man/* /usr/share/man/man1             &&
install -v -d -m755 /usr/share/doc/llvm-7.0.1/llvm-html     &&
cp -Rv docs/html/* /usr/share/doc/llvm-7.0.1/llvm-html
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m644 tools/clang/docs/man/* /usr/share/man/man1 &&
install -v -d -m755 /usr/share/doc/llvm-7.0.1/clang-html    &&
cp -Rv tools/clang/docs/html/* /usr/share/doc/llvm-7.0.1/clang-html
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
