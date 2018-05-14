#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
DESCRIPTION="br3ak The DocBook-utils package is abr3ak collection of utility scripts used to convert and analyze SGMLbr3ak documents in general, and DocBook files in particular. The scriptsbr3ak are used to convert from DocBook or other SGML formats intobr3ak “<span class=\"quote\">classical” file formatsbr3ak like HTML, man, info, RTF and many more. There's also a utility tobr3ak compare two SGML files and only display the differences in markup.br3ak This is useful for comparing documents prepared for differentbr3ak languages.br3ak"
SECTION="pst"
VERSION=0.6.14
NAME="docbook-utils"

#REQ:openjade
#REQ:docbook-dsssl
#REQ:sgml-dtd-3
#OPT:perl-modules#perl-sgmlspm
#OPT:lynx
#OPT:links
#OPT:w3m


cd $SOURCE_DIR

URL=https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz

if [ ! -z $URL ]
then
wget -nc https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc ftp://sourceware.org/pub/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/docbook-utils-0.6.14-grep_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/docbook-utils/docbook-utils-0.6.14-grep_fix-1.patch

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

patch -Np1 -i ../docbook-utils-0.6.14-grep_fix-1.patch &&
sed -i 's:/html::' doc/HTML/Makefile.in                &&
./configure --prefix=/usr --mandir=/usr/share/man      &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for doctype in html ps dvi man pdf rtf tex texi txt
do
    ln -svf docbook2$doctype /usr/bin/db2$doctype
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
