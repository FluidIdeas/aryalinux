#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The sendmail package contains abr3ak Mail Transport Agent (MTA).br3ak"
SECTION="server"
VERSION=8.15.2
NAME="sendmail"

#REQ:openldap
#REC:openssl10
#REC:cyrus-sasl
#OPT:gs
#OPT:procmail


cd $SOURCE_DIR

URL=ftp://ftp.sendmail.org/pub/sendmail/sendmail.8.15.2.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.sendmail.org/pub/sendmail/sendmail.8.15.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sendmail/sendmail.8.15.2.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/sendmail/sendmail.8.15.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sendmail/sendmail.8.15.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sendmail/sendmail.8.15.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sendmail/sendmail.8.15.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sendmail/sendmail.8.15.2.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 26 smmsp                               &&
useradd -c "Sendmail Daemon" -g smmsp -d /dev/null \
        -s /bin/false -u 26 smmsp                  &&
chmod -v 1777 /var/mail                            &&
install -v -m700 -d /var/spool/mqueue

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cat >> devtools/Site/site.config.m4 << "EOF"
APPENDDEF(`confENVDEF',`-DSTARTTLS -DSASL -DLDAPMAP')
APPENDDEF(`confLIBS', `-L/usr/lib/openssl-1.0 -lssl -lcrypto -lsasl2 -lldap -llber -ldb')
APPENDDEF(`confINCDIRS', `-I/usr/include/sasl -I/usr/include/openssl-1.0')
EOF


cat >> devtools/Site/site.config.m4 << "EOF"
define(`confMANGRP',`root')
define(`confMANOWN',`root')
define(`confSBINGRP',`root')
define(`confUBINGRP',`root')
define(`confUBINOWN',`root')
EOF
sed -i 's|/usr/man/man|/usr/share/man/man|' \
    devtools/OS/Linux           &&
cd sendmail                     &&
sh Build                        &&
cd ../cf/cf                     &&
cp generic-linux.mc sendmail.mc &&
sh Build sendmail.cf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /etc/mail &&
sh Build install-cf &&
cd ../..            &&
sh Build install    &&
install -v -m644 cf/cf/{submit,sendmail}.mc /etc/mail &&
cp -v -R cf/* /etc/mail                               &&
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
install -v -m644 sendmail/aliases.5    /usr/share/man/man5 &&
install -v -m644 sendmail/mailq.1      /usr/share/man/man1 &&
install -v -m644 sendmail/newaliases.1 /usr/share/man/man1 &&
install -v -m644 vacation/vacation.1   /usr/share/man/man1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


cd doc/op                                       &&
sed -i 's/groff/GROFF_NO_SGR=1 groff/' Makefile &&
make op.txt op.pdf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -d -m755 /usr/share/doc/sendmail-8.15.2 &&
install -v -m644 op.ps op.txt op.pdf /usr/share/doc/sendmail-8.15.2 &&
cd ../..

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo $(hostname) > /etc/mail/local-host-names
cat > /etc/mail/aliases << "EOF"
postmaster: root
MAILER-DAEMON: root
EOF
newaliases

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /etc/mail &&
m4 m4/cf.m4 sendmail.mc > sendmail.cf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
make install-sendmail

cd ..
rm -rf blfs-systemd-units-20180105
popd
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
