#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "setup must run as root"
	exit
fi

#download programs
sudo apt install -y xubuntu-restricted-extras openjdk-9-jre-headless wmctrl rofi git scrot gedit g++ ffmpeg vim mpv gimp audacity youtube-dl curl xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev &&

#download bspwm
git clone https://github.com/baskerville/bspwm.git  &&
git clone https://github.com/baskerville/sxhkd.git &&

#download victory theme
git clone https://github.com/newhoa/victory-gtk-theme.git ~/.themes/ &&
git clone https://github.com/newhoa/victory-icon-theme.git ~/.icons/victory-icon-theme/ &&

#bspwm setup
make -C bspwm/ && sudo make install -C bspwm/ 
make -C sxhkd/ && sudo make install -C sxhkd/ 
rm -rf bspwm/ sxhkd/
mkdir ~/.config/sxhkd/ && mv sxhkdrc search.sh site-suggestions.txt ~/.config/sxhkd/ 
chmod +x ~/.config/sxhkd/search.sh 
mkdir ~/.config/bspwm/ && mv bspwmrc ~/.config/bspwm 
chmod +x ~/.config/bspwm/bspwmrc 

#theme setup
mv ~/.themes/PreviousVersions/Victory-16.10 ~/.themes 
xfconf-query -c xsettings -p /Net/ThemeName -s "Victory-16.10" 
xfconf-query -c xsettings -p /Net/IconThemeName -s "victory-icon-theme" 
xfconf-query --create -c xfce4-notifyd -p /theme -t string -s "Victory-16.10" 

#xfce settings
mv xfce4-panel.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/ 
mv xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/ 
xfconf-query --create -c xfce4-desktop -p /desktop-icons/style -t int -s '0' 
xfconf-query --create -c xfwm4 -p /general/workspace_names [-4] \
	-t string -s 1 \
	-t string -s 2 \
	-t string -s 3 \
	-t string -s 4

#xfce4-terminal settings 
mkdir ~/.config/xfce4/terminal
mv terminalrc ~/.config/xfce4/terminal

#autostart programs
mkdir ~/.config/autostart 
mv bspwm_login.desktop ~/.config/autostart 
mv mouse.desktop ~/.config/autostart 

#disable error messages
echo "enabled=0" > /etc/default/apport 

#set defualt window manager to bspwm
xfconf-query --create -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa bspwm 
xfconf-query --create -c xfce4-session -p /general/SaveOnExit -t bool -s false 
rm -rf ~/.cache/sessions/* 

reboot
