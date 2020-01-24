#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:apr-util
#REQ:sqlite
#REQ:serf


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/subversion/subversion-1.12.2.tar.bz2


NAME=subversion
VERSION=1.12.2
URL=https://archive.apache.org/dist/subversion/subversion-1.12.2.tar.bz2
SECTION="General Libraries and Utilities"
DESCRIPTION="Subversion is a version control system that is designed to be a compelling replacement for CVS in the open source community. It extends and enhances CVS' feature set, while maintaining a similar interface for those already familiar with CVS. These instructions install the client and server software used to manipulate a Subversion repository. Creation of a repository is covered at Running a Subversion Server."

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


sed -i 's/classic/nofastunpack/' build.conf
./configure --prefix=/usr             \
            --disable-static          \
            --with-apache-libexecdir  \
            --with-lz4=internal       \
            --with-utf8proc=internal &&
make
doxygen doc/doxygen.conf
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/subversion-1.12.2 &&
cp      -v -R doc/* /usr/share/doc/subversion-1.12.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

