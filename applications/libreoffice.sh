#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak LibreOffice is a full-featuredbr3ak office suite. It is largely compatible with Microsoft Office and is descended frombr3ak OpenOffice.org.br3ak"
SECTION="xsoft"
VERSION_MAJOR=6.0.1
VERSION_MINOR=1
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
#REC:openssl
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

URL=$PARENT_DIR_URL/libreoffice-$VERSION.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc $PARENT_DIR_URL/libreoffice-dictionaries-$VERSION.tar.xz
wget -nc $PARENT_DIR_URL/libreoffice-translations-$VERSION.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

if [ -z "$LANGUAGE" ]; then export LANGUAGE=ALL; fi

install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-$VERSION_MAJOR.$VERSION_MINOR.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-$VERSION_MAJOR.$VERSION_MINOR.tar.xz         external/tarballs/


ln -sv ../../../libreoffice-translations-$VERSION_MAJOR.$VERSION_MINOR.tar.xz external/tarballs/


sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&
sed -e "/distro-install-file-lists/d" -i Makefile.in &&
./autogen.sh --prefix=/usr               \
             --sysconfdir=/etc           \
             --with-vendor=AryaLinux     \
             --with-lang="$LANGUAGE"     \
             --with-help                 \
             --with-myspell-dicts        \
             --with-alloc=system         \
             --without-junit             \
             --without-system-dicts      \
             --disable-dconf             \
             --disable-odk               \
             --disable-firebird-sdbc     \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-system-apr           \
             --with-system-boost         \
             --with-system-cairo         \
             --with-system-clucene       \
             --with-system-curl          \
             --with-system-expat         \
             --with-system-graphite      \
             --with-system-harfbuzz      \
             --with-system-icu           \
             --with-system-jpeg          \
             --with-system-lcms2         \
             --with-system-libatomic_ops \
             --with-system-libpng        \
             --with-system-libxml        \
             --with-system-neon          \
             --with-system-nss           \
             --with-system-odbc          \
             --with-system-openldap      \
             --with-system-openssl       \
             --with-system-poppler       \
             --disable-postgresql-sdbc   \
             --without-java              \
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib


make build-nocheck
sudo make distro-pack-install
sudo update-desktop-database

# Create the package

sudo make distro-pack-install DESTDIR=$BINARY_DIR/libreoffice-$VERSION-$(uname -m)
pushd $BINARY_DIR/libreoffice-$VERSION-$(uname -m)
sudo tar -cJvf $BINARY_DIR/libreoffice-$VERSION-$(uname -m).tar.xz *
popd

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
