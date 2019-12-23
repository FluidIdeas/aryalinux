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
#REQ:redland
#REQ:serf
#REQ:unixodbc


cd $SOURCE_DIR

wget -nc http://download.documentfoundation.org/libreoffice/src/6.3.4/libreoffice-6.3.4.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.3.4/libreoffice-dictionaries-6.3.4.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.3.4/libreoffice-help-6.3.4.2.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.3.4/libreoffice-translations-6.3.4.2.tar.xz


NAME=libreoffice
VERSION=6.3.4.2
URL=http://download.documentfoundation.org/libreoffice/src/6.3.4/libreoffice-6.3.4.2.tar.xz

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


install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-6.3.4.2.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-6.3.4.2.tar.xz         external/tarballs/
ln -sv ../../../libreoffice-translations-6.3.4.2.tar.xz external/tarballs/
export LO_PREFIX=/usr
sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&

sed -e "/distro-install-file-lists/d" -i Makefile.in &&

sed -e '/JAVA_SOURCE_VER/s/6/7/' \
    -e '/JAVA_TARGET_VER/s/6/7/' \
    -i configure.ac



./autogen.sh --prefix=$LO_PREFIX         \
             --sysconfdir=/etc           \
             --with-vendor=AryaLinux          \
             --with-lang=ALL --without-java      \
             --with-help                 \
             --with-myspell-dicts        \
             --without-junit             \
             --without-system-dicts      \
             --disable-dconf             \
             -disable-gtk -enable-gtk3   \
             --disable-odk               \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-jdk-home=/opt/jdk    \
             --with-system-apr           \
             --with-system-boost         \
             --with-system-clucene       \
             --with-system-curl          \
             --with-system-epoxy         \
             --with-system-expat         \
             --with-system-glm           \
             --with-system-gpgmepp       \
             --with-system-graphite      \
             --with-system-harfbuzz      \
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
             --disable-postgresql-sdbc    \
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

