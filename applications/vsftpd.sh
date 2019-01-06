#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libnsl
#OPT:libcap
#OPT:linux-pam

cd $SOURCE_DIR

wget -nc https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz

NAME=vsftpd
VERSION=3.0.3
URL=https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz

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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -d -m 0755 /usr/share/vsftpd/empty &&
install -v -d -m 0755 /home/ftp &&
groupadd -g 47 vsftpd &&
groupadd -g 45 ftp &&

useradd -c "vsftpd User" -d /dev/null -g vsftpd -s /bin/false -u 47 vsftpd &&
useradd -c anonymous_user -d /home/ftp -g ftp -s /bin/false -u 45 ftp
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -m 755 vsftpd /usr/sbin/vsftpd &&
install -v -m 644 vsftpd.8 /usr/share/man/man8 &&
install -v -m 644 vsftpd.conf.5 /usr/share/man/man5 &&
install -v -m 644 vsftpd.conf /etc
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/vsftpd.conf << "EOF"
<code class="literal">background=YES
listen=YES
nopriv_user=vsftpd
secure_chroot_dir=/usr/share/vsftpd/empty</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat >> /etc/vsftpd.conf << "EOF"
<code class="literal">local_enable=YES</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cat > /etc/pam.d/vsftpd << "EOF" &&
<code class="literal"># Begin /etc/pam.d/vsftpd
auth required /lib/security/pam_listfile.so item=user sense=deny \
file=/etc/ftpusers \
onerr=succeed
auth required pam_shells.so
auth include system-auth
account include system-account
session include system-session</code>
EOF

cat >> /etc/vsftpd.conf << "EOF"
<code class="literal">session_support=YES
pam_service_name=vsftpd</code>
EOF
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-vsftpd
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
