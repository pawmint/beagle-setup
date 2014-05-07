#!/bin/bash
##########################################################
#   Configure Wvdial and pppd for internet connection 
#	through 3G dongle
#   
#   @date       07/05/2014 
#   @copyright  PAWN International
#   @author      
#
#   @todo       
#   @bug        Not Tested yet
#   
##########################################################

. utils.sh

#---------------------------------------------------------
#  :

PROVIDER='free'

h1 'Installing internet connection through 3G dongle'

h2 'Moving configuration files'
cp wvdial.conf /etc &&
cp ip-up.local ip-down.local /etc/ppp/
if [ $? = 0 ]; then
    echook 'Moving done.'
else
    echofail 'Moving has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 'Setting up service 3GDongle'
cp services/3GDongle.service /lib/systemd/system/ &&
sed -i -e "s;\$PROVIDER;$PROVIDER;g" \
		    "/lib/systemd/system/3GDongle.service" &&
systemctl enable 3GDongle.service
if [ $? = 0 ]; then
	echook 'Setting up service completed.'
	echook 'Installation of internet connection through 3G dongle completed.'
else
	echofail 'Setting up service has failed.'
	echofail "Installation of internet connection through 3G dongle has failed."
	echo "Leaving script $0 ..."
	exit 1
fi

#---------------------------------------------------------
# End of File.