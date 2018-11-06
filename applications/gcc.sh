#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The GCC package contains the GNUbr3ak Compiler Collection. This page describes the installation ofbr3ak compilers for the following languages: C, C++, Fortran, Objectivebr3ak C, Objective C++, and Go. One additional language, Ada, isbr3ak available in the collection. It has a binary bootstrap requirementbr3ak for the first installation, so it is described on a separate pagebr3ak (<a class=\"xref\" href=\"gcc-ada.html\" title=\"GCC-Ada-8.2.0\">GCC-Ada-8.2.0</a>), but can be added here if youbr3ak are performing a rebuild or upgrade. Since C and C++ are installedbr3ak in LFS, this page is either for upgrading C and C++, or forbr3ak installing additional compilers.br3ak"
SECTION="general"
VERSION=8.2.0
NAME="gcc"

#REC:dejagnu


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz

if [ ! -z $URL ]
then
wget -nc https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcc/gcc-8.2.0.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/gcc/gcc-8.2.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-8.2.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-8.2.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-8.2.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-8.2.0.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz

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

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir build                                          &&
cd    build                                          &&
../configure                                         \
    --prefix=/usr                                    \
    --disable-multilib                               \
    --disable-libmpx                                 \
    --with-system-zlib                               \
    --enable-languages=c,c++,fortran,go,objc,obj-c++ &&
make "-j`nproc`" || make


ulimit -s 32768 &&
make -k check


../contrib/test_summary



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/gdb/auto-load/usr/lib              &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/8.2.0/include{,-fixed}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -sf ../usr/bin/cpp /lib          &&
ln -v -sf gcc /usr/bin/cc              &&
install -v -dm755 /usr/lib/bfd-plugins &&
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so /usr/lib/bfd-plugins/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
