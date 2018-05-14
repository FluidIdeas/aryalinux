#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak SWIG (Simplified Wrapper andbr3ak Interface Generator) is a compiler that integrates C and C++br3ak with languages including Perl,br3ak Python, Tcl, Ruby,br3ak PHP, Java, C#,br3ak D, Go, Lua,br3ak Octave, R, Scheme,br3ak Ocaml, Modula-3, Commonbr3ak Lisp, and Pike.br3ak SWIG can also export its parsebr3ak tree into Lisp s-expressions andbr3ak XML.br3ak"
SECTION="general"
VERSION=3.0.12
NAME="swig"

#REQ:pcre
#OPT:boost


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/swig/swig-3.0.12.tar.gz

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/swig/swig-3.0.12.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/swig/swig-3.0.12.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/swig/swig-3.0.12.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/swig/swig-3.0.12.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/swig/swig-3.0.12.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.12.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/swig/swig-3.0.12.tar.gz

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

sed -i 's/\$(PERL5_SCRIPT/-I. &/' Examples/Makefile.in &&
sed -i 's/\$command 2/-I. &/' Examples/test-suite/perl5/run-perl-test.pl


./configure --prefix=/usr                      \
            --without-clisp                    \
            --without-maximum-compile-warnings &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/swig-3.0.12 &&
cp -v -R Doc/* /usr/share/doc/swig-3.0.12

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
