#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:lzo
#REC:asciidoc
#REC:xmlto
#OPT:lvm2
#OPT:python2
#OPT:reiserfs

cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.19.1.tar.xz

NAME=btrfs-progs
VERSION=v4.19.1
URL=https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v4.19.1.tar.xz

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

./configure --prefix=/usr \
--bindir=/bin \
--libdir=/lib \
--disable-zstd &&
make
make fssum &&

sed -i '/found/s/^/: #/' tests/convert-tests.sh &&

mv tests/mkfs-tests/013-reserved-1M-for-single/test.sh{,.broken} &&
mv tests/convert-tests/010-reiserfs-basic/test.sh{,.broken} &&
mv tests/convert-tests/011-reiserfs-delete-all-rollback/test.sh{,.broken} &&
mv tests/convert-tests/012-reiserfs-large-hole-extent/test.sh{,.broken} &&
mv tests/convert-tests/013-reiserfs-common-inode-flags/test.sh{,.broken} &&
mv tests/convert-tests/014-reiserfs-tail-handling/test.sh{,.broken} &&
mv tests/misc-tests/004-shrink-fs/test.sh{,.broken} &&
mv tests/misc-tests/013-subvolume-sync-crash/test.sh{,.broken} &&
mv tests/misc-tests/025-zstd-compression/test.sh{,.broken} &&
mv tests/fuzz-tests/003-multi-check-unmounted/test.sh{,.broken} &&
mv tests/fuzz-tests/009-simple-zero-log/test.sh{,.broken}
pushd tests
./fsck-tests.sh
./mkfs-tests.sh
./cli-tests.sh
./convert-tests.sh
./misc-tests.sh
./fuzz-tests.sh
popd

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

ln -sfv ../../lib/$(readlink /lib/libbtrfs.so) /usr/lib/libbtrfs.so &&
ln -sfv ../../lib/$(readlink /lib/libbtrfsutil.so) /usr/lib/libbtrfsutil.so &&
rm -fv /lib/libbtrfs.{a,so} /lib/libbtrfsutil.{a,so} &&
mv -v /bin/{mkfs,fsck}.btrfs /sbin
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
