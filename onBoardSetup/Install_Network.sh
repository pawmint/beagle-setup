#!/bin/bash
##########################################################
#   Setting up network on Beaglebone Debian 7
#   
#   @date       17/04/2014
#   @copyright  PAWN International
#   @author     Hamdi Aloulou
#   @author     Mickael Germain 
#
#   @todo       
#   @bug        Problem with sed
#   
##########################################################

. utils.sh

# Tips to use the USB adapter under Windows
# on http://derekmolloy.ie/beaglebone/getting-started-usb-network-adapter-on-the-beaglebone/
GATEWAY_IP='192.168.7.1'

h1 'Setting up Network'

h2 'Setting up service to configure gateway at boot'
cp services/staticRouteBuilder.service /lib/systemd/system &&
sed -i -e "s;\$GATEWAY_IP;$GATEWAY_IP;g" /lib/systemd/system/staticRouteBuilder.service &&
systemctl enable staticRouteBuilder.service &&
systemctl start staticRouteBuilder.service
if [ $? = 0 ]; then
	echook 'Setting up completed.'
else
	echofail 'Setting up has failed.'
	echo "Leaving script $0 ..."
	exit 1
fi

h2 'Adding nameserver entries'
cp resolv.conf /etc/ &&
cp resolv.conf /etc/resolv.conf.back
if [ $? = 0 ]; then
	echook 'Adding nameserver entries completed.'
else
	echofail 'Adding nameserver entries has failed.'
	echo "Leaving script $0 ..."
	exit 1
fi

#---------------------------------------------------------
# End of File.