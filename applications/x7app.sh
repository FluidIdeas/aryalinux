#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:libpng
#REQ:mesa
#REQ:xbitmaps
#REQ:xcb-util

cd $SOURCE_DIR



NAME=x7app
VERSION=
URL=

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > app-7.md5 << "EOF"
3b9b79fa0f9928161f4bad94273de7ae iceauth-1.0.8.tar.bz2
c4a3664e08e5a47c120ff9263ee2f20c luit-1.1.1.tar.bz2
18c429148c96c2079edda922a2b67632 mkfontdir-1.0.7.tar.bz2
efd40fd15dc5fc97c7b50cffbc1e7663 mkfontscale-1.2.0.tar.bz2
e475167a892b589da23edf8edf8c942d sessreg-1.1.1.tar.bz2
2c47a1b8e268df73963c4eb2316b1a89 setxkbmap-1.3.1.tar.bz2
3a93d9f0859de5d8b65a68a125d48f6a smproxy-1.0.6.tar.bz2
e96b56756990c56c24d2d02c2964456b x11perf-1.6.1.tar.bz2
f3f76cb10f69b571c43893ea6a634aa4 xauth-1.0.10.tar.bz2
d50cf135af04436b9456a5ab7dcf7971 xbacklight-1.2.2.tar.bz2
9956d751ea3ae4538c3ebd07f70736a0 xcmsdb-1.0.5.tar.bz2
25cc7ca1ce5dcbb61c2b471c55e686b5 xcursorgen-1.0.7.tar.bz2
8809037bd48599af55dad81c508b6b39 xdpyinfo-1.3.2.tar.bz2
480e63cd365f03eb2515a6527d5f4ca6 xdriinfo-1.0.6.tar.bz2
eec82a5d4b599736f0fa637e96136746 xev-1.2.3.tar.bz2
90b4305157c2b966d5180e2ee61262be xgamma-1.0.6.tar.bz2
a48c72954ae6665e0616f6653636da8c xhost-1.0.8.tar.bz2
6a889412eff2e3c1c6bb19146f6fe84c xinput-1.6.2.tar.bz2
12610df19df2af3797f2c130ee2bce97 xkbcomp-1.4.2.tar.bz2
c747faf1f78f5a5962419f8bdd066501 xkbevd-1.1.4.tar.bz2
502b14843f610af977dffc6cbf2102d5 xkbutils-1.0.4.tar.bz2
938177e4472c346cf031c1aefd8934fc xkill-1.0.5.tar.bz2
61671fee12535347db24ec3a715032a7 xlsatoms-1.1.3.tar.bz2
4fa92377e0ddc137cd226a7a87b6b29a xlsclients-1.1.4.tar.bz2
e50ffae17eeb3943079620cb78f5ce0b xmessage-1.0.5.tar.bz2
51f1d30a525e9903280ffeea2744b1f6 xmodmap-1.0.10.tar.bz2
eaac255076ea351fd08d76025788d9f9 xpr-1.0.5.tar.bz2
cc369c28383a5d7144e7197ee7d30bfa xprop-1.2.4.tar.bz2
ebffac98021b8f1dc71da0c1918e9b57 xrandr-1.5.0.tar.bz2
34ae801ef994d192c70fcce2bdb2a1b2 xrdb-1.2.0.tar.bz2
c56fa4adbeed1ee5173f464a4c4a61a6 xrefresh-1.0.6.tar.bz2
70ea7bc7bacf1a124b1692605883f620 xset-1.2.4.tar.bz2
5fe769c8777a6e873ed1305e4ce2c353 xsetroot-1.1.2.tar.bz2
b13afec137b9b331814a9824ab03ec80 xvinfo-1.1.4.tar.bz2
11794a8eba6d295a192a8975287fd947 xwd-1.0.7.tar.bz2
9a505b91ae7160bbdec360968d060c83 xwininfo-1.1.4.tar.bz2
79972093bb0766fcd0223b2bd6d11932 xwud-1.0.5.tar.bz2
EOF
mkdir -pv app &&
cd app &&
grep -v '^#' ../app-7.md5 | awk '{print $2}' | wget -i- -c \
-B https://www.x.org/pub/individual/app/ &&
md5sum -c ../app-7.md5
as_root()
{
if [ $EUID = 0 ]; then $*
elif [ -x /usr/bin/sudo ]; then sudo $*
else su -c \\"$*\\"
fi
}

export -f as_root
for package in $(grep -v '^#' ../app-7.md5 | awk '{print $2}')
do
packagedir=${package%.tar.bz2}
tar -xf $package
pushd $packagedir
case $packagedir in
luit-[0-9]* )
sed -i -e "/D_XOPEN/s/5/6/" configure
;;
esac

./configure $XORG_CONFIG
make
as_root make install
popd
rm -rf $packagedir
done
as_root rm -f $XORG_PREFIX/bin/xkeystone

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
