#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:which
#REQ:zip

cd $SOURCE_DIR
NAME=libreoffice
VERSION=26.2.1
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")


echo $USER > /tmp/currentuser

patch -Np1 -i ../libreoffice-26.2.1.2-poppler_26.02-1.patch
sed -i '/icuuc \\/a zlib\\'           writerperfect/Library_wpftdraw.mk
sed -i "/distro-install-file-lists/d" Makefile.in
sed -e "/gzip -f/d"   \
    -e "s|.1.gz|.1|g" \
    -i bin/distro-install-desktop-integration
ln -sv ../../../libreoffice-dictionaries-26.2.1.2.tar.xz external/tarballs/
ln -sv ../../../libreoffice-help-26.2.1.2.tar.xz         external/tarballs/
ln -sv ../../../libreoffice-translations-26.2.1.2.tar.xz external/tarballs/
ln -sv src/libreoffice-help-26.2.1.2/helpcontent2/
ln -sv src/libreoffice-dictionaries-26.2.1.2/dictionaries/
ln -sv src/libreoffice-translations-26.2.1.2/translations/
export LO_PREFIX=<PREFIX>
case $(uname -m) in
   i?86) sed /-Os/d -i solenv/gbuild/platform/LINUX_INTEL_GCC.mk ;;
esac
./autogen.sh --prefix=$LO_PREFIX         \
             --sysconfdir=/etc           \
             --with-vendor=BLFS          \
             --with-lang='fr en-GB'      \
             --with-help=html            \
             --with-myspell-dicts        \
             --without-junit             \
             --without-system-dicts      \
             --disable-dconf             \
             --disable-odk               \
             --disable-mariadb-sdbc      \
             --enable-release-build=yes  \
             --enable-python=system      \
             --with-jdk-home=/opt/jdk    \
             --with-system-boost         \
             --with-system-clucene       \
             --with-system-curl          \
             --with-system-epoxy         \
             --with-system-expat         \
             --with-system-glm           \
             --with-system-gpgmepp       \
             --with-system-graphite      \
             --with-system-harfbuzz      \
             --with-system-icu           \
             --with-system-jpeg          \
             --with-system-lcms2         \
             --with-system-libatomic_ops \
             --with-system-libtiff       \
             --with-system-libpng        \
             --with-system-libxml        \
             --with-system-libwebp       \
             --with-system-nss           \
             --with-system-odbc          \
             --with-system-openldap      \
             --with-system-openssl       \
             --with-system-poppler       \
             --with-system-postgresql    \
             --with-system-redland       \
             --with-system-zlib          \
             --with-system-zstd
make build
make distro-pack-install
if [ "$LO_PREFIX" != "/usr" ]; then

  # This symlink is necessary for the desktop menu entries
  ln -svf $LO_PREFIX/lib/libreoffice/program/soffice /usr/bin/libreoffice
# Set up a generic location independent of version number
  ln -sfv $LO_PREFIX /opt/libreoffice
# Icons
  mkdir -vp /usr/share/pixmaps
for i in $LO_PREFIX/share/icons/hicolor/32x32/apps/*; do
    ln -svf $i /usr/share/pixmaps
  done
# Desktop menu entries
  for i in $LO_PREFIX/lib/libreoffice/share/xdg/*; do
    ln -svf $i /usr/share/applications/libreoffice-$(basename $i)
  done
# Man pages
  for i in $LO_PREFIX/share/man/man1/*; do
    ln -svf $i /usr/share/man/man1/
  done
unset i
fi
update-desktop-database


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -dm755 external/tarballs
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd