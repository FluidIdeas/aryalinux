#!/bin/bash

set -e
set +h

. /sources/build-properties

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="028-home-permissions-fix"

cd $SOURCE_DIR

cat > /etc/profile.d/home-permissions-fix.sh <<EOF
pushd /home
for dir in *; do
chown -R $dir:$dir dir
done
EOF

echo "$STEPNAME" | tee -a $LOGFILE
