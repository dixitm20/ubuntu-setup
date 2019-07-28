#####################################################################################################
# Script_Name : Std-Xrdp-install-0.4.sh
# Description : Perform an automated standard installation of xrdp
# on ubuntu 17.10 and later
# Date : May 2018
# written by : Griffon
# Web Site :http://www.c-nergy.be - http://www.c-nergy.be/blog
# Version : 0.4
# History : 0.4 - Add logic to fix GDM lock screen + minor change
#         : 0.3 - Adding logic to fix theme and extensions for any users login through xrdp
#           0.2 - Added Logic for Ubuntu 17.10 and 18.04 detection 
#               - Updated the polkit section
#               - New formatting and structure  
#           0.1 - Initial Script       
# Disclaimer : Script provided AS IS. Use it at your own risk....
####################################################################################################

echo
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m#   Standard XRDP Installation Script  - Ver 0.4              #\e[0m"
/bin/echo -e "\e[1;36m#   Written by Griffon - June 2018 - www.c-nergy.be           #\e[0m"
/bin/echo -e "\e[1;36m#-------------------------------------------------------------#\e[0m"
echo

#---------------------------------------------------#
# Step 0 - Try to Detect Ubuntu Version.... 
#---------------------------------------------------#

echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Detecting Ubuntu version                  # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

version=$(lsb_release -d | awk -F":" '/Description/ {print $2}') 

if [[ "$version" = *"Ubuntu 17.10"* ]] || [[ "$version" = *"Ubuntu 18.04"* ]];
then
echo
/bin/echo -e "\e[1;32m.... Ubuntu Version :$version\e[0m"
/bin/echo -e "\e[1;32m.... Supported version detected....proceeding\e[0m"

else
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
/bin/echo -e "\e[1;31mYour system is not running Ubuntu 17.10 Edition.\e[0m"
/bin/echo -e "\e[1;31mThe script has been tested only on Ubuntu 17.10...\e[0m"
/bin/echo -e "\e[1;31mThe script is exiting...\e[0m"
/bin/echo -e "\e[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
echo
exit
fi

#---------------------------------------------------#
# Step 1 - Install xRDP Software.... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing XRDP Packages...Proceeding...  # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo apt-get install xrdp -y 

#---------------------------------------------------#
# Step 2 - Install Gnome Tweak Tool.... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Installing Gnome Tweak...Proceeding...    # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo apt-get install gnome-tweak-tool -y

#---------------------------------------------------#
# Step 3 - Allow console Access .... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Granting Console Access...Proceeding...   # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config

#---------------------------------------------------#
# Step 4 - create policies exceptions .... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Creating Polkit File...Proceeding...      # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

sudo bash -c "cat >/etc/polkit-1/localauthority/50-local.d/45-allow.colord.pkla" <<EOF
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
EOF

#---------------------------------------------------#
# Step 5 - Fixing Theme and Extensions .... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Fix Theme and extensions...Proceeding...  # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo

#Check if script has already run.... 
if grep -xq "#fixGDM-by-Griffon" /etc/xrdp/startwm.sh; then
 echo "Skip theme fixing as script has run at least once..."
else
#Set xRDP session Theme to Ambiance and Icon to Humanity
sudo sed -i.bak "4 a #fixGDM-by-Griffon\ngnome-shell-extension-tool -e ubuntu-appindicators@ubuntu.com\ngnome-shell-extension-tool -e ubuntu-dock@ubuntu.com\n\nif [ -f ~/.xrdp-fix-theme.txt ]; then\necho 'no action required'\nelse\ngsettings set org.gnome.desktop.interface gtk-theme 'Ambiance'\ngsettings set org.gnome.desktop.interface icon-theme 'Humanity'\necho 'check file for xrdp theme fix' >~/.xrdp-fix-theme.txt\nfi\n" /etc/xrdp/startwm.sh
fi
echo

#---------------------------------------------------#
# Step 6 - Fix GDM Lock screen color .... 
#---------------------------------------------------#

#Detect if argument passed
ARGS=$1
echo $ARGS

if [ "$ARGS" = "--fixGDM" ]; 
then 
echo
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
/bin/echo -e "\e[1;33m!   Fix for GDM Lock Screen color...          # \e[0m"
/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
echo
# Step 1 - Install prereqs for compilation later on
sudo apt-get -y install libglib2.0-dev-bin
sudo apt-get -y install libxml2-utils

# extract gresource info (from url...)
workdir=${HOME}/shell-theme
if [ ! -d ${workdir}/theme ]; then
  mkdir -p ${workdir}/theme
  mkdir -p ${workdir}/theme/icons

fi
gst=/usr/share/gnome-shell/gnome-shell-theme.gresource
 
for r in `gresource list $gst`; do
        gresource extract $gst $r >$workdir/${r#\/org\/gnome\/shell/}
done

/bin/echo -e "\e[1;33m  -->Creating XML File...   \e[0m"
# create the xml file 
bash -c "cat >${workdir}/theme/gnome-shell-theme.gresource.xml" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    <file>calendar-arrow-left.svg</file>
    <file>calendar-arrow-right.svg</file>
    <file>calendar-today.svg</file>
    <file>checkbox-focused.svg</file>
    <file>checkbox-off-focused.svg</file>
    <file>checkbox-off.svg</file>
    <file>checkbox.svg</file>
    <file>close-window.svg</file>
    <file>close.svg</file>
    <file>corner-ripple-ltr.png</file>
    <file>corner-ripple-rtl.png</file>
    <file>dash-placeholder.svg</file>
    <file>filter-selected-ltr.svg</file>
    <file>filter-selected-rtl.svg</file>
    <file>gnome-shell.css</file>
    <file>gnome-shell-high-contrast.css</file>
    <file>logged-in-indicator.svg</file>
    <file>no-events.svg</file>
    <file>no-notifications.svg</file>
    <file>noise-texture.png</file>
    <file>page-indicator-active.svg</file>
    <file>page-indicator-inactive.svg</file>
    <file>page-indicator-checked.svg</file>
    <file>page-indicator-hover.svg</file>
    <file>process-working.svg</file>
    <file>running-indicator.svg</file>
    <file>source-button-border.svg</file>
    <file>summary-counter.svg</file>
    <file>toggle-off-us.svg</file>
    <file>toggle-off-intl.svg</file>
    <file>toggle-on-hc.svg</file>
    <file>toggle-on-us.svg</file>
    <file>toggle-on-intl.svg</file>
    <file>ws-switch-arrow-up.png</file>
    <file>ws-switch-arrow-down.png</file>
  </gresource>
</gresources>
EOF
cd ${workdir}/theme
/bin/echo -e "\e[1;33m  -->Modify Css...   \e[0m"
sed -i -e 's/background: #2e3436/background: #2c00e1/g' ~/shell-theme/theme/gnome-shell.css 

##Delete the file noise-texture.png (grey one)
rm ${workdir}/theme/noise-texture.png

/bin/echo -e "\e[1;33m  -->Download Purple image file...   \e[0m"
#Download the noise-texture.png with purple background 
wget http://www.c-nergy.be/downloads/noise-texture.png

/bin/echo -e "\e[1;33m  -->Compile Resource File...   \e[0m"
#Compile file and copy to correct location....
cd ${workdir}/theme
glib-compile-resources gnome-shell-theme.gresource.xml 

/bin/echo -e "\e[1;33m  -->Copy file to target location...   \e[0m"

# make a backup of the file and copy the file....
sudo cp /usr/share/gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource.bak
sudo cp ${workdir}/theme/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource
echo
#echo
#/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
#/bin/echo -e "\e[1;33m!   REBOOT YOUR SYSTEM TO APPLY CHANGES  ...  # \e[0m"
#/bin/echo -e "\e[1;33m#---------------------------------------------#\e[0m"
#echo
echo
else 
echo "No Parameter Pass for GDM FIX....."
fi

#---------------------------------------------------#
# Step 6 - Credits .... 
#---------------------------------------------------#
echo
/bin/echo -e "\e[1;36m#-----------------------------------------------------------------------#\e[0m"
/bin/echo -e "\e[1;36m# Installation Completed\e[0m"
/bin/echo -e "\e[1;36m# Please test your xRDP configuration.A Reboot Might be required...\e[0m"
/bin/echo -e "\e[1;36m# Written by Griffon - June 2018 - Ver 0.4 - Std-Xrdp-Install-0.4.sh\e[0m"
/bin/echo -e "\e[1;36m#-----------------------------------------------------------------------#\e[0m"
echo





