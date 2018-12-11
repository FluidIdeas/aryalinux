#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:doxygen

cd $SOURCE_DIR

wget -nc https://github.com/libfuse/libfuse/releases/download/fuse-3.3.0/fuse-3.3.0.tar.xz

URL=https://github.com/libfuse/libfuse/releases/download/fuse-3.3.0/fuse-3.3.0.tar.xz

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

sed -i '/^udev/,$ s/^/#/' util/meson.build &&

mkdir build &&
cd    build &&

meson --prefix=/usr .. &&
ninja

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
ninja install                                             &&

mv -vf   /usr/lib/libfuse3.so.3*     /lib                 &&
ln -sfvn ../../lib/libfuse3.so.3.3.0 /usr/lib/libfuse3.so &&

mv -vf /usr/bin/fusermount3  /bin         &&
mv -vf /usr/sbin/mount.fuse3 /sbin        &&
chmod u+s /bin/fusermount3                &&

install -v -m755 -d /usr/share/doc/fuse-3.3.0      &&
install -v -m644    ../doc/{README.NFS,kernel.txt} \
                    /usr/share/doc/fuse-3.3.0      &&
cp -Rv ../doc/html  /usr/share/doc/fuse-3.3.0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000

# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
