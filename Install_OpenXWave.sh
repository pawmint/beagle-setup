#!/bin/bash
##########################################################
#   Install libffi 3.0.13 on Beaglebone Debian 7
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain 
#
#	@todo       
#	@bug        
#	
##########################################################

. utils.sh

#---------------------------------------------------------
# OpenXWave :

WEB_XWAVE='http://open-zwave.googlecode.com/svn/trunk/'

h1 "Installing OpenXWave"
h2 "Installing OpenXWave dependencies"

apt-get install subversion libudev-dev libjson0 libjson0-dev libcurl4-gnutls-dev

h2 "Downloading OpenXWave sources"
mkdir ~/install
cd ~/install
svn co "$WEB_XWAVE" open-zwave-read-only
h2 "Building OpenXWave"
cd open-zwave-read-only
make
cd ..
#h2 "Cleaning"

#---------------------------------------------------------
# End of File.