#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf
#REQ:libtirpc

cd $SOURCE_DIR
NAME=dovecot
VERSION=2.4.2
URL=https://www.dovecot.org/releases/2.4/dovecot-2.4.2.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.dovecot.org/releases/2.4/dovecot-2.4.2.tar.gz


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

./configure --prefix=/usr                          \
            --sysconfdir=/etc                      \
            --localstatedir=/var                   \
            --docdir=/usr/share/doc/dovecot-2.4.2  \
            --disable-static
make
groupadd -g 42 dovecot
useradd -c "Dovecot unprivileged user" -d /dev/null -u 42 \
        -g dovecot -s /bin/false dovecot
groupadd -g 43 dovenull
useradd -c "Dovecot login user" -d /dev/null -u 43 \
        -g dovenull -s /bin/false dovenull
mv -v /etc/dovecot/dovecot.conf{,.orig}
chmod -v 1777 /var/mail
cat > /etc/dovecot/dovecot.conf << "EOF"

# The dovecot configuration requires a minimum version to be set. The server
# will refuse to start if the version set here is older than the version of
# Dovecot installed. This option allows the Dovecot server to set reasonable
# default values based on what version is set here.
dovecot_config_version = 2.4.2

# This option sets the minimum version that is able to read data files from
# the Dovecot server. This is primarily for a cluster which may have several
# different versions of Dovecot installed, but is required for the server to
# run.
dovecot_storage_version = 2.4.2

protocols = imap
ssl = no
# The next line is only needed if you have no IPv6 network interfaces
listen = *
mail_inbox_path = /var/mail/%{user}
mail_driver = mbox
mail_path = ~/Mail
userdb users {
  driver = passwd
}
passdb passwords {
  driver = pam
}
EOF
cat > /etc/pam.d/dovecot << "EOF"
# Begin /etc/pam.d/dovecot

auth     include system-auth
account  include system-account
password include system-password

# End /etc/pam.d/dovecot
EOF
systemctl enable dovecot


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd