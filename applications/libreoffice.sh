#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak LibreOffice is a full-featuredbr3ak office suite. It is largely compatible with Microsoft Office and is descended frombr3ak OpenOffice.org.br3ak"
SECTION="xsoft"
VERSION=6.1.2.1
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
#REC:poppler
#REC:redland
#REC:serf
#REC:unixodbc
#OPT:avahi
#OPT:bluez
#OPT:dconf
#OPT:desktop-file-utils
#OPT:doxygen
#OPT:gdb
#OPT:gnutls
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

URL=http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-6.1.2.1.tar.xz

if [ ! -z $URL ]
then
wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-6.1.2.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-6.1.2.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-6.1.2.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-6.1.2.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-6.1.2.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-6.1.2.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-6.1.2.1.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-dictionaries-6.1.2.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-dictionaries-6.1.2.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-dictionaries-6.1.2.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-6.1.2.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-6.1.2.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-6.1.2.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-dictionaries-6.1.2.1.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-translations-6.1.2.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-translations-6.1.2.1.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libreoffice/libreoffice-translations-6.1.2.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-translations-6.1.2.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libreoffice/libreoffice-translations-6.1.2.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-translations-6.1.2.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libreoffice/libreoffice-translations-6.1.2.1.tar.xz

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

if [ -z "$LANGUAGE" ]; then export LANGUAGE=en-US; fi

install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-6.1.2.1.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-6.1.2.1.tar.xz         external/tarballs/


ln -sv ../../../libreoffice-translations-6.1.2.1.tar.xz external/tarballs/


export LO_PREFIX=/usr


sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration &&
sed -e "/distro-install-file-lists/d" -i Makefile.in &&
./autogen.sh --prefix=$LO_PREFIX         \
             --sysconfdir=/etc           \
             --with-vendor=AryaLinux          \
             --with-lang="$LANGUAGE"      \
             --with-help                 \
             --with-myspell-dicts        \
             --with-alloc=system         \
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
             --disable-postgresql-sdbc --without-java    \
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib


CPPFLAGS='-DU_USING_ICU_NAMESPACE=1' make build-nocheck



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make distro-pack-install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


sudo ln -svf /usr/lib/libreoffice/program/soffice /usr/bin/libreoffice

sudo mkdir -vp /usr/share/pixmaps
for i in /usr/share/icons/hicolor/32x32/apps/*; do
    sudo ln -svf $i /usr/share/pixmaps
done

for i in /usr/lib/libreoffice/share/xdg/*; do
    sudo ln -svf $i /usr/share/applications/libreoffice-$(basename $i)
done

unset i



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
