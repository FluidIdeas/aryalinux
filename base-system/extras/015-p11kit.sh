#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="015-p11kit.sh"
TARBALL="p11-kit-0.26.2.tar.xz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY

sed '20,$ d' -i trust/trust-extract-compat
cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

mkdir p11-build
cd p11-build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D trust_paths=/etc/pki/anchors
ninja
ninja install
ln -sfv /usr/libexec/p11-kit/trust-extract-compat /usr/bin/update-ca-certificates
ln -sfv /usr/lib/p11-kit/p11-kit-trust.so /usr/lib/libnssckbi.so

CERTDATA="$SOURCE_DIR/certdata.txt"
if [ ! -f "$CERTDATA" ]; then
	echo "Missing $CERTDATA — run additional-downloads.py on the build host first." >&2
	exit 1
fi
if ! grep -q '^# certdata.txt' "$CERTDATA"; then
	echo "$CERTDATA does not look like a Mozilla certdata.txt file." >&2
	exit 1
fi
if ! grep -q '^# Revision:' "$CERTDATA"; then
	sed -i "1i# Revision:$(date -u +%Y%m%d)" "$CERTDATA"
fi
/usr/sbin/make-ca -C "$CERTDATA"

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
