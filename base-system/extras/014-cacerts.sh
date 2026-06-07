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
STEPNAME="014-cacerts.sh"
TARBALL="make-ca-1.16.1.tar.gz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)
tar xf $TARBALL
cd $DIRECTORY
sed '/mktemp/s/-t //' -i make-ca
make install
install -vdm755 /etc/ssl/local
# NSS moved certdata.txt; the default URL in 1.16.1 is stale (make-ca #21682).
# make-ca.conf replaces all defaults when present, so include the full template.
cat > /etc/make-ca.conf << "EOF"
CERTDATA="certdata.txt"
PKIDIR="/etc/pki"
SSLDIR="/etc/ssl"
CERTUTIL="/usr/bin/certutil"
KEYTOOL="${JAVA_HOME}/bin/keytool"
MD5SUM="/usr/bin/md5sum"
OPENSSL="/usr/bin/openssl"
TRUST="/usr/bin/trust"
ANCHORDIR="${PKIDIR}/anchors"
ANCHORLIST="${PKIDIR}/anchors.md5sums"
BUNDLEDIR="${PKIDIR}/tls/certs"
CABUNDLE="${BUNDLEDIR}/ca-bundle.crt"
SMBUNDLE="${BUNDLEDIR}/email-ca-bundle.crt"
CSBUNDLE="${BUNDLEDIR}/objsign-ca-bundle.crt"
CERTDIR="${SSLDIR}/certs"
KEYSTORE="${PKIDIR}/tls/java"
NSSDB="${PKIDIR}/nssdb"
LOCALDIR="${SSLDIR}/local"
DESTDIR=""
URL="https://hg-edge.mozilla.org/mozilla-central/raw-file/tip/security/nss/lib/ckfw/builtins/certdata.txt"
EOF

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "$STEPNAME" | tee -a $LOGFILE

fi
