#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=glibc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=glibc-2.29.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

export CFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CXXFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"
export CPPFLAGS="-march=$BUILD_ARCH -mtune=$BUILD_TUNE -O$BUILD_OPT_LEVEL"

patch -Np1 -i ../glibc-2.29-fhs-1.patch
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    ;;
esac
mkdir -v build
cd       build
CC="gcc -ffile-prefix-map=/tools=/usr" \
../configure --prefix=/usr                          \
             --disable-werror                       \
             --enable-kernel=3.2                    \
             --enable-stack-protector=strong        \
             --with-headers=/usr/include            \
             libc_cv_slibdir=/lib
make
case $(uname -m) in
  i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        /lib ;;
  x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
esac
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service
make localedata/install-locales
cat > /etc/nsswit   c   h   .   c   o   n   f       &l   t   ;   &l   t   ;       "   E   O   F   "   
   c   o   d   e       c   l   a   s   s   =   "   l   i   t   e   r   a   l   "   >   #       B   e   g   i   n       /   e   t   c   /   n   s   s   w   i   t   c   h   .   c   o   n   f   
   
   p   a   s   s   w   d   :       f   i   l   e   s   
   g   r   o   u   p   :       f   i   l   e   s   
   s   h   a   d   o   w   :       f   i   l   e   s   
   
   h   o   s   t   s   :       f   i   l   e   s       d   n   s   
   n   e   t   w   o   r   k   s   :       f   i   l   e   s   
   
   p   r   o   t   o   c   o   l   s   :       f   i   l   e   s   
   s   e   r   v   i   c   e   s   :       f   i   l   e   s   
   e   t   h   e   r   s   :       f   i   l   e   s   
   r   p   c   :       f   i   l   e   s   
   
   #       E   n   d       /   e   t   c   /   n   s   s   w   i   t   c   h   .   c   o   n   f   /   c   o   d   e   >   
   E   O   F   /   k   b   d   >   
   /   p   r   e   >   
                                   /   d   i   v   >   
                                   d   i   v       c   l   a   s   s   =   "   s   e   c   t   3   "   >   
                                           h   3       c   l   a   s   s   =   "   s   e   c   t   3   "   >   
                                                   6   .   9   .   2   .   2   .       A   d   d   i   n   g       t   i   m   e       z   o   n   e       d   a   t   a   
                                           /   h   3   >   
                                           p   >   
                                                   I   n   s   t   a   l   l       a   n   d       s   e   t       u   p       t   h   e       t   i   m   e       z   o   n   e       d   a   t   a       w   i   t   h       t   h   e       f   o   l   l   o   w   i   n   g   :   
                                           /   p   >   
                                           p   r   e       c   l   a   s   s   =   "   u   s   e   r   i   n   p   u   t   "   >   
   k   b   d       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   t   a   r       -   x   f       .   .   /   .   .   /   t   z   d   a   t   a   2   0   1   9   a   .   t   a   r   .   g   z   
   
   Z   O   N   E   I   N   F   O   =   /   u   s   r   /   s   h   a   r   e   /   z   o   n   e   i   n   f   o   
   m   k   d   i   r       -   p   v       $   Z   O   N   E   I   N   F   O   /   {   p   o   s   i   x   ,   r   i   g   h   t   }   
   
   f   o   r       t   z       i   n       e   t   c   e   t   e   r   a       s   o   u   t   h   a   m   e   r   i   c   a       n   o   r   t   h   a   m   e   r   i   c   a       e   u   r   o   p   e       a   f   r   i   c   a       a   n   t   a   r   c   t   i   c   a           \   
                                           a   s   i   a       a   u   s   t   r   a   l   a   s   i   a       b   a   c   k   w   a   r   d       p   a   c   i   f   i   c   n   e   w       s   y   s   t   e   m   v   ;       d   o   
                   z   i   c       -   L       /   d   e   v   /   n   u   l   l               -   d       $   Z   O   N   E   I   N   F   O                               $   {   t   z   }   
                   z   i   c       -   L       /   d   e   v   /   n   u   l   l               -   d       $   Z   O   N   E   I   N   F   O   /   p   o   s   i   x       $   {   t   z   }   
                   z   i   c       -   L       l   e   a   p   s   e   c   o   n   d   s       -   d       $   Z   O   N   E   I   N   F   O   /   r   i   g   h   t       $   {   t   z   }   
   d   o   n   e   
   
   c   p       -   v       z   o   n   e   .   t   a   b       z   o   n   e   1   9   7   0   .   t   a   b       i   s   o   3   1   6   6   .   t   a   b       $   Z   O   N   E   I   N   F   O   
   z   i   c       -   d       $   Z   O   N   E   I   N   F   O       -   p       A   m   e   r   i   c   a   /   N   e   w   _   Y   o   r   k   
   u   n   s   e   t       Z   O   N   E   I   N   F   O   /   k   b   d   >   
   /   p   r   e   >   
                                           d   i   v       c   l   a   s   s   =   "   v   a   r   i   a   b   l   e   l   i   s   t   "   >   
                                                   p       c   l   a   s   s   =   "   t   i   t   l   e   "   >   
                                                           s   t   r   o   n   g   >   T   h   e       m   e   a   n   i   n   g       o   f       t   h   e       z   i   c       c   o   m   m   a   n   d   s   :   /   s   t   r   o   n   g   >   
                                                   /   p   >   
                                                   d   l       c   l   a   s   s   =   "   v   a   r   i   a   b   l   e   l   i   s   t   "   >   
                                                           d   t   >   
                                                                   s   p   a   n       c   l   a   s   s   =   "   t   e   r   m   "   >   e   m       c   l   a   s   s   =   "   p   a   r   a   m   e   t   e   r   "   >   c   o   d   e   >   z   i   c       -   L   
                                                                   /   d   e   v   /   n   u   l   l       .   .   .   /   c   o   d   e   >   /   e   m   >   /   s   p   a   n   >   
                                                           /   d   t   >   
                                                           d   d   >   
                                                                   p   >   
                                                                           T   h   i   s       c   r   e   a   t   e   s       p   o   s   i   x       t   i   m   e       z   o   n   e   s   ,       w   i   t   h   o   u   t       a   n   y       l   e   a   p       s   e   c   o   n   d   s   .       I   t   
                                                                           i   s       c   o   n   v   e   n   t   i   o   n   a   l       t   o       p   u   t       t   h   e   s   e       i   n       b   o   t   h       c   o   d   e       c   l   a   s   s   =   
                                                                           "   f   i   l   e   n   a   m   e   "   >   z   o   n   e   i   n   f   o   /   c   o   d   e   >       a   n   d       c   o   d   e       c   l   a   s   s   =   
                                                                           "   f   i   l   e   n   a   m   e   "   >   z   o   n   e   i   n   f   o   /   p   o   s   i   x   /   c   o   d   e   >   .       I   t       i   s       n   e   c   e   s   s   a   r   y       t   o       p   u   t   
                                                                           t   h   e       P   O   S   I   X       t   i   m   e       z   o   n   e   s       i   n       c   o   d   e       c   l   a   s   s   =   
                                                                           "   f   i   l   e   n   a   m   e   "   >   z   o   n   e   i   n   f   o   /   c   o   d   e   >   ,       o   t   h   e   r   w   i   s   e       v   a   r   i   o   u   s       t   e   s   t   -   s   u   i   t   e   s   
                                                                           w   i   l   l       r   e   p   o   r   t       e   r   r   o   r   s   .       O   n       a   n       e   m   b   e   d   d   e   d       s   y   s   t   e   m   ,       w   h   e   r   e       s   p   a   c   e       i   s   
                                                                           t   i   g   h   t       a   n   d       y   o   u       d   o       n   o   t       i   n   t   e   n   d       t   o       e   v   e   r       u   p   d   a   t   e       t   h   e       t   i   m   e       z   o   n   e   s   ,   
                                                                           y   o   u       c   o   u   l   d       s   a   v   e       1   .   9   M   B       b   y       n   o   t       u   s   i   n   g       t   h   e       c   o   d   e       c   l   a   s   s   =   
                                                                           "   f   i   l   e   n   a   m   e   "   >   p   o   s   i   x   /   c   o   d   e   >       d   i   r   e   c   t   o   r   y   ,       b   u   t       s   o   m   e       a   p   p   l   i   c   a   t   i   o   n   s       o   r   
                                                                           t   e   s   t   -   s   u   i   t   e   s       m   i   g   h   t       p   r   o   d   u   c   e       s   o   m   e       f   a   i   l   u   r   e   s   .   
                                                                   /   p   >   
                                                           /   d   d   >   
                                                           d   t   >   
                                                                   s   p   a   n       c   l   a   s   s   =   "   t   e   r   m   "   >   e   m       c   l   a   s   s   =   "   p   a   r   a   m   e   t   e   r   "   >   c   o   d   e   >   z   i   c       -   L   
                                                                   l   e   a   p   s   e   c   o   n   d   s       .   .   .   /   c   o   d   e   >   /   e   m   >   /   s   p   a   n   >   
                                                           /   d   t   >   
                                                           d   d   >   
                                                                   p   >   
                                                                           T   h   i   s       c   r   e   a   t   e   s       r   i   g   h   t       t   i   m   e       z   o   n   e   s   ,       i   n   c   l   u   d   i   n   g       l   e   a   p       s   e   c   o   n   d   s   .       O   n   
                                                                           a   n       e   m   b   e   d   d   e   d       s   y   s   t   e   m   ,       w   h   e   r   e       s   p   a   c   e       i   s       t   i   g   h   t       a   n   d       y   o   u       d   o       n   o   t   
                                                                           i   n   t   e   n   d       t   o       e   v   e   r       u   p   d   a   t   e       t   h   e       t   i   m   e       z   o   n   e   s   ,       o   r       c   a   r   e       a   b   o   u   t       t   h   e   
                                                                           c   o   r   r   e   c   t       t   i   m   e   ,       y   o   u       c   o   u   l   d       s   a   v   e       1   .   9   M   B       b   y       o   m   i   t   t   i   n   g       t   h   e   
                                                                           c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   r   i   g   h   t   /   c   o   d   e   >       d   i   r   e   c   t   o   r   y   .   
                                                                   /   p   >   
                                                           /   d   d   >   
                                                           d   t   >   
                                                                   s   p   a   n       c   l   a   s   s   =   "   t   e   r   m   "   >   e   m       c   l   a   s   s   =   "   p   a   r   a   m   e   t   e   r   "   >   c   o   d   e   >   z   i   c       .   .   .       -   p   
                                                                   .   .   .   /   c   o   d   e   >   /   e   m   >   /   s   p   a   n   >   
                                                           /   d   t   >   
                                                           d   d   >   
                                                                   p   >   
                                                                           T   h   i   s       c   r   e   a   t   e   s       t   h   e       c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   p   o   s   i   x   r   u   l   e   s   /   c   o   d   e   >   
                                                                           f   i   l   e   .       W   e       u   s   e       N   e   w       Y   o   r   k       b   e   c   a   u   s   e       P   O   S   I   X       r   e   q   u   i   r   e   s       t   h   e       d   a   y   l   i   g   h   t   
                                                                           s   a   v   i   n   g   s       t   i   m   e       r   u   l   e   s       t   o       b   e       i   n       a   c   c   o   r   d   a   n   c   e       w   i   t   h       U   S       r   u   l   e   s   .   
                                                                   /   p   >   
                                                           /   d   d   >   
                                                   /   d   l   >   
                                           /   d   i   v   >   
                                           p   >   
                                                   O   n   e       w   a   y       t   o       d   e   t   e   r   m   i   n   e       t   h   e       l   o   c   a   l       t   i   m   e       z   o   n   e       i   s       t   o       r   u   n       t   h   e       f   o   l   l   o   w   i   n   g   
                                                   s   c   r   i   p   t   :   
                                           /   p   >   
                                           p   r   e       c   l   a   s   s   =   "   u   s   e   r   i   n   p   u   t   "   >   
   k   b   d       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   t   z   s   e   l   e   c   t   /   k   b   d   >   
   /   p   r   e   >   
                                           p   >   
                                                   A   f   t   e   r       a   n   s   w   e   r   i   n   g       a       f   e   w       q   u   e   s   t   i   o   n   s       a   b   o   u   t       t   h   e       l   o   c   a   t   i   o   n   ,       t   h   e       s   c   r   i   p   t   
                                                   w   i   l   l       o   u   t   p   u   t       t   h   e       n   a   m   e       o   f       t   h   e       t   i   m   e       z   o   n   e       (   e   .   g   .   ,       s   p   a   n       c   l   a   s   s   =   
                                                   "   e   m   p   h   a   s   i   s   "   >   e   m   >   A   m   e   r   i   c   a   /   E   d   m   o   n   t   o   n   /   e   m   >   /   s   p   a   n   >   )   .       T   h   e   r   e       a   r   e       a   l   s   o       s   o   m   e   
                                                   o   t   h   e   r       p   o   s   s   i   b   l   e       t   i   m   e       z   o   n   e   s       l   i   s   t   e   d       i   n       c   o   d   e       c   l   a   s   s   =   
                                                   "   f   i   l   e   n   a   m   e   "   >   /   u   s   r   /   s   h   a   r   e   /   z   o   n   e   i   n   f   o   /   c   o   d   e   >       s   u   c   h       a   s       s   p   a   n       c   l   a   s   s   =   
                                                   "   e   m   p   h   a   s   i   s   "   >   e   m   >   C   a   n   a   d   a   /   E   a   s   t   e   r   n   /   e   m   >   /   s   p   a   n   >       o   r       s   p   a   n       c   l   a   s   s   =   
                                                   "   e   m   p   h   a   s   i   s   "   >   e   m   >   E   S   T   5   E   D   T   /   e   m   >   /   s   p   a   n   >       t   h   a   t       a   r   e       n   o   t       i   d   e   n   t   i   f   i   e   d       b   y       t   h   e   
                                                   s   c   r   i   p   t       b   u   t       c   a   n       b   e       u   s   e   d   .   
                                           /   p   >   
                                           p   >   
                                                   T   h   e   n       c   r   e   a   t   e       t   h   e       c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   /   e   t   c   /   l   o   c   a   l   t   i   m   e   /   c   o   d   e   >       f   i   l   e   
                                                   b   y       r   u   n   n   i   n   g   :   
                                           /   p   >   
                                           p   r   e       c   l   a   s   s   =   "   u   s   e   r   i   n   p   u   t   "   >   
   k   b   d       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   l   n       -   s   f   v       /   u   s   r   /   s   h   a   r   e   /   z   o   n   e   i   n   f   o   /   e   m       c   l   a   s   s   =   
   "   r   e   p   l   a   c   e   a   b   l   e   "   >   c   o   d   e   >   &l   t   ;   x   x   x   &g   t   ;   /   c   o   d   e   >   /   e   m   >       /   e   t   c   /   l   o   c   a   l   t   i   m   e   /   k   b   d   >   
   /   p   r   e   >   
                                           p   >   
                                                   R   e   p   l   a   c   e       e   m       c   l   a   s   s   =   "   r   e   p   l   a   c   e   a   b   l   e   "   >   c   o   d   e   >   &l   t   ;   x   x   x   &g   t   ;   /   c   o   d   e   >   /   e   m   >   
                                                   w   i   t   h       t   h   e       n   a   m   e       o   f       t   h   e       t   i   m   e       z   o   n   e       s   e   l   e   c   t   e   d       (   e   .   g   .   ,       C   a   n   a   d   a   /   E   a   s   t   e   r   n   )   .   
                                           /   p   >   
                                   /   d   i   v   >   
                                   d   i   v       c   l   a   s   s   =   "   s   e   c   t   3   "   >   
                                           h   3       c   l   a   s   s   =   "   s   e   c   t   3   "   >   
                                                   a       i   d   =   "   c   o   n   f   -   l   d   "       n   a   m   e   =   "   c   o   n   f   -   l   d   "   >   /   a   >   6   .   9   .   2   .   3   .       C   o   n   f   i   g   u   r   i   n   g       t   h   e   
                                                   D   y   n   a   m   i   c       L   o   a   d   e   r   
                                           /   h   3   >   
                                           p   >   
                                                   B   y       d   e   f   a   u   l   t   ,       t   h   e       d   y   n   a   m   i   c       l   o   a   d   e   r       (   c   o   d   e       c   l   a   s   s   =   
                                                   "   f   i   l   e   n   a   m   e   "   >   /   l   i   b   /   l   d   -   l   i   n   u   x   .   s   o   .   2   /   c   o   d   e   >   )       s   e   a   r   c   h   e   s       t   h   r   o   u   g   h   
                                                   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   /   l   i   b   /   c   o   d   e   >       a   n   d       c   o   d   e       c   l   a   s   s   =   
                                                   "   f   i   l   e   n   a   m   e   "   >   /   u   s   r   /   l   i   b   /   c   o   d   e   >       f   o   r       d   y   n   a   m   i   c       l   i   b   r   a   r   i   e   s       t   h   a   t       a   r   e       n   e   e   d   e   d   
                                                   b   y       p   r   o   g   r   a   m   s       a   s       t   h   e   y       a   r   e       r   u   n   .       H   o   w   e   v   e   r   ,       i   f       t   h   e   r   e       a   r   e       l   i   b   r   a   r   i   e   s       i   n   
                                                   d   i   r   e   c   t   o   r   i   e   s       o   t   h   e   r       t   h   a   n       c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   /   l   i   b   /   c   o   d   e   >       a   n   d   
                                                   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   /   u   s   r   /   l   i   b   /   c   o   d   e   >   ,       t   h   e   s   e       n   e   e   d       t   o       b   e       a   d   d   e   d       t   o   
                                                   t   h   e       c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   /   e   t   c   /   l   d   .   s   o   .   c   o   n   f   /   c   o   d   e   >       f   i   l   e       i   n       o   r   d   e   r   
                                                   f   o   r       t   h   e       d   y   n   a   m   i   c       l   o   a   d   e   r       t   o       f   i   n   d       t   h   e   m   .       T   w   o       d   i   r   e   c   t   o   r   i   e   s       t   h   a   t       a   r   e   
                                                   c   o   m   m   o   n   l   y       k   n   o   w   n       t   o       c   o   n   t   a   i   n       a   d   d   i   t   i   o   n   a   l       l   i   b   r   a   r   i   e   s       a   r   e       c   o   d   e       c   l   a   s   s   =   
                                                   "   f   i   l   e   n   a   m   e   "   >   /   u   s   r   /   l   o   c   a   l   /   l   i   b   /   c   o   d   e   >       a   n   d       c   o   d   e       c   l   a   s   s   =   
                                                   "   f   i   l   e   n   a   m   e   "   >   /   o   p   t   /   l   i   b   /   c   o   d   e   >   ,       s   o       a   d   d       t   h   o   s   e       d   i   r   e   c   t   o   r   i   e   s       t   o       t   h   e   
                                                   d   y   n   a   m   i   c       l   o   a   d   e   r   '   s       s   e   a   r   c   h       p   a   t   h   .   
                                           /   p   >   
                                           p   >   
                                                   C   r   e   a   t   e       a       n   e   w       f   i   l   e       c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   /   e   t   c   /   l   d   .   s   o   .   c   o   n   f   /   c   o   d   e   >   
                                                   b   y       r   u   n   n   i   n   g       t   h   e       f   o   l   l   o   w   i   n   g   :   
                                           /   p   >   
                                           p   r   e       c   l   a   s   s   =   "   u   s   e   r   i   n   p   u   t   "   >   
   k   b   d       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   c   a   t       &g   t   ;       /   e   t   c   /   l   d   .   s   o   .   c   o   n   f       &l   t   ;   &l   t   ;       "   E   O   F   "   
   c   o   d   e       c   l   a   s   s   =   "   l   i   t   e   r   a   l   "   >   #       B   e   g   i   n       /   e   t   c   /   l   d   .   s   o   .   c   o   n   f   
   /   u   s   r   /   l   o   c   a   l   /   l   i   b   
   /   o   p   t   /   l   i   b   
   /   c   o   d   e   >   
   E   O   F   /   k   b   d   >   
   /   p   r   e   >   
                                           p   >   
                                                   I   f       d   e   s   i   r   e   d   ,       t   h   e       d   y   n   a   m   i   c       l   o   a   d   e   r       c   a   n       a   l   s   o       s   e   a   r   c   h       a       d   i   r   e   c   t   o   r   y       a   n   d   
                                                   i   n   c   l   u   d   e       t   h   e       c   o   n   t   e   n   t   s       o   f       f   i   l   e   s       f   o   u   n   d       t   h   e   r   e   .       G   e   n   e   r   a   l   l   y       t   h   e       f   i   l   e   s       i   n   
                                                   t   h   i   s       i   n   c   l   u   d   e       d   i   r   e   c   t   o   r   y       a   r   e       o   n   e       l   i   n   e       s   p   e   c   i   f   y   i   n   g       t   h   e       d   e   s   i   r   e   d   
                                                   l   i   b   r   a   r   y       p   a   t   h   .       T   o       a   d   d       t   h   i   s       c   a   p   a   b   i   l   i   t   y       r   u   n       t   h   e       f   o   l   l   o   w   i   n   g       c   o   m   m   a   n   d   s   :   
                                           /   p   >   
                                           p   r   e       c   l   a   s   s   =   "   u   s   e   r   i   n   p   u   t   "   >   
   k   b   d       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   c   a   t       &g   t   ;   &g   t   ;       /   e   t   c   /   l   d   .   s   o   .   c   o   n   f       &l   t   ;   &l   t   ;       "   E   O   F   "   
   c   o   d   e       c   l   a   s   s   =   "   l   i   t   e   r   a   l   "   >   #       A   d   d       a   n       i   n   c   l   u   d   e       d   i   r   e   c   t   o   r   y   
   i   n   c   l   u   d   e       /   e   t   c   /   l   d   .   s   o   .   c   o   n   f   .   d   /   *   .   c   o   n   f   
   /   c   o   d   e   >   
   E   O   F   
   m   k   d   i   r       -   p   v       /   e   t   c   /   l   d   .   s   o   .   c   o   n   f   .   d   /   k   b   d   >   
   /   p   r   e   >   
                                   /   d   i   v   >   
                           /   d   i   v   >   
                           d   i   v       c   l   a   s   s   =   "   c   o   n   t   e   n   t   "       l   a   n   g   =   "   e   n   "       x   m   l   :   l   a   n   g   =   "   e   n   "   >   
                                   h   2       c   l   a   s   s   =   "   s   e   c   t   2   "   >   
                                           a       i   d   =   "   c   o   n   t   e   n   t   s   -   g   l   i   b   c   "       n   a   m   e   =   "   c   o   n   t   e   n   t   s   -   g   l   i   b   c   "   >   /   a   >   6   .   9   .   3   .       C   o   n   t   e   n   t   s       o   f   
                                           G   l   i   b   c   
                                   /   h   2   >   
                                   d   i   v       c   l   a   s   s   =   "   s   e   g   m   e   n   t   e   d   l   i   s   t   "   >   
                                           d   i   v       c   l   a   s   s   =   "   s   e   g   l   i   s   t   i   t   e   m   "   >   
                                                   d   i   v       c   l   a   s   s   =   "   s   e   g   "   >   
                                                           s   t   r   o   n   g       c   l   a   s   s   =   "   s   e   g   t   i   t   l   e   "   >   I   n   s   t   a   l   l   e   d       p   r   o   g   r   a   m   s   :   /   s   t   r   o   n   g   >   
                                                           s   p   a   n       c   l   a   s   s   =   "   s   e   g   b   o   d   y   "   >   c   a   t   c   h   s   e   g   v   ,       g   e   n   c   a   t   ,       g   e   t   c   o   n   f   ,       g   e   t   e   n   t   ,   
                                                           i   c   o   n   v   ,       i   c   o   n   v   c   o   n   f   i   g   ,       l   d   c   o   n   f   i   g   ,       l   d   d   ,       l   d   d   l   i   b   c   4   ,       l   o   c   a   l   e   ,       l   o   c   a   l   e   d   e   f   ,   
                                                           m   a   k   e   d   b   ,       m   t   r   a   c   e   ,       n   s   c   d   ,       p   c   p   r   o   f   i   l   e   d   u   m   p   ,       p   l   d   d   ,       s   l   n   ,       s   o   t   r   u   s   s   ,       s   p   r   o   f   ,   
                                                           t   z   s   e   l   e   c   t   ,       x   t   r   a   c   e   ,       z   d   u   m   p   ,       a   n   d       z   i   c   /   s   p   a   n   >   
                                                   /   d   i   v   >   
                                                   d   i   v       c   l   a   s   s   =   "   s   e   g   "   >   
                                                           s   t   r   o   n   g       c   l   a   s   s   =   "   s   e   g   t   i   t   l   e   "   >   I   n   s   t   a   l   l   e   d       l   i   b   r   a   r   i   e   s   :   /   s   t   r   o   n   g   >   
                                                           s   p   a   n       c   l   a   s   s   =   "   s   e   g   b   o   d   y   "   >   l   d   -   2   .   2   9   .   s   o   ,       l   i   b   B   r   o   k   e   n   L   o   c   a   l   e   .   {   a   ,   s   o   }   ,   
                                                           l   i   b   S   e   g   F   a   u   l   t   .   s   o   ,       l   i   b   a   n   l   .   {   a   ,   s   o   }   ,       l   i   b   c   .   {   a   ,   s   o   }   ,       l   i   b   c   _   n   o   n   s   h   a   r   e   d   .   a   ,   
                                                           l   i   b   c   r   y   p   t   .   {   a   ,   s   o   }   ,       l   i   b   d   l   .   {   a   ,   s   o   }   ,       l   i   b   g   .   a   ,       l   i   b   m   .   {   a   ,   s   o   }   ,   
                                                           l   i   b   m   c   h   e   c   k   .   a   ,       l   i   b   m   e   m   u   s   a   g   e   .   s   o   ,       l   i   b   m   v   e   c   .   {   a   ,   s   o   }   ,       l   i   b   n   s   l   .   {   a   ,   s   o   }   ,   
                                                           l   i   b   n   s   s   _   c   o   m   p   a   t   .   s   o   ,       l   i   b   n   s   s   _   d   n   s   .   s   o   ,       l   i   b   n   s   s   _   f   i   l   e   s   .   s   o   ,   
                                                           l   i   b   n   s   s   _   h   e   s   i   o   d   .   s   o   ,       l   i   b   p   c   p   r   o   f   i   l   e   .   s   o   ,       l   i   b   p   t   h   r   e   a   d   .   {   a   ,   s   o   }   ,   
                                                           l   i   b   p   t   h   r   e   a   d   _   n   o   n   s   h   a   r   e   d   .   a   ,       l   i   b   r   e   s   o   l   v   .   {   a   ,   s   o   }   ,       l   i   b   r   t   .   {   a   ,   s   o   }   ,   
                                                           l   i   b   t   h   r   e   a   d   _   d   b   .   s   o   ,       a   n   d       l   i   b   u   t   i   l   .   {   a   ,   s   o   }   /   s   p   a   n   >   
                                                   /   d   i   v   >   
                                                   d   i   v       c   l   a   s   s   =   "   s   e   g   "   >   
                                                           s   t   r   o   n   g       c   l   a   s   s   =   "   s   e   g   t   i   t   l   e   "   >   I   n   s   t   a   l   l   e   d       d   i   r   e   c   t   o   r   i   e   s   :   /   s   t   r   o   n   g   >   
                                                           s   p   a   n       c   l   a   s   s   =   "   s   e   g   b   o   d   y   "   >   /   u   s   r   /   i   n   c   l   u   d   e   /   a   r   p   a   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   b   i   t   s   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   g   n   u   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   a   s   h   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   a   t   a   l   k   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   a   x   2   5   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   e   c   o   n   e   t   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   i   n   e   t   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   i   p   x   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   i   u   c   v   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   p   a   c   k   e   t   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   r   o   m   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   n   e   t   r   o   s   e   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   n   f   s   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   p   r   o   t   o   c   o   l   s   ,   
                                                           /   u   s   r   /   i   n   c   l   u   d   e   /   r   p   c   ,       /   u   s   r   /   i   n   c   l   u   d   e   /   s   y   s   ,       /   u   s   r   /   l   i   b   /   a   u   d   i   t   ,   
                                                           /   u   s   r   /   l   i   b   /   g   c   o   n   v   ,       /   u   s   r   /   l   i   b   /   l   o   c   a   l   e   ,       /   u   s   r   /   l   i   b   e   x   e   c   /   g   e   t   c   o   n   f   ,   
                                                           /   u   s   r   /   s   h   a   r   e   /   i   1   8   n   ,       /   u   s   r   /   s   h   a   r   e   /   z   o   n   e   i   n   f   o   ,       /   v   a   r   /   c   a   c   h   e   /   n   s   c   d   ,       a   n   d   
                                                           /   v   a   r   /   l   i   b   /   n   s   s   _   d   b   /   s   p   a   n   >   
                                                   /   d   i   v   >   
                                           /   d   i   v   >   
                                   /   d   i   v   >   
                                   d   i   v       c   l   a   s   s   =   "   v   a   r   i   a   b   l   e   l   i   s   t   "   >   
                                           h   3   >   
                                                   S   h   o   r   t       D   e   s   c   r   i   p   t   i   o   n   s   
                                           /   h   3   >   
                                           t   a   b   l   e       b   o   r   d   e   r   =   "   0   "       c   l   a   s   s   =   "   v   a   r   i   a   b   l   e   l   i   s   t   "   >   
                                                   c   o   l   g   r   o   u   p   >   
                                                           c   o   l       a   l   i   g   n   =   "   l   e   f   t   "       v   a   l   i   g   n   =   "   t   o   p   "       /   >   
                                                           c   o   l       /   >   
                                                   /   c   o   l   g   r   o   u   p   >   
                                                   t   b   o   d   y   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   c   a   t   c   h   s   e   g   v   "       n   a   m   e   =   "   c   a   t   c   h   s   e   g   v   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   c   a   t   c   h   s   e   g   v   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   a   n       b   e       u   s   e   d       t   o       c   r   e   a   t   e       a       s   t   a   c   k       t   r   a   c   e       w   h   e   n       a       p   r   o   g   r   a   m   
                                                                                   t   e   r   m   i   n   a   t   e   s       w   i   t   h       a       s   e   g   m   e   n   t   a   t   i   o   n       f   a   u   l   t   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   g   e   n   c   a   t   "       n   a   m   e   =   "   g   e   n   c   a   t   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   g   e   n   c   a   t   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   G   e   n   e   r   a   t   e   s       m   e   s   s   a   g   e       c   a   t   a   l   o   g   u   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   g   e   t   c   o   n   f   "       n   a   m   e   =   "   g   e   t   c   o   n   f   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   g   e   t   c   o   n   f   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   D   i   s   p   l   a   y   s       t   h   e       s   y   s   t   e   m       c   o   n   f   i   g   u   r   a   t   i   o   n       v   a   l   u   e   s       f   o   r       f   i   l   e       s   y   s   t   e   m   
                                                                                   s   p   e   c   i   f   i   c       v   a   r   i   a   b   l   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   g   e   t   e   n   t   "       n   a   m   e   =   "   g   e   t   e   n   t   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   g   e   t   e   n   t   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   G   e   t   s       e   n   t   r   i   e   s       f   r   o   m       a   n       a   d   m   i   n   i   s   t   r   a   t   i   v   e       d   a   t   a   b   a   s   e   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   i   c   o   n   v   "       n   a   m   e   =   "   i   c   o   n   v   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   i   c   o   n   v   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   P   e   r   f   o   r   m   s       c   h   a   r   a   c   t   e   r       s   e   t       c   o   n   v   e   r   s   i   o   n   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   i   c   o   n   v   c   o   n   f   i   g   "       n   a   m   e   =   "   i   c   o   n   v   c   o   n   f   i   g   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   i   c   o   n   v   c   o   n   f   i   g   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   r   e   a   t   e   s       f   a   s   t   l   o   a   d   i   n   g       s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   i   c   o   n   v   /   s   t   r   o   n   g   >   /   s   p   a   n   >       m   o   d   u   l   e   
                                                                                   c   o   n   f   i   g   u   r   a   t   i   o   n       f   i   l   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   d   c   o   n   f   i   g   "       n   a   m   e   =   "   l   d   c   o   n   f   i   g   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   d   c   o   n   f   i   g   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   o   n   f   i   g   u   r   e   s       t   h   e       d   y   n   a   m   i   c       l   i   n   k   e   r       r   u   n   t   i   m   e       b   i   n   d   i   n   g   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   d   d   "       n   a   m   e   =   "   l   d   d   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   d   d   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   R   e   p   o   r   t   s       w   h   i   c   h       s   h   a   r   e   d       l   i   b   r   a   r   i   e   s       a   r   e       r   e   q   u   i   r   e   d       b   y       e   a   c   h       g   i   v   e   n   
                                                                                   p   r   o   g   r   a   m       o   r       s   h   a   r   e   d       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   d   d   l   i   b   c   4   "       n   a   m   e   =   "   l   d   d   l   i   b   c   4   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   d   d   l   i   b   c   4   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   A   s   s   i   s   t   s       s   p   a   n       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   d   d   /   s   t   r   o   n   g   >   /   s   p   a   n   >   
                                                                                   w   i   t   h       o   b   j   e   c   t       f   i   l   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   o   c   a   l   e   "       n   a   m   e   =   "   l   o   c   a   l   e   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   o   c   a   l   e   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   P   r   i   n   t   s       v   a   r   i   o   u   s       i   n   f   o   r   m   a   t   i   o   n       a   b   o   u   t       t   h   e       c   u   r   r   e   n   t       l   o   c   a   l   e   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   o   c   a   l   e   d   e   f   "       n   a   m   e   =   "   l   o   c   a   l   e   d   e   f   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   o   c   a   l   e   d   e   f   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   o   m   p   i   l   e   s       l   o   c   a   l   e       s   p   e   c   i   f   i   c   a   t   i   o   n   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   m   a   k   e   d   b   "       n   a   m   e   =   "   m   a   k   e   d   b   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   m   a   k   e   d   b   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   r   e   a   t   e   s       a       s   i   m   p   l   e       d   a   t   a   b   a   s   e       f   r   o   m       t   e   x   t   u   a   l       i   n   p   u   t   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   m   t   r   a   c   e   "       n   a   m   e   =   "   m   t   r   a   c   e   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   m   t   r   a   c   e   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   R   e   a   d   s       a   n   d       i   n   t   e   r   p   r   e   t   s       a       m   e   m   o   r   y       t   r   a   c   e       f   i   l   e       a   n   d       d   i   s   p   l   a   y   s       a   
                                                                                   s   u   m   m   a   r   y       i   n       h   u   m   a   n   -   r   e   a   d   a   b   l   e       f   o   r   m   a   t   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   n   s   c   d   "       n   a   m   e   =   "   n   s   c   d   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   n   s   c   d   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   A       d   a   e   m   o   n       t   h   a   t       p   r   o   v   i   d   e   s       a       c   a   c   h   e       f   o   r       t   h   e       m   o   s   t       c   o   m   m   o   n       n   a   m   e   
                                                                                   s   e   r   v   i   c   e       r   e   q   u   e   s   t   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   p   c   p   r   o   f   i   l   e   d   u   m   p   "       n   a   m   e   =   
                                                                                   "   p   c   p   r   o   f   i   l   e   d   u   m   p   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   p   c   p   r   o   f   i   l   e   d   u   m   p   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   D   u   m   p       i   n   f   o   r   m   a   t   i   o   n       g   e   n   e   r   a   t   e   d       b   y       P   C       p   r   o   f   i   l   i   n   g   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   p   l   d   d   "       n   a   m   e   =   "   p   l   d   d   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   p   l   d   d   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   L   i   s   t   s       d   y   n   a   m   i   c       s   h   a   r   e   d       o   b   j   e   c   t   s       u   s   e   d       b   y       r   u   n   n   i   n   g       p   r   o   c   e   s   s   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   s   l   n   "       n   a   m   e   =   "   s   l   n   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   s   l   n   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   A       s   t   a   t   i   c   a   l   l   y       l   i   n   k   e   d       s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   l   n   /   s   t   r   o   n   g   >   /   s   p   a   n   >       p   r   o   g   r   a   m   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   s   o   t   r   u   s   s   "       n   a   m   e   =   "   s   o   t   r   u   s   s   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   s   o   t   r   u   s   s   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   r   a   c   e   s       s   h   a   r   e   d       l   i   b   r   a   r   y       p   r   o   c   e   d   u   r   e       c   a   l   l   s       o   f       a       s   p   e   c   i   f   i   e   d   
                                                                                   c   o   m   m   a   n   d   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   s   p   r   o   f   "       n   a   m   e   =   "   s   p   r   o   f   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   s   p   r   o   f   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   R   e   a   d   s       a   n   d       d   i   s   p   l   a   y   s       s   h   a   r   e   d       o   b   j   e   c   t       p   r   o   f   i   l   i   n   g       d   a   t   a   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   t   z   s   e   l   e   c   t   "       n   a   m   e   =   "   t   z   s   e   l   e   c   t   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   t   z   s   e   l   e   c   t   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   A   s   k   s       t   h   e       u   s   e   r       a   b   o   u   t       t   h   e       l   o   c   a   t   i   o   n       o   f       t   h   e       s   y   s   t   e   m       a   n   d   
                                                                                   r   e   p   o   r   t   s       t   h   e       c   o   r   r   e   s   p   o   n   d   i   n   g       t   i   m   e       z   o   n   e       d   e   s   c   r   i   p   t   i   o   n   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   x   t   r   a   c   e   "       n   a   m   e   =   "   x   t   r   a   c   e   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   x   t   r   a   c   e   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   r   a   c   e   s       t   h   e       e   x   e   c   u   t   i   o   n       o   f       a       p   r   o   g   r   a   m       b   y       p   r   i   n   t   i   n   g       t   h   e   
                                                                                   c   u   r   r   e   n   t   l   y       e   x   e   c   u   t   e   d       f   u   n   c   t   i   o   n   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   z   d   u   m   p   "       n   a   m   e   =   "   z   d   u   m   p   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   z   d   u   m   p   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       t   i   m   e       z   o   n   e       d   u   m   p   e   r   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   z   i   c   "       n   a   m   e   =   "   z   i   c   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   s   p   a   n       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   z   i   c   /   s   t   r   o   n   g   >   /   s   p   a   n   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       t   i   m   e       z   o   n   e       c   o   m   p   i   l   e   r   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   d   .   s   o   "       n   a   m   e   =   "   l   d   .   s   o   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   d   -   2   .   2   9   .   s   o   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       h   e   l   p   e   r       p   r   o   g   r   a   m       f   o   r       s   h   a   r   e   d       l   i   b   r   a   r   y       e   x   e   c   u   t   a   b   l   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   B   r   o   k   e   n   L   o   c   a   l   e   "       n   a   m   e   =   
                                                                                   "   l   i   b   B   r   o   k   e   n   L   o   c   a   l   e   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   
                                                                                   "   f   i   l   e   n   a   m   e   "   >   l   i   b   B   r   o   k   e   n   L   o   c   a   l   e   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   U   s   e   d       i   n   t   e   r   n   a   l   l   y       b   y       G   l   i   b   c       a   s       a       g   r   o   s   s       h   a   c   k       t   o       g   e   t       b   r   o   k   e   n   
                                                                                   p   r   o   g   r   a   m   s       (   e   .   g   .   ,       s   o   m   e       M   o   t   i   f       a   p   p   l   i   c   a   t   i   o   n   s   )       r   u   n   n   i   n   g   .       S   e   e   
                                                                                   c   o   m   m   e   n   t   s       i   n       c   o   d   e       c   l   a   s   s   =   
                                                                                   "   f   i   l   e   n   a   m   e   "   >   g   l   i   b   c   -   2   .   2   9   /   l   o   c   a   l   e   /   b   r   o   k   e   n   _   c   u   r   _   m   a   x   .   c   /   c   o   d   e   >       f   o   r   
                                                                                   m   o   r   e       i   n   f   o   r   m   a   t   i   o   n   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   S   e   g   F   a   u   l   t   "       n   a   m   e   =   "   l   i   b   S   e   g   F   a   u   l   t   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   S   e   g   F   a   u   l   t   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       s   e   g   m   e   n   t   a   t   i   o   n       f   a   u   l   t       s   i   g   n   a   l       h   a   n   d   l   e   r   ,       u   s   e   d       b   y   
                                                                                   s   p   a   n       c   l   a   s   s   =   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   c   a   t   c   h   s   e   g   v   /   s   t   r   o   n   g   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   a   n   l   "       n   a   m   e   =   "   l   i   b   a   n   l   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   a   n   l   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   A   n       a   s   y   n   c   h   r   o   n   o   u   s       n   a   m   e       l   o   o   k   u   p       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   c   "       n   a   m   e   =   "   l   i   b   c   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   c   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       m   a   i   n       C       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   c   r   y   p   t   "       n   a   m   e   =   "   l   i   b   c   r   y   p   t   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   c   r   y   p   t   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       c   r   y   p   t   o   g   r   a   p   h   y       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   d   l   "       n   a   m   e   =   "   l   i   b   d   l   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   d   l   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       d   y   n   a   m   i   c       l   i   n   k   i   n   g       i   n   t   e   r   f   a   c   e       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   g   "       n   a   m   e   =   "   l   i   b   g   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   g   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   D   u   m   m   y       l   i   b   r   a   r   y       c   o   n   t   a   i   n   i   n   g       n   o       f   u   n   c   t   i   o   n   s   .       P   r   e   v   i   o   u   s   l   y       w   a   s       a   
                                                                                   r   u   n   t   i   m   e       l   i   b   r   a   r   y       f   o   r       s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   g   +   +   /   s   t   r   o   n   g   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   m   "       n   a   m   e   =   "   l   i   b   m   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   m   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       m   a   t   h   e   m   a   t   i   c   a   l       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   m   c   h   e   c   k   "       n   a   m   e   =   "   l   i   b   m   c   h   e   c   k   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   m   c   h   e   c   k   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   u   r   n   s       o   n       m   e   m   o   r   y       a   l   l   o   c   a   t   i   o   n       c   h   e   c   k   i   n   g       w   h   e   n       l   i   n   k   e   d       t   o   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   m   e   m   u   s   a   g   e   "       n   a   m   e   =   "   l   i   b   m   e   m   u   s   a   g   e   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   m   e   m   u   s   a   g   e   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   U   s   e   d       b   y       s   p   a   n       c   l   a   s   s   =   
                                                                                   "   c   o   m   m   a   n   d   "   >   s   t   r   o   n   g   >   m   e   m   u   s   a   g   e   /   s   t   r   o   n   g   >   /   s   p   a   n   >       t   o       h   e   l   p   
                                                                                   c   o   l   l   e   c   t       i   n   f   o   r   m   a   t   i   o   n       a   b   o   u   t       t   h   e       m   e   m   o   r   y       u   s   a   g   e       o   f       a       p   r   o   g   r   a   m   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   n   s   l   "       n   a   m   e   =   "   l   i   b   n   s   l   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   n   s   l   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       n   e   t   w   o   r   k       s   e   r   v   i   c   e   s       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   n   s   s   "       n   a   m   e   =   "   l   i   b   n   s   s   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   n   s   s   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       N   a   m   e       S   e   r   v   i   c   e       S   w   i   t   c   h       l   i   b   r   a   r   i   e   s   ,       c   o   n   t   a   i   n   i   n   g       f   u   n   c   t   i   o   n   s   
                                                                                   f   o   r       r   e   s   o   l   v   i   n   g       h   o   s   t       n   a   m   e   s   ,       u   s   e   r       n   a   m   e   s   ,       g   r   o   u   p       n   a   m   e   s   ,   
                                                                                   a   l   i   a   s   e   s   ,       s   e   r   v   i   c   e   s   ,       p   r   o   t   o   c   o   l   s   ,       e   t   c   .   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   p   c   p   r   o   f   i   l   e   "       n   a   m   e   =   "   l   i   b   p   c   p   r   o   f   i   l   e   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   p   c   p   r   o   f   i   l   e   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   a   n       b   e       p   r   e   l   o   a   d   e   d       t   o       P   C       p   r   o   f   i   l   e       a   n       e   x   e   c   u   t   a   b   l   e   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   p   t   h   r   e   a   d   "       n   a   m   e   =   "   l   i   b   p   t   h   r   e   a   d   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   p   t   h   r   e   a   d   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   T   h   e       P   O   S   I   X       t   h   r   e   a   d   s       l   i   b   r   a   r   y   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   r   e   s   o   l   v   "       n   a   m   e   =   "   l   i   b   r   e   s   o   l   v   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   r   e   s   o   l   v   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   o   n   t   a   i   n   s       f   u   n   c   t   i   o   n   s       f   o   r       c   r   e   a   t   i   n   g   ,       s   e   n   d   i   n   g   ,       a   n   d   
                                                                                   i   n   t   e   r   p   r   e   t   i   n   g       p   a   c   k   e   t   s       t   o       t   h   e       I   n   t   e   r   n   e   t       d   o   m   a   i   n       n   a   m   e       s   e   r   v   e   r   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   r   t   "       n   a   m   e   =   "   l   i   b   r   t   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   r   t   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   o   n   t   a   i   n   s       f   u   n   c   t   i   o   n   s       p   r   o   v   i   d   i   n   g       m   o   s   t       o   f       t   h   e       i   n   t   e   r   f   a   c   e   s   
                                                                                   s   p   e   c   i   f   i   e   d       b   y       t   h   e       P   O   S   I   X   .   1   b       R   e   a   l   t   i   m   e       E   x   t   e   n   s   i   o   n   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   t   h   r   e   a   d   _   d   b   "       n   a   m   e   =   "   l   i   b   t   h   r   e   a   d   _   d   b   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   t   h   r   e   a   d   _   d   b   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   o   n   t   a   i   n   s       f   u   n   c   t   i   o   n   s       u   s   e   f   u   l       f   o   r       b   u   i   l   d   i   n   g       d   e   b   u   g   g   e   r   s       f   o   r   
                                                                                   m   u   l   t   i   -   t   h   r   e   a   d   e   d       p   r   o   g   r   a   m   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                           t   r   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   a       i   d   =   "   l   i   b   u   t   i   l   "       n   a   m   e   =   "   l   i   b   u   t   i   l   "   >   /   a   >   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   t   e   r   m   "   >   c   o   d   e       c   l   a   s   s   =   "   f   i   l   e   n   a   m   e   "   >   l   i   b   u   t   i   l   /   c   o   d   e   >   /   s   p   a   n   >   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                                   t   d   >   
                                                                           p   >   
                                                                                   C   o   n   t   a   i   n   s       c   o   d   e       f   o   r       s   p   a   n       c   l   a   s   s   =   "   q   u   o   t   e   "   >   &l   d   q   u   o   ;   s   p   a   n       c   l   a   s   s   =   
                                                                                   "   q   u   o   t   e   "   >   s   t   a   n   d   a   r   d   /   s   p   a   n   >   &r   d   q   u   o   ;   /   s   p   a   n   >       f   u   n   c   t   i   o   n   s       u   s   e   d       i   n   
                                                                                   m   a   n   y       d   i   f   f   e   r   e   n   t       U   n   i   x       u   t   i   l   i   t   i   e   s   
                                                                           /   p   >   
                                                                   /   t   d   >   
                                                           /   t   r   >   
                                                   /   t   b   o   d   y   >   
                                           /   t   a   b   l   e   >   
                                   /   d   i   v   >   
                           /   d   i   v   >   
                   /   d   i   v   >   
                   d   i   v       c   l   a   s   s   =   "   n   a   v   f   o   o   t   e   r   "   >   
                           u   l   >   
                                   l   i       c   l   a   s   s   =   "   p   r   e   v   "   >   
                                           a       a   c   c   e   s   s   k   e   y   =   "   p   "       h   r   e   f   =   "   m   a   n   -   p   a   g   e   s   .   h   t   m   l   "       t   i   t   l   e   =   
                                           "   M   a   n   -   p   a   g   e   s   -   5   .   0   1   "   >   P   r   e   v   /   a   >   
                                           p   >   
                                                   M   a   n   -   p   a   g   e   s   -   5   .   0   1   
                                           /   p   >   
                                   /   l   i   >   
                                   l   i       c   l   a   s   s   =   "   n   e   x   t   "   >   
                                           a       a   c   c   e   s   s   k   e   y   =   "   n   "       h   r   e   f   =   "   a   d   j   u   s   t   i   n   g   .   h   t   m   l   "       t   i   t   l   e   =   
                                           "   A   d   j   u   s   t   i   n   g       t   h   e       T   o   o   l   c   h   a   i   n   "   >   N   e   x   t   /   a   >   
                                           p   >   
                                                   A   d   j   u   s   t   i   n   g       t   h   e       T   o   o   l   c   h   a   i   n   
                                           /   p   >   
                                   /   l   i   >   
                                   l   i       c   l   a   s   s   =   "   u   p   "   >   
                                           a       a   c   c   e   s   s   k   e   y   =   "   u   "       h   r   e   f   =   "   c   h   a   p   t   e   r   0   6   .   h   t   m   l   "       t   i   t   l   e   =   
                                           "   C   h   a   p   t   e   r   &n   b   s   p   ;   6   .   &n   b   s   p   ;   I   n   s   t   a   l   l   i   n   g       B   a   s   i   c       S   y   s   t   e   m       S   o   f   t   w   a   r   e   "   >   U   p   /   a   >   
                                   /   l   i   >   
                                   l   i       c   l   a   s   s   =   "   h   o   m   e   "   >   
                                           a       a   c   c   e   s   s   k   e   y   =   "   h   "       h   r   e   f   =   "   .   .   /   i   n   d   e   x   .   h   t   m   l   "       t   i   t   l   e   =   
                                           "   L   i   n   u   x       F   r   o   m       S   c   r   a   t   c   h       -       V   e   r   s   i   o   n       2   0   1   9   0   6   0   3   -   s   y   s   t   e   m   d   "   >   H   o   m   e   /   a   >   
                                   /   l   i   >   
                           /   u   l   >   
                   /   d   i   v   >   
           /   b   o   d   y   >   
   /   h   t   m   l   >

fi

cleanup $DIRECTORY
log $NAME