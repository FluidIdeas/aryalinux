#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="kyotocabinet"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/k/kyotocabinet/kyotocabinet_1.2.76.orig.tar.gz

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

cat > kyotocabinet-gcc6.patch <<EOF
--- kyotocabinet-1.2.76/kcdbext.h	2016-05-25 11:32:53.591866016 +0200
+++ kyotocabinet-1.2.76/kcdbext.h	2012-05-24 18:27:59.000000000 +0200
@@ -1278,7 +1278,7 @@
     if (omode_ == 0) {
       set_error(_KCCODELINE_, BasicDB::Error::INVALID, "not opened");
       *sp = 0;
-      return false;
+      return '\0';
     }
     if (!cache_) return db_.get(kbuf, ksiz, sp);
     size_t dvsiz = 0;
EOF

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../kyotocabinet-gcc6.patch
./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
sudo rm -r $DIRECTORY

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
