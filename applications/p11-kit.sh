#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REC:libtasn1
#OPT:make-ca
#OPT:nss
#OPT:gtk-doc
#OPT:libxslt

cd $SOURCE_DIR

wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz

NAME=p11-kit
VERSION=0.23.14
URL=https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz

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

sed '20,$ d' -i trust/trust-extract-compat.in &&
cat >> trust/trust-extract-compat.in << "EOF"
<code class="literal"># Copy existing anchor modifications to /etc/ssl/local /usr/libexec/make-ca/copy-trust-modifications # Generate a new trust store /usr/sbin/make-ca -f -g</code>
EOF
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-trust-paths=/etc/pki/anchors &&
make

sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
ln -s /usr/libexec/p11-kit/trust-extract-compat \
      /usr/bin/update-ca-certificates
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


sudo rm /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
if [ -e /usr/lib/libnssckbi.so ]; then
  readlink /usr/lib/libnssckbi.so ||
  rm -v /usr/lib/libnssckbi.so    &&
  ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
fi
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
