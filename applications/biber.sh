#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:perl-autovivification
#REQ:perl-business-isbn
#REQ:perl-business-ismn
#REQ:perl-business-issn
#REQ:perl-class-accessor
#REQ:perl-data-compare
#REQ:perl-data-dump
#REQ:perl-data-uniqid
#REQ:perl-datetime-calendar-julian
#REQ:perl-datetime-format-builder
#REQ:perl-encode-eucjpascii
#REQ:perl-encode-hanextra
#REQ:perl-encode-jis2k
#REQ:perl-file-slurper
#REQ:perl-perlio-utf8_strict
#REQ:perl-ipc-run3
#REQ:perl-lingua-translit
#REQ:perl-list-allutils
#REQ:perl-list-moreutils
#REQ:perl-log-log4perl
#REQ:perl-lwp-protocol-https
#REQ:perl-module-build
#REQ:perl-regexp-common
#REQ:perl-sort-key
#REQ:perl-text-bibtex
#REQ:perl-text-csv
#REQ:perl-text-roman
#REQ:perl-unicode-collate
#REQ:perl-unicode-linebreak
#REQ:perl-xml-libxml-simple
#REQ:perl-xml-libxslt
#REQ:perl-xml-writer
#REQ:texlive
#REQ:tl-installer
#REC:perl-file-which
#REC:perl-test-differences

cd $SOURCE_DIR

wget -nc https://github.com/plk/biber/archive/v2.12.tar.gz
wget -nc http://sourceforge.net/projects/biblatex/files/biblatex-3.12/biblatex-3.12.tds.tgz

NAME=biber
VERSION=2.12
URL=https://github.com/plk/biber/archive/v2.12.tar.gz

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


perl ./Build.PL &&
./Build

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../biblatex-3.12.tds.tgz -C /opt/texlive/2018/texmf-dist &&
texhash &&
./Build install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
