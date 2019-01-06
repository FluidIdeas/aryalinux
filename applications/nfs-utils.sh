#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libtirpc
#REQ:rpcsvc-proto
#REQ:rpcbind
#OPT:lvm2
#OPT:libnfsidmap
#OPT:libnsl
#OPT:sqlite
#OPT:mitkrb
#OPT:libcap

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/nfs/nfs-utils-2.3.3.tar.xz

NAME=nfs-utils
VERSION=2.3.3
URL=https://downloads.sourceforge.net/nfs/nfs-utils-2.3.3.tar.xz

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

groupadd -g 99 nogroup &&
useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
    -s /bin/false -u 99 nobody
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --sbindir=/sbin        \
            --disable-nfsv4        \
            --disable-gss &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install                      &&
mv -v /sbin/start-statd /usr/sbin &&
chmod u+w,go+r /sbin/mount.nfs    &&
chown nobody.nogroup /var/lib/nfs
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
/home <em class="replaceable"><code>192.168.0.0/24</code></em>(rw,subtree_check,anonuid=99,anongid=99)
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-nfsv4-server
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-nfs-server
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
<em class="replaceable"><code><server-name></code></em>:/home  /home nfs   rw,_netdev 0 0
<em class="replaceable"><code><server-name></code></em>:/usr   /usr  nfs   ro,_netdev 0 0
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-nfs-client
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
