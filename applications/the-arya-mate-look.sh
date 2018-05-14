#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

gsettings set org.mate.background picture-filename '/usr/share/backgrounds/wall.png'
gsettings set org.mate.interface icon-theme 'Vivacious-Colors'
gsettings set org.mate.Marco.general theme 'Ambiance-Flat-Aqua'
gsettings set org.mate.interface gtk-theme 'Ambiance-Flat-Aqua'
gsettings set org.mate.interface font-name 'Open Sans 10'
gsettings set org.mate.interface document-font-name 'Open Sans 10'
gsettings set org.mate.interface monospace-font-name 'Monospace 12'
gsettings set org.mate.caja.desktop font 'Open Sans 10'
gsettings set org.mate.Marco.general titlebar-font 'Open Sans 10'
gsettings set org.mate.peripherals-mouse cursor-theme 'Adwaita'
gsettings set org.mate.font-rendering antialiasing 'rgba'
gsettings set org.mate.font-rendering hinting 'full'
gsettings set org.mate.font-rendering rgba-order 'rgb'

gsettings set org.mate.panel.menubar icon-name 'start-here'
gsettings set org.mate.panel.menubar show-icon true

read -p "Show desktop icons? (y/n) : " SHOW_DESKTOP_ICONS
if [ "x$SHOW_DESKTOP_ICONS" == "xy" ] || [ "x$SHOW_DESKTOP_ICONS" == "xY" ]
then
	gsettings set org.mate.background show-desktop-icons true
	gsettings set org.mate.caja.desktop computer-icon-visible true
	gsettings set org.mate.caja.desktop home-icon-visible true
	gsettings set org.mate.caja.desktop trash-icon-visible true
	gsettings set org.mate.caja.desktop network-icon-visible false
else
	gsettings set org.mate.background show-desktop-icons false
fi

sudo dracut -f `ls /boot/initrd.img*` `ls /lib/modules`

if [ -f /etc/lightdm/lightdm-gtk-greeter.conf ]
then
	sudo sed -i "s@#background=@background=/usr/share/backgrounds/aryalinux/2016_05_Life-of-Pix-free-stock-rain-plant-details-LEEROY.jpg@g" /etc/lightdm/lightdm-gtk-greeter.conf
	sudo sed -i "s@#theme-name=@theme-name=Adwaita@g" /etc/lightdm/lightdm-gtk-greeter.conf
	sudo sed -i "s@#font-name=@font-name=Open Sans@g" /etc/lightdm/lightdm-gtk-greeter.conf
	sudo sed -i "s@#icon-theme-name=@icon-theme-name=menta@g" /etc/lightdm/lightdm-gtk-greeter.conf
fi

cd $SOURCE_DIR
