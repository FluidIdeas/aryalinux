#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="p7zip-full"
VERSION=9.38.1
DESCRIPTION="A high compression capable file archiving utility"

cd $SOURCE_DIR

URL=http://liquidtelecom.dl.sourceforge.net/project/p7zip/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

if [ `uname -m` == "x86_64" ]; then
	cp makefile.linux_amd64 makefile.machine
fi

make all3
sed -i 's@DEST_HOME=/usr/local@DEST_HOME=/usr@g' install.sh
sudo ./install.sh

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
