#!/bin/sh

# Copyright 2013  Patrick J. Volkerding, Sebeka, Minnesota, USA
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


SOURCE_DIR=/sources
cd $SOURCE_DIR

PKGNAM=grub
VERSION=${VERSION:-$(echo $PKGNAM-*.tar.?z* | rev | cut -f 3- -d . | cut -f 1 -d - | rev)}
BUILD=${BUILD:-2}

# Automatically determine the architecture we're building on:
if [ -z "$ARCH" ]; then
  case "$(uname -m)" in
    i?86) ARCH=i486 ;;
    arm*) readelf /usr/bin/file -A | egrep -q "Tag_CPU.*[4,5]" && ARCH=arm || ARCH=armv7lh ;;
    # Unless $ARCH is already set, use uname -m for all other archs:
    *) ARCH=$(uname -m) ;;
  esac
  export ARCH
fi

NUMJOBS=${NUMJOBS:-" -j7 "}

if [ "$ARCH" = "i386" ]; then
  SLKCFLAGS="-O2 -march=i386 -mcpu=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "i486" ]; then
  SLKCFLAGS="-O2 -march=i486 -mtune=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "i586" ]; then
  SLKCFLAGS="-O2 -march=i586 -mtune=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "i686" ]; then
  SLKCFLAGS="-O2 -march=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "s390" ]; then
  SLKCFLAGS="-O2"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "x86_64" ]; then
  SLKCFLAGS="-O2"
  EFI_FLAGS=" --with-platform=efi --target=x86_64 --program-prefix= "
  LIBDIRSUFFIX="64"
elif [ "$ARCH" = "armv7hl" ]; then
  SLKCFLAGS="-O3 -march=armv7-a -mfpu=vfpv3-d16"
  LIBDIRSUFFIX=""
else
  SLKCFLAGS="-O2"
  LIBDIRSUFFIX=""
fi

tar xvf $PKGNAM-$VERSION.tar.?z* || exit 1
cd $PKGNAM-$VERSION

chown -R root:root .
find . \
  \( -perm 777 -o -perm 775 -o -perm 711 -o -perm 555 -o -perm 511 \) \
  -exec chmod 755 {} \; -o \
  \( -perm 666 -o -perm 664 -o -perm 600 -o -perm 444 -o -perm 440 -o -perm 400 \) \
  -exec chmod 644 {} \;

#zcat ../initrd_naming.patch | patch -p1 --verbose || exit 1
zcat ../txtHRnXiHYUrM.txt.gz | patch -p0 --verbose || exit 1
if [ -f ../0001-grub-core-gettext-gettext.c-main_context-secondary_c.patch ]
then
	patch -Np1 -i ../0001-grub-core-gettext-gettext.c-main_context-secondary_c.patch
fi
#zcat ../grub.dejavusansmono.gfxterm.font.diff.gz | patch -p1 --verbose || exit 1
#zcat ../grub.e75fdee420a7ad95e9a465c9699adc2e2e970440.terminate.efi.several.times.diff.gz | patch -p1 --verbose || exit 1

sed -i "s@GNU GRUB  version %s@AryaLinux 2017.08 Kuntala \- GNU GRUB@g" grub-core/normal/main.c
sed -i "s@#define GRUB_DISK_CACHE_SIZE	(1 << GRUB_DISK_CACHE_BITS)@#define GRUB_DISK_CACHE_SIZE	8192@g" include/grub/disk.h

for i in 1 2 ; do
  if [ i = 1 -a -z "$EFI_FLAGS" ]; then
    continue;
  fi

  CFLAGS="$SLKCFLAGS" \
  ./configure \
    --prefix=/usr \
    --libdir=/usr/lib${LIBDIRSUFFIX} \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --infodir=/usr/info \
    --mandir=/usr/man \
    --disable-werror \
    $EFI_FLAGS

  make clean
  make $NUMJOBS || make || exit 1
  make install || exit 1

  unset EFI_FLAGS
done

# Preserve the contents of /etc/grub.d/40_custom:
mv /etc/grub.d/40_custom /etc/grub.d/40_custom.new

mkdir -p /etc/default
cat ../etc.default.grub > /etc/default/grub.new

# Add fonts, if found on the system:
FONT_SIZE=${FONT_SIZE:-19}
if [ -r /usr/share/fonts/TTF/unifont.ttf ]; then
  /usr/bin/grub-mkfont -o /usr/share/grub/unifont.pf2 -abv \
  -s $FONT_SIZE /usr/share/fonts/TTF/unifont.ttf
fi
if [ -r /usr/share/fonts/TTF/DejaVuSansMono.ttf ]; then
  /usr/bin/grub-mkfont -o /usr/share/grub/dejavusansmono.pf2 -abv \
  -s $FONT_SIZE /usr/share/fonts/TTF/DejaVuSansMono.ttf
fi

cd $SOURCE_DIR
rm -r $PKGNAM-$VERSION

