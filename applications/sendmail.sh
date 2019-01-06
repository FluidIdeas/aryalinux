#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:openldap
#REC:cyrus-sasl
#OPT:gs
#OPT:procmail

cd $SOURCE_DIR

wget -nc ftp://ftp.sendmail.org/pub/sendmail/sendmail.8.15.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/sendmail.8.15.2-openssl-1.patch

NAME=sendmail
VERSION=""
URL=ftp://ftp.sendmail.org/pub/sendmail/sendmail.8.15.2.tar.gz

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
groupadd -g 26 smmsp &&
useradd -c "Sendmail Daemon" -g smmsp -d /dev/null \
-s /bin/false -u 26 smmsp &&
chmod -v 1777 /var/mail &&
install -v -m700 -d /var/spool/mqueue
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat >> devtools/Site/site.config.m4 << "EOF"
<code class="literal">APPENDDEF(`confENVDEF',`-DSTARTTLS -DSASL -DLDAPMAP')
APPENDDEF(`confLIBS', `-lssl -lcrypto -lsasl2 -lldap -llber -ldb')
APPENDDEF(`confINCDIRS', `-I/usr/include/sasl')</code>
EOF
patch -Np1 -i $DIR/sendmail.8.15.2-openssl-1.patch &&

cat >> devtools/Site/site.config.m4 << "EOF"
<code class="literal">define(`confMANGRP',`root')
define(`confMANOWN',`root')
define(`confSBINGRP',`root')
define(`confUBINGRP',`root')
define(`confUBINOWN',`root')</code>
EOF

sed -i 's|/usr/man/man|/usr/share/man/man|' \
devtools/OS/Linux &&

cd sendmail &&
sh Build &&
cd ../cf/cf &&
cp generic-linux.mc sendmail.mc &&
sh Build sendmail.cf

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -d -m755 /etc/mail &&
sh Build install-cf &&

cd ../.. &&
sh Build install &&

install -v -m644 cf/cf/{submit,sendmail}.mc /etc/mail &&
cp -v -R cf/* /etc/mail &&

install -v -m755 -d /usr/share/doc/sendmail-8.15.2/{cf,sendmail} &&

install -v -m644 CACerts FAQ KNOWNBUGS LICENSE PGPKEYS README RELEASE_NOTES \
/usr/share/doc/sendmail-8.15.2 &&

install -v -m644 sendmail/{README,SECURITY,TRACEFLAGS,TUNING} \
/usr/share/doc/sendmail-8.15.2/sendmail &&

install -v -m644 cf/README /usr/share/doc/sendmail-8.15.2/cf &&

for manpage in sendmail editmap mailstats makemap praliases smrsh
do
install -v -m644 $manpage/$manpage.8 /usr/share/man/man8
done &&

install -v -m644 sendmail/aliases.5 /usr/share/man/man5 &&
install -v -m644 sendmail/mailq.1 /usr/share/man/man1 &&
install -v -m644 sendmail/newaliases.1 /usr/share/man/man1 &&
install -v -m644 vacation/vacation.1 /usr/share/man/man1
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cd doc/op &&
sed -i 's/groff/GROFF_NO_SGR=1 groff/' Makefile &&
make op.txt op.pdf

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
install -v -d -m755 /usr/share/doc/sendmail-8.15.2 &&
install -v -m644 op.ps op.txt op.pdf /usr/share/doc/sendmail-8.15.2 &&
cd ../..
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
echo $(hostname) > /etc/mail/local-host-names
cat > /etc/mail/aliases << "EOF"
<code class="literal">postmaster: root
MAILER-DAEMON: root</code>

EOF
newaliases
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
cd /etc/mail &&
m4 m4/cf.m4 sendmail.mc > sendmail.cf
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install-sendmail
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
