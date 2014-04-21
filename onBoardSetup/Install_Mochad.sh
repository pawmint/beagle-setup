#!/bin/bash
##########################################################
#   Install mochad on Beaglebone Debian 7
#   
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#   @todo       
#   @bug        
#   
##########################################################

. utils.sh

#---------------------------------------------------------
# Mochad :

WEB_MOCHAD='http://sourceforge.net/projects/mochad/files/latest/download'

h1 'Installing Mochad'

h2 'Installing Mochad dependencies'
echo 'Installing libusb'
apt-get install libusb-1.0-0-dev -y

h2 'Downloading Mochad sources'
wget -O - "$WEB_MOCHAD" | tar xzf - &&
echook 'Download completed.' ||
echofail 'Download has failed.' && 
echofail "Installation of Mochad has failed." &&
echo 'Leaving script...' &&
exit 1

h2 'Building Mochad'
cd "mochad*"
./configure &&
make &&
make install &&
echook "Installation of Mochad completed." ||
echofail "Installation of Mochad has failed."
cd ..

h2 'Cleaning up'
rm -r "mochad*"
#---------------------------------------------------------
# End of File.
