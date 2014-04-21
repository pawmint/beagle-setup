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

h1 "Installing Mochad"
h2 "Installing Mochad dependencies"

echo 'Installing libusb'
apt-get install libusb-1.0-0-dev -y


h2 "Downloading Mochad sources"
wget -O - "WEB_MOCHAD" | tar xzf -
h2 "Building Mochad"
cd "mochad*"
./configure &&
make
make install
cd ..
h2 "Cleaning"
rm -r "mochad*"

#---------------------------------------------------------
# End of File.
