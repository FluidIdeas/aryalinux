#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-archive-zip
#REQ:unzip
#REQ:wget
#REQ:which
#REQ:zip
#REQ:openssl
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
#REC:poppler
#REC:redland
#REC:serf
#REC:unixodbc

cd $SOURCE_DIR

wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.2/libreoffice-6.2.2.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.2/libreoffice-dictionaries-6.2.2.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.2/libreoffice-help-6.2.2.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.2.2/libreoffice-translations-6.2.2.2.tar.xz

NAME=libreoffice
VERSION=6.2.2.2
URL=http://download.documentfoundation.org/libreoffice/src/6.2.2/libreoffice-6.2.2.2.tar.xz

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

sed -i 's/loaded;/bool{loaded};/' sfx2/source/appl/shutdownicon.cxx
install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-6.2.2.2.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-6.2.2.2.tar.xz external/tarballs/
ln -sv ../../../libreoffice-translations-6.2.2.2.tar.xz external/tarballs/
export LO_PREFIX=/usr
sed -e "/gzip -f/d"   \
-e "s|.1.gz|.1|g" \
-i bin/distro-install-desktop-integration &&

sed -e "/distro-install-file-lists/d" -i Makefile.in &&

./autogen.sh --prefix=/usr               \
             --sysconfdir=/etc           \
             --with-vendor=BLFS          \
             --with-lang=ALL             \
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
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib          \
             --without-java              \
             --disable-postgresql-sdbc

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
