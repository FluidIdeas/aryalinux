#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:openjade
#REQ:docbook-3.1-dtd
#REQ:perl-modules#perl-sgmlspm
#REQ:lynx

cd $SOURCE_DIR
NAME=docbook-utils
VERSION=0.6.14
URL=https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz


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

patch -Np1 -i ../docbook-utils-0.6.14-grep_fix-1.patch
sed -i 's:/html::' doc/HTML/Makefile.in
./configure --prefix=/usr --mandir=/usr/share/man
make
make docdir=/usr/share/doc install
for doctype in html ps dvi man pdf rtf tex texi txt
do
    ln -svf docbook2$doctype /usr/bin/db2$doctype
done

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd