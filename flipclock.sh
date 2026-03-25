#!/bin/bash

if [ `id -u` != 0 ] ; then
    echo "Not running as root"
    exit
fi

<<comment
if ! command -v flatpak &> /dev/null
then
	add-apt-repository ppa:flatpak/stable -y
	apt update
	apt install flatpak -y
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	reboot
fi
flatpak install flathub one.alynx.FlipClock -y
comment

apt install xscreensaver xscreensaver-gl-extra xscreensaver-data-extra xterm -y
apt remove gnome-screensaver -y
apt install build-essential libsdl1.2-dev libsdl-ttf2.0-dev libsdl-gfx1.2-dev libx11-dev -y
if ! command -v gluqlo &> /dev/null
then
	git clone https://github.com/alexanderk23/gluqlo.git /tmp/gluqlo
	cd /tmp/gluqlo
	make && sudo make install
	ln -s /usr/lib/xscreensaver/gluqlo /usr/local/bin/gluqlo
fi

temp="/home/$(ls /home | awk '{print $1}')"

filenameXscreensaver="$temp/.xscreensaver"
if [ -f $filenameXscreensaver ]; then
	if ! grep -q gluqlo "$filenameXscreensaver"; then
	  sed -i '\:\goop:a\gluqlo -root \\n\\' $temp/.xscreensaver
	fi
else
    	#echo $(ps aux | grep xterm)
	xterm -e xscreensaver-command -demo &
	
	#sleep 5
	#xterm -e echo $(ps aux | grep xscreensaver)
	#echo $(ps aux | grep xterm)
	
	until pids=$(pidof xscreensaver-demo)
	do   
	    sleep 1
	done
	
	
	#echo $(ps aux | grep xscreensaver)
	#ps aux | grep xterm  |  awk '{print $2}' | xargs sudo kill -9;

	ps aux | grep xscreensaver  |  awk '{print $2}' | xargs sudo kill -9 & > /dev/null 2>&1;
	mv /root/.xscreensaver $temp/
	chmod +777 $temp/.xscreensaver
	
	if ! grep -q gluqlo "$filenameXscreensaver"; then
	  sed -i '\:\goop:a\gluqlo -root \\n\\' $temp/.xscreensaver
	fi		
fi #> /dev/null 2>&1
