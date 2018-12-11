#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Xorg font packages providebr3ak some scalable fonts and supporting packages for Xorg applications. Many people will want tobr3ak install other TTF or OTF fonts in addition to, or instead of,br3ak these. Some are listed at <a class=\"xref\" href=\"TTF-and-OTF-fonts.html\" title=\"TTF and OTF fonts\">the sectionbr3ak called “TTF and OTF fonts”</a>.br3ak"
SECTION="x"
NAME="x7font"

#REQ:xcursor-themes


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > font-7.md5 << "EOF"
23756dab809f9ec5011bb27fb2c3c7d6 font-util-1.3.1.tar.bz2
0f2d6546d514c5cc4ecf78a60657a5c1 encodings-1.0.4.tar.bz2
6d25f64796fef34b53b439c2e9efa562 font-alias-1.0.3.tar.bz2
fcf24554c348df3c689b91596d7f9971 font-adobe-utopia-type1-1.0.4.tar.bz2
e8ca58ea0d3726b94fe9f2c17344be60 font-bh-ttf-1.0.3.tar.bz2
53ed9a42388b7ebb689bdfc374f96a22 font-bh-type1-1.0.3.tar.bz2
bfb2593d2102585f45daa960f43cb3c4 font-ibm-type1-1.0.3.tar.bz2
6306c808f7d7e7d660dfb3859f9091d2 font-misc-ethiopic-1.0.3.tar.bz2
3eeb3fb44690b477d510bbd8f86cf5aa font-xfree86-type1-1.0.4.tar.bz2
EOF


mkdir -pv font &&
cd font &&
grep -v '^#' ../font-7.md5 | awk '{print $2}' | wget -i- -nc \
    -B https://www.x.org/pub/individual/font/ &&
md5sum -c ../font-7.md5


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root





for package in $(grep -v '^#' ../font-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static
    make "-j`nproc`" || make
    as_root make install
  popd
  as_root rm -rf $packagedir
done






sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/fonts                               &&
ln -svfn /usr/share/fonts/X11/OTF /usr/share/fonts/X11-OTF &&
ln -svfn /usr/share/fonts/X11/TTF /usr/share/fonts/X11-TTF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
