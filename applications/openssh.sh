#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#OPT:linux-pam
#OPT:installing
#OPT:mitkrb
#OPT:sectok
#OPT:openjdk
#OPT:net-tools
#OPT:sysstat

cd $SOURCE_DIR

wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.9p1.tar.gz

URL=http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.9p1.tar.gz

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


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-7.9p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-7.9p1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh

ssh-keygen &&
ssh-copy-id -i ~/.ssh/id_rsa.pub <em class="replaceable"><code>REMOTE_USERNAME</code></em>@<em class="replaceable"><code>REMOTE_HOSTNAME</code></em>

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd &&
chmod 644 /etc/pam.d/sshd &&
echo "UsePAM yes" >> /etc/ssh/sshd_config
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-sshd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
