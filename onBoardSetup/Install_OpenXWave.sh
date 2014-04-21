#!/bin/bash
##########################################################
#   Install libffi 3.0.13 on Beaglebone Debian 7
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
# OpenXWave :

WEB_XWAVE='http://open-zwave.googlecode.com/svn/trunk/'

h1 'Installing OpenXWave'

h2 'Installing OpenXWave dependencies'
apt-get install subversion libudev-dev libjson0 libjson0-dev libcurl4-gnutls-dev -y -q &&
echook 'Installation of dependencies completed.' ||
echofail 'Installation of dependencies has failed.' &&
echofail 'Installation of OpenXWave has failed.' &&
echo 'Leaving script...' &&
exit 1

h2 'Downloading OpenXWave sources'
mkdir ~/install
cd ~/install
svn co "$WEB_XWAVE" open-zwave-read-only &&
echook 'Download completed.' ||
echofail 'Download has failed.' && 
echofail 'Installation of OpenXWave has failed.' &&
echo 'Leaving script...' &&
exit 1

h2 'Building OpenXWave'
cd open-zwave-read-only
make &&
echook "Installation of OpenXWave completed." ||
echofail "Installation of OpenXWavee has failed."
cd ..

#h2 'Cleaning up...''

#---------------------------------------------------------
# End of File.