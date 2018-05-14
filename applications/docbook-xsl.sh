#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=y
DESCRIPTION="br3ak The DocBook XSL Stylesheetsbr3ak package contains XSL stylesheets. These are useful for performingbr3ak transformations on XML DocBook files.br3ak"
SECTION="pst"
VERSION=1.79.2
NAME="docbook-xsl"

#REC:libxml2
#OPT:apache-ant
#OPT:libxslt
#OPT:python2
#OPT:ruby
#OPT:zip


cd $SOURCE_DIR

URL=https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-1.79.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-1.79.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-xsl/docbook-xsl-1.79.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook-xsl/docbook-xsl-1.79.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-xsl/docbook-xsl-1.79.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-xsl/docbook-xsl-1.79.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-xsl/docbook-xsl-1.79.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-xsl/docbook-xsl-1.79.2.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/docbook-xsl-1.79.2-stack_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/docbook-xsl/docbook-xsl-1.79.2-stack_fix-1.patch
wget -nc https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-doc-1.79.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-xsl-doc/docbook-xsl-doc-1.79.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/docbook-xsl-doc/docbook-xsl-doc-1.79.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-xsl-doc/docbook-xsl-doc-1.79.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-xsl-doc/docbook-xsl-doc-1.79.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-xsl-doc/docbook-xsl-doc-1.79.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-xsl-doc/docbook-xsl-doc-1.79.2.tar.bz2

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

patch -Np1 -i ../docbook-xsl-1.79.2-stack_fix-1.patch


tar -xf ../docbook-xsl-doc-1.79.2.tar.bz2 --strip-components=1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-1.79.2 &&
cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
    /usr/share/xml/docbook/xsl-stylesheets-1.79.2 &&
ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-1.79.2/VERSION.xsl &&
install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-1.79.2/README.txt &&
install -v -m644    RELEASE-NOTES* NEWS* \
                    /usr/share/doc/docbook-xsl-1.79.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v -R doc/* /usr/share/doc/docbook-xsl-1.79.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
fi &&
xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
