#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="blueman"
VERSION="2.0.5"

#REQ:obex-data-server
#REQ:python-modules#dbus-python
#REQ:python-modules#pygobject3
#REQ:cython
#REQ:obexfs
#REQ:sbc

cd $SOURCE_DIR

URL="https://github.com/blueman-project/blueman/releases/download/2.0.5/blueman-2.0.5.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --libexecdir=/usr/lib/blueman \
            --disable-static &&
make "-j`nproc`"

sudo make install

whoami > /tmp/currentuser
sudo usermod -a -G lp `cat /tmp/currentuser`

if [ "`which thunar`" != "" ]
then
	FM="thunar"
elif [ "`which caja`" != "" ]
then
	FM="caja"
elif [ "`which nautilus`" != "" ]
then
	FM="nautilus"
fi
 
cat > obex_filemanager.sh <<EOF
#!/bin/bash
fusermount -u ~/bluetooth
obexfs -b $1 ~/bluetooth
$FM ~/bluetooth
EOF

sudo mv obex_filemanager.sh /usr/bin
sudo chmod a+x /usr/bin/obex_filemanager.sh

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
