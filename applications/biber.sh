#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Biber is a BibTeX replacement for users of biblatex, written inbr3ak Perl, with full Unicode support.br3ak"
SECTION="pst"
VERSION=2.11
NAME="biber"

#REQ:perl-modules#perl-autovivification
#REQ:perl-modules#perl-business-isbn
#REQ:perl-modules#perl-business-ismn
#REQ:perl-modules#perl-business-issn
#REQ:perl-modules#perl-class-accessor
#REQ:perl-modules#perl-data-compare
#REQ:perl-modules#perl-data-dump
#REQ:perl-modules#perl-data-uniqid
#REQ:perl-modules#perl-datetime-calendar-julian
#REQ:perl-modules#perl-datetime-format-builder
#REQ:perl-modules#perl-encode-eucjpascii
#REQ:perl-modules#perl-encode-hanextra
#REQ:perl-modules#perl-encode-jis2k
#REQ:perl-modules#perl-file-slurper
#REQ:perl-modules#perl-ipc-run3
#REQ:perl-modules#perl-lingua-translit
#REQ:perl-modules#perl-list-allutils
#REQ:perl-modules#perl-list-moreutils
#REQ:perl-modules#perl-log-log4perl
#REQ:perl-modules#perl-lwp-protocol-https
#REQ:perl-modules#perl-module-build
#REQ:perl-modules#perl-perlio-utf8_strict
#REQ:perl-modules#perl-regexp-common
#REQ:perl-modules#perl-sort-key
#REQ:perl-modules#perl-text-bibtex
#REQ:perl-modules#perl-text-csv
#REQ:perl-modules#perl-text-roman
#REQ:perl-modules#perl-unicode-collate
#REQ:perl-modules#perl-unicode-linebreak
#REQ:perl-modules#perl-xml-libxml-simple
#REQ:perl-modules#perl-xml-libxslt
#REQ:perl-modules#perl-xml-writer
#REQ:texlive
#REQ:tl-installer
#OPT:perl-modules#perl-file-which
#OPT:perl-modules#perl-test-differences


cd $SOURCE_DIR

URL=https://github.com/plk/biber/archive/v2.11.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/plk/biber/archive/v2.11.tar.gz
wget -nc http://sourceforge.net/projects/biblatex/files/biblatex-3.11/biblatex-3.11.tds.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/biblatex/biblatex-3.11.tds.tgz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/biblatex/biblatex-3.11.tds.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/biblatex/biblatex-3.11.tds.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/biblatex/biblatex-3.11.tds.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/biblatex/biblatex-3.11.tds.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/biblatex/biblatex-3.11.tds.tgz

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

wget -c https://github.com/plk/biber/archive/v2.11.tar.gz \
     -O biber-2.11.tar.gz


perl ./Build.PL &&
./Build



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../biblatex-3.11.tds.tgz -C /opt/texlive/2017/texmf-dist &&
texhash &&
./Build install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
