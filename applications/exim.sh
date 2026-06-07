#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libnsl

cd $SOURCE_DIR
NAME=exim
VERSION=4.99.1
URL=https://ftp.exim.org/pub/exim/exim4/exim-4.99.1.tar.xz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.exim.org/pub/exim/exim4/exim-4.99.1.tar.xz


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

echo $USER > /tmp/currentuser

sed -e 's,^BIN_DIR.*$,BIN_DIRECTORY=/usr/sbin,'    \
    -e 's,^CONF.*$,CONFIGURE_FILE=/etc/exim.conf,' \
    -e 's,^EXIM_USER.*$,EXIM_USER=exim,'           \
    -e '/# USE_OPENSSL/s,^#,,' src/EDITME > Local/Makefile
printf "USE_GDBM = yes\nDBMLIB = -lgdbm\n" >> Local/Makefile
sed -i '/# SUPPORT_PAM=yes/s,^#,,' Local/Makefile
echo "EXTRALIBS=-lpam" >> Local/Makefile
make
groupadd -g 31 exim
useradd -d /dev/null -c "Exim Daemon" -g exim -s /bin/false -u 31 exim
cp      -Rv doc/*   /usr/share/doc/exim-4.99.1
ln -sfv exim /usr/sbin/sendmail
chmod -v a+wt /var/mail
cat >> /etc/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF
/usr/sbin/exim -bd -q15m
cat > /etc/pam.d/exim << "EOF"
# Begin /etc/pam.d/exim

auth    include system-auth
account include system-account
session include system-session

# End /etc/pam.d/exim
EOF


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
install -v -m644 doc/exim.8 /usr/share/man/man8
install -vdm 755    /usr/share/doc/exim-4.99.1
install -v -d -m750 -o exim -g exim /var/spool/exim
make install-exim
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd