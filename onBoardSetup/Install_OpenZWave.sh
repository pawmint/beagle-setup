#!/bin/bash
##########################################################
#   Install OpenZWave on Beaglebone Debian 7
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
# OpenZWave :

WEB_ZWAVE='http://open-zwave.googlecode.com/svn/trunk/'

h1 'Installing OpenZWave'

h2 'Installing OpenZWave dependencies'
apt-get install subversion libudev-dev libjson0 libjson0-dev libcurl4-gnutls-dev -y -q
if [ $? = 0 ]; then
    echook 'Installation of dependencies completed.'
else
    echofail 'Installation of dependencies has failed.'
    echofail 'Installation of OpenZWave has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 'Downloading OpenZWave sources'
mkdir ~/install &&
cd ~/install &&
svn co "$WEB_ZWAVE" open-zwave-read-only
if [ $? = 0 ]; then
    echook 'Download completed.'
else
	echofail 'Download has failed.'
    echofail 'Installation of OpenZWave has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 'Building OpenZWave'
cd open-zwave-read-only &&
make &&
cd ..
if [ $? = 0 ]; then
    echook 'Installation of OpenZWave completed.'
else
    echofail 'Installation of OpenZWave has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

#h2 'Cleaning up...''

#---------------------------------------------------------
# End of File.