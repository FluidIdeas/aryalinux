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
#REQ:gtk2
#REQ:harfbuzz
#REQ:icu
#REQ:libatomic_ops
#REQ:lcms2
#REQ:librsvg
#REQ:libxml2
#REQ:libxslt
#REQ:mesa
#REQ:neon
#REQ:nss
#REQ:openldap
#REQ:poppler
#REQ:redland
#REQ:serf
#REQ:unixodbc


cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/files/2.0/libreoffice-6.2.5-x86_64.tar.xz


NAME=libreoffice
VERSION=6.2.5


sudo update-desktop-database


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

