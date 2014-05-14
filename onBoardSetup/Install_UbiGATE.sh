#!/bin/bash
##########################################################
#   Install UbiGATE on Beaglebone Debian 7
#   
#   @date       29/04/2014
#   @copyright  PAWN International
#   @author     Hamdi Aloulou
#   @author     Mickael Germain
#   
#   @todo       Allow service to be launch after mochad
#   @bug        
#   
##########################################################

. utils.sh

#---------------------------------------------------------
# UbiGATE :
PATH_TO_UBIGATE='/usr/local/bin'
PATH_TO_LIB='/usr/local/lib'
PATH_TO_LOG='/var/log/ubiGATE'
FIC_LOGROTATE='mochadForUbiGATE'

h1 "Installing UbiGATE"

h2 'Getting python module httplib2'
pip install httplib2 -q 
if [ $? = 0 ]; then
	echook 'Installation completed.'
else
	echofail 'Installation has failed.'
	echofail "Installation of ubiGATE has failed."
	echo "Leaving script $0 ..."
	exit 1
fi

h2 'Setting up service ubiGATE'
cp -r ubiGATE "$PATH_TO_LIB" &&
ln -s "$PATH_TO_LIB/ubiGATE/main.py" "$PATH_TO_UBIGATE/ubiGATE" &&
cp services/ubiGATE.service /lib/systemd/system/ &&
sed -i -e "s;\$PATH_TO_UBIGATE;$PATH_TO_UBIGATE;g" \
		    "/lib/systemd/system/ubiGATE.service" &&
systemctl enable ubiGATE.service
if [ $? = 0 ]; then
	echook 'Setting up service completed.'
	echook 'Installation of UbiGATE completed'
else
	echofail 'Setting up service has failed.'
	echofail "Installation of ubiGATE has failed."
	echo "Leaving script $0 ..."
	exit 1
fi

#---------------------------------------------------------
# End of File.