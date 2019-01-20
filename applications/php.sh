#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:apache
#REC:libxml2
#OPT:aspell
#OPT:enchant
#OPT:libxslt
#OPT:mail
#OPT:pcre
#OPT:pth
#OPT:freetype2
#OPT:libexif
#OPT:libjpeg
#OPT:libpng
#OPT:libtiff
#OPT:fdftoolkit
#OPT:curl
#OPT:tidy-html5
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:unixodbc
#OPT:cdb
#OPT:cyrus-sasl
#OPT:mitkrb

cd $SOURCE_DIR

wget -nc http://www.php.net/distributions/php-7.3.1.tar.xz

NAME=php
VERSION=7.3.1
URL=http://www.php.net/distributions/php-7.3.1.tar.xz

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--datadir=/usr/share/php \
--mandir=/usr/share/man \
--enable-fpm \
--without-pear \
--with-fpm-user=apache \
--with-fpm-group=apache \
--with-fpm-systemd \
--with-config-file-path=/etc \
--with-zlib \
--enable-bcmath \
--with-bz2 \
--enable-calendar \
--enable-dba=shared \
--with-gdbm \
--with-gmp \
--enable-ftp \
--with-gettext \
--enable-mbstring \
--with-readline &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 php.ini-production /etc/php.ini &&

install -v -m755 -d /usr/share/doc/php-7.3.1 &&
install -v -m644 CODING_STANDARDS EXTENSIONS INSTALL NEWS README* UPGRADING* php.gif \
/usr/share/doc/php-7.3.1 &&
ln -v -sfn /usr/lib/php/doc/Archive_Tar/docs/Archive_Tar.txt \
/usr/share/doc/php-7.3.1 &&
ln -v -sfn /usr/lib/php/doc/Structures_Graph/docs \
/usr/share/doc/php-7.3.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ -f /etc/php-fpm.conf.default ]; then
mv -v /etc/php-fpm.conf{.default,} &&
mv -v /etc/php-fpm.d/www.conf{.default,}
fi
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 ../php_manual_en.html.gz \
/usr/share/doc/php-7.3.1 &&
gunzip -v /usr/share/doc/php-7.3.1/php_manual_en.html.gz
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf ../php_manual_en.tar.gz \
-C /usr/share/doc/php-7.3.1 --no-same-owner
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

wget http://pear.php.net/go-pear.phar
php ./go-pear.phar

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i 's@php/includes"@&\ninclude_path = ".:/usr/lib/php"@' \
/etc/php.ini
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i -e '/proxy_module/s/^#//' \
-e '/proxy_fcgi_module/s/^#//' \
/etc/httpd/httpd.conf
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
echo \
'ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/srv/www/$1' >> \
/etc/httpd/httpd.conf
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-php-fpm
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
