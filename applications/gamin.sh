#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gamin"
VERSION="0.1.9"

cd $SOURCE_DIR

URL="https://people.gnome.org/~veillard/gamin/sources/gamin-0.1.9.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

cat > patch1.patch << "EOF1"
diff -up gamin-0.1.9/server/gam_channel.c.xxx gamin-0.1.9/server/gam_channel.c
--- gamin-0.1.9/server/gam_channel.c.xxx	2007-07-04 15:36:49.000000000 +0200
+++ gamin-0.1.9/server/gam_channel.c	2008-02-14 10:00:38.654849392 +0100
@@ -3,7 +3,6 @@
 #include <unistd.h>
 #include <errno.h>
 #include <glib.h>
-#include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/un.h>
 #include <sys/uio.h>
@@ -12,6 +11,14 @@
 #include "gam_channel.h"
 #include "gam_protocol.h"
 
+#ifdef HAVE_LINUX
+  /*  Workaround for undefined struct ucred  */
+  #define __USE_GNU
+#endif
+
+#include <sys/socket.h>
+
+
 /* #define CHANNEL_VERBOSE_DEBUGGING */
 /************************************************************************
  *									*
diff -up gamin-0.1.9/libgamin/gam_api.c.xxx gamin-0.1.9/libgamin/gam_api.c
--- gamin-0.1.9/libgamin/gam_api.c.xxx	2007-07-04 15:36:48.000000000 +0200
+++ gamin-0.1.9/libgamin/gam_api.c	2008-02-13 17:41:50.697896914 +0100
@@ -11,7 +11,6 @@
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/stat.h>
-#include <sys/socket.h>
 #include <sys/un.h>
 #include <sys/uio.h>
 #include "fam.h"
@@ -20,6 +19,14 @@
 #include "gam_fork.h"
 #include "gam_error.h"
 
+#ifdef HAVE_LINUX
+  /*  Workaround for undefined struct ucred  */
+  #define __USE_GNU
+#endif
+
+#include <sys/socket.h>
+  
+
 #define TEST_DEBUG
 
 #define MAX_RETRIES 25
EOF1

cat > patch-server_gam_eq_c.patch <<"EOF"
--- server/gam_eq.c.orig	2012-05-13 19:42:20.257794534 +0400
+++ server/gam_eq.c	2012-05-13 19:44:41.228799909 +0400
@@ -124,7 +124,7 @@ gam_eq_flush (gam_eq_t *eq, GamConnDataP
 {
 	gboolean done_work = FALSE;
 	if (!eq)
-		return;
+		return FALSE;
 
 #ifdef GAM_EQ_VERBOSE
 	GAM_DEBUG(DEBUG_INFO, "gam_eq: Flushing event queue for %s\n", gam_connection_get_pidname (conn));
EOF

sed -i "s@G_CONST_RETURN@const@g" server/gam_subscription.h
sed -i "s@G_CONST_RETURN@const@g" server/gam_subscription.c
sed -i "s@G_CONST_RETURN@const@g" server/gam_node.h
sed -i "s@G_CONST_RETURN@const@g" server/gam_node.c

patch -Np1 -i patch1.patch
patch -Np0 -i patch-server_gam_eq_c.patch

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
