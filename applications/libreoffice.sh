#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:perl-modules#perl-archive-zip
#REQ:unzip
#REQ:wget
#REQ:which
#REQ:zip
#REQ:apr
#REQ:boost
#REQ:clucene
#REQ:cups
#REQ:curl
#REQ:dbus-glib
#REQ:libjpeg
#REQ:glm
#REQ:glu
#REQ:gpgme
#REQ:graphite2
#REQ:gst10-plugins-base
#REQ:gtk3
#REQ:harfbuzz
#REQ:icu
#REQ:libatomic_ops
#REQ:lcms2
#REQ:librsvg
#REQ:libxml2
#REQ:libxslt
#REQ:python-modules#lxml
#REQ:mesa
#REQ:neon
#REQ:nss
#REQ:openldap
#REQ:poppler
#REQ:redland
#REQ:serf
#REQ:unixodbc


cd $SOURCE_DIR

wget -nc http://aryalinux.info/files/2.4/libreoffice-6.4.0.3-x86_64.tar.gz


NAME=libreoffice
VERSION=6.4.0.3
URL=http://aryalinux.info/files/2.4/libreoffice-6.4.0.3-x86_64.tar.gz
SECTION="Office Programs"
DESCRIPTION="LibreOffice is a full-featured office suite. It is largely compatible with Microsoft Office and is descended from OpenOffice.org."

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

sudo tar xf libreoffice-6.4.0.3-x86_64.tar.gz -C /


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

