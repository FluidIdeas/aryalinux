#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Tcl package contains the Toolbr3ak Command Language, a robust general-purpose scripting language.br3ak"
SECTION="general"
VERSION=8.6.8
NAME="tcl"



cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.8-src.tar.gz
wget -nc https://downloads.sourceforge.net/tcl/tcl8.6.8-html.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tcl/tcl8.6.8-html.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/tcl/tcl8.6.8-html.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.8-html.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tcl/tcl8.6.8-html.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.8-html.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tcl/tcl8.6.8-html.tar.gz

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

tar -xf ../tcl8.6.8-html.tar.gz --strip-components=1


export SRCDIR=`pwd` &&
cd unix &&
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make &&
sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&
sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.6#/usr/lib/tdbc1.0.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.6/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.0.6/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.6#/usr/include#"            \
    -i pkgs/tdbc1.0.6/tdbcConfig.sh                        &&
sed -e "s#$SRCDIR/unix/pkgs/itcl4.1.1#/usr/lib/itcl4.1.1#" \
    -e "s#$SRCDIR/pkgs/itcl4.1.1/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.1.1#/usr/include#"            \
    -i pkgs/itcl4.1.1/itclConfig.sh                        &&
unset SRCDIR



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
make install-private-headers &&
ln -v -sf tclsh8.6 /usr/bin/tclsh &&
chmod -v 755 /usr/lib/libtcl8.6.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -v -p /usr/share/doc/tcl-8.6.8 &&
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
