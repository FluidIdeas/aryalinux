#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LLVM package contains abr3ak collection of modular and reusable compiler and toolchainbr3ak technologies. The Low Level Virtual Machine (LLVM) Core librariesbr3ak provide a modern source and target-independent optimizer, alongbr3ak with code generation support for many popular CPUs (as well as somebr3ak less common ones!). These libraries are built around a wellbr3ak specified code representation known as the LLVM intermediatebr3ak representation (\"LLVM IR\").br3ak"
SECTION="general"
VERSION=7.0.0
NAME="llvm"

#REQ:cmake
#REQ:python2
#OPT:doxygen
#OPT:graphviz
#OPT:libxml2
#OPT:texlive
#OPT:tl-installer
#OPT:valgrind
#OPT:zip


cd $SOURCE_DIR

URL=http://llvm.org/releases/7.0.0/llvm-7.0.0.src.tar.xz

if [ ! -z $URL ]
then
wget -nc http://llvm.org/releases/7.0.0/llvm-7.0.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/llvm-7.0.0.src.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/llvm/llvm-7.0.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-7.0.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/llvm-7.0.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-7.0.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/llvm-7.0.0.src.tar.xz
wget -nc http://llvm.org/releases/7.0.0/cfe-7.0.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/llvm/cfe-7.0.0.src.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/llvm/cfe-7.0.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-7.0.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/llvm/cfe-7.0.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-7.0.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/llvm/cfe-7.0.0.src.tar.xz
wget -nc http://llvm.org/releases/7.0.0/compiler-rt-7.0.0.src.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compiler-rt/compiler-rt-7.0.0.src.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/compiler-rt/compiler-rt-7.0.0.src.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-7.0.0.src.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compiler-rt/compiler-rt-7.0.0.src.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-7.0.0.src.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compiler-rt/compiler-rt-7.0.0.src.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

tar -xf ../cfe-7.0.0.src.tar.xz -C tools &&
tar -xf ../compiler-rt-7.0.0.src.tar.xz -C projects &&
mv tools/cfe-7.0.0.src tools/clang &&
mv projects/compiler-rt-7.0.0.src projects/compiler-rt


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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
