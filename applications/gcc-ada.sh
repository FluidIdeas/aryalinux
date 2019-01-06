#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REC:dejagnu

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz

NAME=gcc-ada
VERSION=8.2.0
URL=https://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make ins-all prefix=/opt/gnat
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

PATH_HOLD=$PATH &&
export PATH=/opt/gnat/bin:$PATH_HOLD

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
find /opt/gnat -name ld -exec mv -v {} {}.old \;
find /opt/gnat -name as -exec mv -v {} {}.old \;
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

case $(uname -m) in
x86_64)
sed -e '/m64=/s/lib64/lib/' \
-i.orig gcc/config/i386/t-linux64
;;
esac

mkdir build &&
cd build &&

../configure \
--prefix=/usr \
--disable-multilib \
--disable-libmpx \
--with-system-zlib \
--enable-languages=ada &&
make
ulimit -s 32768 &&
make -k check
../contrib/test_summary

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
mkdir -pv /usr/share/gdb/auto-load/usr/lib &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&

chown -v -R root:root \
/usr/lib/gcc/*linux-gnu/8.2.0/include{,-fixed} \
/usr/lib/gcc/*linux-gnu/8.2.0/ada{lib,include}
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
rm -rf /opt/gnat
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

export PATH=$PATH_HOLD &&
unset PATH_HOLD

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
