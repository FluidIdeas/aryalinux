#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=lua52
VERSION=5.2.4
URL=https://www.lua.org/ftp/lua-5.2.4.tar.gz
SECTION="Programming"
DESCRIPTION="Lua is a powerful light-weight programming language designed for extending applications. It is also frequently used as a general-purpose, stand-alone language. Lua is implemented as a small library of C functions, written in ANSI C, and compiles unmodified in all known platforms. The implementation goals are simplicity, efficiency, portability, and low embedding cost. The result is a fast language engine with small footprint, making it ideal in embedded systems too."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.lua.org/ftp/lua-5.2.4.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/lua-5.2.4-shared_library-1.patch


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


cat > lua.pc << "EOF"
V=5.2
R=5.2.4

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include/lua5.2
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include/lua5.2

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua5.2 -lm -ldl
Cflags: -I${includedir}
EOF
patch -Np1 -i ../lua-5.2.4-shared_library-1.patch &&

sed -i '/#define LUA_ROOT/s:/usr/local/:/usr/:' src/luaconf.h &&

sed -r -e '/^LUA_(SO|A|T)=/ s/lua/lua5.2/' \
       -e '/^LUAC_T=/ s/luac/luac5.2/'     \
       -i src/Makefile &&

make MYCFLAGS="-fPIC" linux
make TO_BIN='lua5.2 luac5.2'                     \
     TO_LIB="liblua5.2.so liblua5.2.so.5.2 liblua5.2.so.5.2.4" \
     INSTALL_DATA="cp -d"                        \
     INSTALL_TOP=$PWD/install/usr                \
     INSTALL_INC=$PWD/install/usr/include/lua5.2 \
     INSTALL_MAN=$PWD/install/usr/share/man/man1 \
     install &&

install -Dm644 lua.pc install/usr/lib/pkgconfig/lua52.pc &&

mkdir -pv install/usr/share/doc/lua-5.2.4 &&
cp -v doc/*.{html,css,gif,png} install/usr/share/doc/lua-5.2.4 &&

ln -s liblua5.2.so install/usr/lib/liblua.so.5.2   &&
ln -s liblua5.2.so install/usr/lib/liblua.so.5.2.4 &&

mv install/usr/share/man/man1/{lua.1,lua5.2.1} &&
mv install/usr/share/man/man1/{luac.1,luac5.2.1}
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
chown -R root:root install  &&
cp -a install/* /
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd