#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Ada is a modern programming language designed for large, long-livedbr3ak applications — and embedded systems in particular —br3ak where reliability and efficiency are essential. It has a set ofbr3ak unique technical features that make it highly effective for use inbr3ak large, complex and safety-critical projects.br3ak"
SECTION="general"
VERSION=8.2.0
NAME="gcc-ada"

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


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make ins-all prefix=/opt/gnat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


PATH_HOLD=$PATH &&
export PATH=/opt/gnat/bin:$PATH_HOLD



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find /opt/gnat -name ld -exec mv -v {} {}.old \;
find /opt/gnat -name as -exec mv -v {} {}.old \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir build &&
cd    build &&
../configure               \
    --prefix=/usr          \
    --disable-multilib     \
    --disable-libmpx       \
    --with-system-zlib     \
    --enable-languages=ada &&
make "-j`nproc`" || make


ulimit -s 32768 &&
make -k check


../contrib/test_summary



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                               &&
mkdir -pv /usr/share/gdb/auto-load/usr/lib                 &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib    &&
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/8.2.0/include{,-fixed} \
    /usr/lib/gcc/*linux-gnu/8.2.0/ada{lib,include}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rf /opt/gnat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


export PATH=$PATH_HOLD &&
unset PATH_HOLD




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
