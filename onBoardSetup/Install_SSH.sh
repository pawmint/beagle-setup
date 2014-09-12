#!/bin/bash
##########################################################
#   Install Reverse Proxy on Beaglebone Debian 7
#
#   @date       30/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain
#
#   @todo
#   @bug        Not tested yet
#
##########################################################

. utils.sh

#---------------------------------------------------------
#  :

h1 'SSH'
apt-get install ssh -y -q &&
rm -rf /root/.ssh &&
mkdir /root/.ssh &&
ssh-keygen -A &&
cp id_rsa id_rsa.pub /root/.ssh &&
chmod 700 /root/.ssh/id_rsa &&
ssh -o StrictHostKeyChecking=no git@github.com &&
if [ $? = 0 ]; then
	echook 'Installation of ssh completed.'
else
	echofail "Installation of ssh has failed."
	echo "Leaving script $0 ..."
	exit 1
fi

#---------------------------------------------------------
