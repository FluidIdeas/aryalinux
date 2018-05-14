#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The FreeTTS package contains abr3ak speech synthesis system written entirely in the Java programming language. It is based uponbr3ak <a class=\"ulink\" href=\"http://www.cmuflite.org/\">Flite</a>: a smallbr3ak run-time speech synthesis engine developed at Carnegie Mellonbr3ak University. Flite is derived frombr3ak the <a class=\"ulink\" href=\"http://www.cstr.ed.ac.uk/projects/festival/\">Festival</a> Speechbr3ak Synthesis System from the University of Edinburgh and the <a class=\"ulink\" href=\"http://festvox.org/\">FestVox</a> project frombr3ak Carnegie Mellon University. The FreeTTS package is used to convert text tobr3ak audible speech through the system audio hardware.br3ak"
SECTION="multimedia"
VERSION=1.2.2
NAME="freetts"

#REQ:apache-ant
#REQ:sharutils


cd $SOURCE_DIR

URL=https://downloads.sourceforge.net/freetts/freetts-1.2.2-src.zip

if [ ! -z $URL ]
then
wget -nc https://downloads.sourceforge.net/freetts/freetts-1.2.2-src.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-src.zip
wget -nc https://downloads.sourceforge.net/freetts/freetts-1.2.2-tst.zip || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetts/freetts-1.2.2-tst.zip

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

unzip -q freetts-1.2.2-src.zip -x META-INF/* &&
unzip -q freetts-1.2.2-tst.zip -x META-INF/*


sed -i 's/value="src/value="./' build.xml &&
cd lib      &&
sh jsapi.sh &&
cd ..       &&
ant


ant junit &&
cd tests &&
sh regression.sh &&
cd ..



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /opt/freetts-1.2.2/{lib,docs/{audio,images}} &&
install -v -m644 lib/*.jar /opt/freetts-1.2.2/lib                &&
install -v -m644 *.txt RELEASE_NOTES docs/*.{pdf,html,txt,sx{w,d}} \
                               /opt/freetts-1.2.2/docs           &&
install -v -m644 docs/audio/*  /opt/freetts-1.2.2/docs/audio     &&
install -v -m644 docs/images/* /opt/freetts-1.2.2/docs/images    &&
cp -v -R javadoc               /opt/freetts-1.2.2                &&
ln -v -s freetts-1.2.2 /opt/freetts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v -R bin    /opt/freetts-1.2.2        &&
install -v -m644 speech.properties $JAVA_HOME/jre/lib &&
cp -v -R tools  /opt/freetts-1.2.2        &&
cp -v -R mbrola /opt/freetts-1.2.2        &&
cp -v -R demo   /opt/freetts-1.2.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


java -jar /opt/freetts/lib/freetts.jar \
     -text "This is a test of the FreeTTS speech synthesis system"


java -jar /opt/freetts/lib/freetts.jar -streaming \
     -text "This is a test of the FreeTTS speech synthesis system"




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
