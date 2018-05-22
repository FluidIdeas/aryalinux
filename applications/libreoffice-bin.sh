#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak LibreOffice is a full-featuredbr3ak office suite. It is largely compatible with Microsoft Office and is descended frombr3ak OpenOffice.org.br3ak"
SECTION="xsoft"
VERSION_MAJOR=5.3.0
VERSION_MINOR=3
VERSION=$VERSION_MAJOR.$VERSION_MINOR
PARENT_DIR_URL="http://download.documentfoundation.org/libreoffice/src/$VERSION_MAJOR/"
NAME="libreoffice"

#REQ:perl-modules#perl-archive-zip
#REQ:unzip
#REQ:wget
#REQ:general_which
#REQ:zip
#REC:apr
#REC:boost
#REC:clucene
#REC:cups
#REC:curl
#REC:dbus-glib
#REC:libjpeg
#REC:glu
#REC:graphite2
#REC:gst10-plugins-base
#REC:gtk3
#REC:gtk2
#REC:harfbuzz
#REC:icu
#REC:libatomic_ops
#REC:lcms2
#REC:librsvg
#REC:libxml2
#REC:libxslt
#REC:mesa
#REC:neon
#REC:nss
#REC:openldap
#REC:openssl10
#REC:gnutls
#REC:poppler
#REC:python3
#REC:redland
#REC:serf
#REC:unixodbc
#OPT:avahi
#OPT:bluez
#OPT:dconf
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:gdb
#OPT:junit
#OPT:mariadb
#OPT:mitkrb
#OPT:nasm
#OPT:sane
#OPT:valgrind
#OPT:vlc
#OPT:telepathy-glib
#OPT:zenity


cd $SOURCE_DIR

URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.06/bin/libreoffice-5.3.0.3-x86_64.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
sudo tar xf $TARBALL -C /
sudo update-desktop-database

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
