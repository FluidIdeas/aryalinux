#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:perl-modules#perl-business-isbn
#REQ:perl-modules#perl-business-ismn
#REQ:perl-modules#perl-business-issn
#REQ:perl-modules#perl-class-accessor
#REQ:perl-modules#perl-data-compare
#REQ:perl-modules#perl-encode-hanextra
#REQ:perl-modules#perl-encode-jis2k
#REQ:perl-modules#perl-list-allutils
#REQ:perl-modules#perl-log-log4perl
#REQ:perl-modules#perl-module-build
#REQ:perl-modules#perl-parse-recdescent
#REQ:perl-modules#perl-regexp-common
#REQ:perl-modules#perl-sort-key
#REQ:perl-modules#perl-unicode-linebreak
#REQ:perl-modules#perl-xml-libxslt
#REQ:perl-modules#perl-xml-writer
#REQ:perl-modules#perl-file-which
#REQ:perl-modules#perl-test-differences

cd $SOURCE_DIR
NAME=biber
VERSION=2.21
URL=https://github.com/plk/biber/archive/v2.21/biber-2.21.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/plk/biber/archive/v2.21/biber-2.21.tar.gz


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

perl ./Build.PL
./Build
./Build install

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd