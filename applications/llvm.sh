#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:cmake

cd $SOURCE_DIR
NAME=llvm
VERSION=21.1.8
URL=https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz


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

tar -xf ../llvm-cmake-21.1.8.src.tar.xz
tar -xf ../llvm-third-party-21.1.8.src.tar.xz
sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-21.1.8.src@'          \
    -i CMakeLists.txt
sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-21.1.8.src@' \
    -i cmake/modules/HandleLLVMOptions.cmake
tar -xf ../clang-21.1.8.src.tar.xz -C tools
mv tools/clang-21.1.8.src tools/clang
tar -xf ../compiler-rt-21.1.8.src.tar.xz -C projects
mv projects/compiler-rt-21.1.8.src projects/compiler-rt
grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'
sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt
mkdir -v build
cd       build
CC=gcc CXX=g++                               \
cmake -D CMAKE_INSTALL_PREFIX=/usr           \
      -D CMAKE_SKIP_INSTALL_RPATH=ON         \
      -D LLVM_ENABLE_FFI=ON                  \
      -D CMAKE_BUILD_TYPE=Release            \
      -D LLVM_BUILD_LLVM_DYLIB=ON            \
      -D LLVM_LINK_LLVM_DYLIB=ON             \
      -D LLVM_ENABLE_RTTI=ON                 \
      -D LLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -D LLVM_BINUTILS_INCDIR=/usr/include   \
      -D LLVM_INCLUDE_BENCHMARKS=OFF         \
      -D CLANG_DEFAULT_PIE_ON_LINUX=ON       \
      -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang \
      -W no-dev -G Ninja ..
ninja
sed -e 's/config.has_no_default_config_flag/True/' \
    -e 's/"-fuse-ld=gold"//'                       \
    -i ../projects/compiler-rt/test/lit.common.cfg.py
systemctl   --user start dbus
systemd-run --user --pty -d -G -p LimitCORE=0 ninja check-all
mkdir -pv /etc/clang
for i in clang clang++; do
  echo -fstack-protector-strong > /etc/clang/$i.cfg
done


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd