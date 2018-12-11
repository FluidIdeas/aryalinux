#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="chromium-bin"
VERSION="SVN"
DESCRIPTION="Chromium is an open source browser from which google chrome is forked"

#REQ:git
#REQ:cups
#REQ:GConf

cd $SOURCE_DIR
git clone https://github.com/scheib/chromium-latest-linux.git
cd chromium-latest-linux
./update.sh

cd $SOURCE_DIR
sudo cp -r chromium-latest-linux /opt/
sudo chmod -R a+rx /opt/chromium-latest-linux

sudo tee /etc/profile.d/chromium.sh <<"EOF"
export PATH=$PATH:/opt/chromium-latest-linux/latest
EOF

sudo tee /usr/share/applications/chromium.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Chromium
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Web Browser
GenericName[ar]=Ù…ØªØµÙØ­ Ø§Ù„Ø´Ø¨ÙƒØ©
GenericName[bg]=Ð£ÐµÐ± Ð±Ñ€Ð°ÑƒÐ·ÑŠÑ€
GenericName[ca]=Navegador web
GenericName[cs]=WWW prohlÃ­Å¾eÄ
GenericName[da]=Browser
GenericName[de]=Web-Browser
GenericName[el]=Î ÎµÏÎ¹Î·Î³Î·Ï„Î®Ï‚ Î¹ÏƒÏ„Î¿Ï
GenericName[en_GB]=Web Browser
GenericName[es]=Navegador web
GenericName[et]=Veebibrauser
GenericName[fi]=WWW-selain
GenericName[fr]=Navigateur Web
GenericName[gu]=àªµà«‡àª¬ àª¬à«àª°àª¾àª‰àªàª°
GenericName[he]=×“×¤×“×¤×Ÿ ××™× ×˜×¨× ×˜
GenericName[hi]=à¤µà¥‡à¤¬ à¤¬à¥à¤°à¤¾à¤‰à¤œà¤¼à¤°
GenericName[hu]=WebbÃ¶ngÃ©szÅ‘
GenericName[it]=Browser Web
GenericName[ja]=ã‚¦ã‚§ãƒ–ãƒ–ãƒ©ã‚¦ã‚¶
GenericName[kn]=à²œà²¾à²² à²µà³€à²•à³à²·à²•
GenericName[ko]=ì›¹ ë¸Œë¼ìš°ì €
GenericName[lt]=Å½iniatinklio narÅ¡yklÄ—
GenericName[lv]=TÄ«mekÄ¼a pÄrlÅ«ks
GenericName[ml]=à´µàµ†à´¬àµ à´¬àµà´°àµŒà´¸à´°àµâ€
GenericName[mr]=à¤µà¥‡à¤¬ à¤¬à¥à¤°à¤¾à¤Šà¤œà¤°
GenericName[nb]=Nettleser
GenericName[nl]=Webbrowser
GenericName[pl]=PrzeglÄ…darka WWW
GenericName[pt]=Navegador Web
GenericName[pt_BR]=Navegador da Internet
GenericName[ro]=Navigator de Internet
GenericName[ru]=Ð’ÐµÐ±-Ð±Ñ€Ð°ÑƒÐ·ÐµÑ€
GenericName[sl]=Spletni brskalnik
GenericName[sv]=WebblÃ¤sare
GenericName[ta]=à®‡à®£à¯ˆà®¯ à®‰à®²à®¾à®µà®¿
GenericName[th]=à¹€à¸§à¹‡à¸šà¹€à¸šà¸£à¸²à¸§à¹Œà¹€à¸‹à¸­à¸£à¹Œ
GenericName[tr]=Web TarayÄ±cÄ±
GenericName[uk]=ÐÐ°Ð²Ñ–Ð³Ð°Ñ‚Ð¾Ñ€ Ð¢ÐµÐ½ÐµÑ‚
GenericName[zh_CN]=ç½‘é¡µæµè§ˆå™¨
GenericName[zh_HK]=ç¶²é ç€è¦½å™¨
GenericName[zh_TW]=ç¶²é ç€è¦½å™¨
# Not translated in KDE, from Epiphany 2.26.1-0ubuntu1.
GenericName[bn]=à¦“à§Ÿà§‡à¦¬ à¦¬à§à¦°à¦¾à¦‰à¦œà¦¾à¦°
GenericName[fil]=Web Browser
GenericName[hr]=Web preglednik
GenericName[id]=Browser Web
GenericName[or]=à¬“à­à¬¬à­‡à¬¬ à¬¬à­à¬°à¬¾à¬‰à¬œà¬°
GenericName[sk]=WWW prehliadaÄ
GenericName[sr]=Ð˜Ð½Ñ‚ÐµÑ€Ð½ÐµÑ‚ Ð¿Ñ€ÐµÐ³Ð»ÐµÐ´Ð½Ð¸Ðº
GenericName[te]=à°®à°¹à°¾à°¤à°² à°…à°¨à±à°µà±‡à°·à°¿
GenericName[vi]=Bá»™ duyá»‡t Web
# Gnome and KDE 3 uses Comment.
Comment=Access the Internet
Comment[ar]=Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø¥Ù„Ù‰ Ø§Ù„Ø¥Ù†ØªØ±Ù†Øª
Comment[bg]=Ð”Ð¾ÑÑ‚ÑŠÐ¿ Ð´Ð¾ Ð¸Ð½Ñ‚ÐµÑ€Ð½ÐµÑ‚
Comment[bn]=à¦‡à¦¨à§à¦Ÿà¦¾à¦°à¦¨à§‡à¦Ÿà¦Ÿà¦¿ à¦…à§à¦¯à¦¾à¦•à§à¦¸à§‡à¦¸ à¦•à¦°à§à¦¨
Comment[ca]=Accedeix a Internet
Comment[cs]=PÅ™Ã­stup k internetu
Comment[da]=FÃ¥ adgang til internettet
Comment[de]=Internetzugriff
Comment[el]=Î ÏÏŒÏƒÎ²Î±ÏƒÎ· ÏƒÏ„Î¿ Î”Î¹Î±Î´Î¯ÎºÏ„Ï…Î¿
Comment[en_GB]=Access the Internet
Comment[es]=Accede a Internet.
Comment[et]=PÃ¤Ã¤s Internetti
Comment[fi]=KÃ¤ytÃ¤ internetiÃ¤
Comment[fil]=I-access ang Internet
Comment[fr]=AccÃ©der Ã  Internet
Comment[gu]=àª‡àª‚àªŸàª°àª¨à«‡àªŸ àªàª•à«àª¸à«‡àª¸ àª•àª°à«‹
Comment[he]=×’×™×©×” ××œ ×”××™× ×˜×¨× ×˜
Comment[hi]=à¤‡à¤‚à¤Ÿà¤°à¤¨à¥‡à¤Ÿ à¤¤à¤• à¤ªà¤¹à¥à¤‚à¤š à¤¸à¥à¤¥à¤¾à¤ªà¤¿à¤¤ à¤•à¤°à¥‡à¤‚
Comment[hr]=Pristup Internetu
Comment[hu]=InternetelÃ©rÃ©s
Comment[id]=Akses Internet
Comment[it]=Accesso a Internet
Comment[ja]=ã‚¤ãƒ³ã‚¿ãƒ¼ãƒãƒƒãƒˆã«ã‚¢ã‚¯ã‚»ã‚¹
Comment[kn]=à²‡à²‚à²Ÿà²°à³à²¨à³†à²Ÿà³ à²…à²¨à³à²¨à³ à²ªà³à²°à²µà³‡à²¶à²¿à²¸à²¿
Comment[ko]=ì¸í„°ë„· ì—°ê²°
Comment[lt]=Interneto prieiga
Comment[lv]=PiekÄ¼Å«t internetam
Comment[ml]=à´‡à´¨àµà´±à´°àµâ€â€Œà´¨àµ†à´±àµà´±àµ à´†à´•àµâ€Œà´¸à´¸àµ à´šàµ†à´¯àµà´¯àµà´•
Comment[mr]=à¤‡à¤‚à¤Ÿà¤°à¤¨à¥‡à¤Ÿà¤®à¤§à¥à¤¯à¥‡ à¤ªà¥à¤°à¤µà¥‡à¤¶ à¤•à¤°à¤¾
Comment[nb]=GÃ¥ til Internett
Comment[nl]=Verbinding maken met internet
Comment[or]=à¬‡à¬£à­à¬Ÿà¬°à­à¬¨à­‡à¬Ÿà­ à¬ªà­à¬°à¬¬à­‡à¬¶ à¬•à¬°à¬¨à­à¬¤à­
Comment[pl]=Skorzystaj z internetu
Comment[pt]=Aceder Ã  Internet
Comment[pt_BR]=Acessar a internet
Comment[ro]=AccesaÅ£i Internetul
Comment[ru]=Ð”Ð¾ÑÑ‚ÑƒÐ¿ Ð² Ð˜Ð½Ñ‚ÐµÑ€Ð½ÐµÑ‚
Comment[sk]=PrÃ­stup do siete Internet
Comment[sl]=Dostop do interneta
Comment[sr]=ÐŸÑ€Ð¸ÑÑ‚ÑƒÐ¿Ð¸Ñ‚Ðµ Ð˜Ð½Ñ‚ÐµÑ€Ð½ÐµÑ‚Ñƒ
Comment[sv]=GÃ¥ ut pÃ¥ Internet
Comment[ta]=à®‡à®£à¯ˆà®¯à®¤à¯à®¤à¯ˆ à®…à®£à¯à®•à¯à®¤à®²à¯
Comment[te]=à°‡à°‚à°Ÿà°°à±à°¨à±†à°Ÿà±â€Œà°¨à± à°†à°•à±à°¸à±†à°¸à± à°šà±†à°¯à±à°¯à°‚à°¡à°¿
Comment[th]=à¹€à¸‚à¹‰à¸²à¸–à¸¶à¸‡à¸­à¸´à¸™à¹€à¸—à¸­à¸£à¹Œà¹€à¸™à¹‡à¸•
Comment[tr]=Ä°nternet'e eriÅŸin
Comment[uk]=Ð”Ð¾ÑÑ‚ÑƒÐ¿ Ð´Ð¾ Ð†Ð½Ñ‚ÐµÑ€Ð½ÐµÑ‚Ñƒ
Comment[vi]=Truy cáº­p Internet
Comment[zh_CN]=è®¿é—®äº’è”ç½‘
Comment[zh_HK]=é€£ç·šåˆ°ç¶²éš›ç¶²è·¯
Comment[zh_TW]=é€£ç·šåˆ°ç¶²éš›ç¶²è·¯
Exec=/opt/chromium-latest-linux/latest/chrome %U
Terminal=false
Icon=chromium
Type=Application
Categories=GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/mailto;x-scheme-handler/webcal;

StartupWMClass=chromium-browser

EOF

cd $SOURCE_DIR

sudo rm -rf chromium-latest-linux

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
