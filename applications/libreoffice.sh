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
#REC:apache-ant
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
#REC:postgresql
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

wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-6.1.2.1.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-dictionaries-6.1.2.1.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-help-6.1.2.1.tar.xz
wget -nc http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-translations-6.1.2.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libreoffice-6.1.2.1-poppler70-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libreoffice-6.1.2.1-poppler71-1.patch

NAME=libreoffice
VERSION=6.1.2.1
URL=http://download.documentfoundation.org/libreoffice/src/6.1.2/libreoffice-6.1.2.1.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

tar -xf libreoffice-6.1.2.1.tar.xz --no-overwrite-dir &&
cd libreoffice-6.1.2.1
install -dm755 external/tarballs &&
ln -sv ../../../libreoffice-dictionaries-6.1.2.1.tar.xz external/tarballs/ &&
ln -sv ../../../libreoffice-help-6.1.2.1.tar.xz         external/tarballs/
ln -sv ../../../libreoffice-translations-6.1.2.1.tar.xz external/tarballs/
export LO_PREFIX=<em class="replaceable"><code><PREFIX></code></em>
patch -Np1 -i ../libreoffice-6.1.2.1-poppler70-1.patch
patch -Np1 -i ../libreoffice-6.1.2.1-poppler71-1.patch
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
             --with-system-postgresql    \
             --with-system-redland       \
             --with-system-serf          \
             --with-system-zlib
CPPFLAGS='-DU_USING_ICU_NAMESPACE=1' make build-nocheck

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make distro-pack-install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
if [ "$LO_PREFIX" != "/usr" ]; then

  # This symlink is necessary for the desktop menu entries
  ln -svf $LO_PREFIX/lib/libreoffice/program/soffice /usr/bin/libreoffice &&

  # Set up a generic location independent of version number
  ln -sfv $LO_PREFIX /opt/libreoffice 

  # Icons
  mkdir -vp /usr/share/pixmaps
  for i in $LO_PREFIX/share/icons/hicolor/32x32/apps/*; do
    ln -svf $i /usr/share/pixmaps
  done &&

  # Desktop menu entries
  for i in $LO_PREFIX/lib/libreoffice/share/xdg/*; do
    ln -svf $i /usr/share/applications/libreoffice-$(basename $i)
  done &&

  # Man pages
  for i in $LO_PREFIX/share/man/man1/*; do
    ln -svf $i /usr/share/man/man1/
  done

  unset i
fi
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
update-desktop-database
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
