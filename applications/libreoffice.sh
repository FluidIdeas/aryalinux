#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:neon
#REQ:dbus-glib
#REQ:gtk2
#REQ:clucene
#REQ:wget
#REQ:icu
#REQ:serf
#REQ:unixodbc
#REQ:openldap
#REQ:glu
#REQ:mesa
#REQ:which
#REQ:perl-modules#perl-archive-zip
#REQ:unzip
#REQ:gtk3
#REQ:redland
#REQ:lcms2
#REQ:librsvg
#REQ:boost
#REQ:gpgme
#REQ:zip
#REQ:glm
#REQ:curl
#REQ:nss
#REQ:gst10-plugins-base
#REQ:libatomic_ops
#REQ:libxml2
#REQ:apr
#REQ:poppler
#REQ:harfbuzz
#REQ:graphite2
#REQ:libjpeg
#REQ:cups
#REQ:libxslt


cd $SOURCE_DIR

wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.3/libreoffice-6.2.3.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.3/libreoffice-dictionaries-6.2.3.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.3/libreoffice-help-6.2.3.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.3/libreoffice-translations-6.2.3.2.tar.xz


NAME=libreoffice
VERSION=6.2.3.2
URL=http://download.documentfoundation.org/libreoffice/src/6.2.3/libreoffice-6.2.3.2.tar.xz

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


install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-6.2.3.2.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-6.2.3.2.tar.xz         external/tarballs/
ln -sv ../../../libreoffice-translations-6.2.3.2.tar.xz external/tarballs/
export LO_PREFIX=<PREFIX>
sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&

sed -e "/distro-install-file-lists/d" -i Makefile.in &&


./autogen.sh --prefix=$LO_PREFIX         \
             --sysconfdir=/etc           \
             --with-vendor=BLFS          \
             --with-lang='fr en-GB'      \
             --with-help                 \
             --with-myspell-dicts        \
             --without-junit             \
             --without-system-dicts      \
             --disable-dconf             \
             --disable-odk               \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-system-apr           \
             --with-system-boost         \
             --with-system-cairo         \
             --with-system-clucene       \
             --with-system-curl          \
             --with-system-expat         \
             --with-system-glm           \
             --with-system-gpgmepp       \
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
             --with-system-postgresql    \
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib
make build-nocheck
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make distro-pack-install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
update-desktop-database
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

