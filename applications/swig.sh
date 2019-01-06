#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:pcre
#OPT:boost

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/swig/swig-3.0.12.tar.gz

NAME=swig
VERSION=3.0.12
URL=https://downloads.sourceforge.net/swig/swig-3.0.12.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sed -i 's/\$(PERL5_SCRIPT/-I. &/' Examples/Makefile.in &&
sed -i 's/\$command 2/-I. &/' Examples/test-suite/perl5/run-perl-test.pl
./configure --prefix=/usr \
--without-clisp \
--without-maximum-compile-warnings &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m755 -d /usr/share/doc/swig-3.0.12 &&
cp -v -R Doc/* /usr/share/doc/swig-3.0.12
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
