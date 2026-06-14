#!/bin/bash
# SPDX-License-Identifier: MIT
# Install or refresh ALPS from /sources/alps (copied from base-system during stage 1).
# Run inside the chroot before alps install, e.g. from essentials.sh.

set -euo pipefail

ALPS_TREE="/sources/alps"

if [ ! -f "$ALPS_TREE/usr/bin/alps" ]; then
    echo "upgrade-alps: $ALPS_TREE/usr/bin/alps not found" >&2
    exit 1
fi

install -d /etc/alps /var/lib/alps /usr/bin
cp -a "$ALPS_TREE/usr/bin/alps" /usr/bin/alps
cp -a "$ALPS_TREE/etc/alps/." /etc/alps/
cp -a "$ALPS_TREE/var/lib/alps/." /var/lib/alps/
chmod a+x /usr/bin/alps
chmod -R a+rX /var/lib/alps/alps

mkdir -pv /var/cache/alps/{sources,packages,staging,ports}
mkdir -pv /var/lib/alps/installed
chmod a+rwX /var/cache/alps/{sources,packages,staging,ports} 2>/dev/null || true
chmod a+rwX /var/lib/alps/installed 2>/dev/null || true

echo "upgrade-alps: installed ALPS from $ALPS_TREE"
