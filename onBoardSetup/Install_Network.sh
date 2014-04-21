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
#   @bug        
#   
##########################################################

. utils.sh

# Tips to use the USB adapter under Windows
# on http://derekmolloy.ie/beaglebone/getting-started-usb-network-adapter-on-the-beaglebone/

h1 'Setting up Network'

h2 'Setting up service to configure gateway at boot'
cp services/staticRouteBuilder.service /lib/systemd/system
sed -i "s;\$GATEWAY_IP;$GATEWAY_IP;g" /lib/systemd/system/staticRouteBuilder.service
sysctemctl enable staticRouteBuilder.service
sysctemctl start staticRouteBuilder.service

h2 'Adding nameserver entries'
cp resolv.conf /etc/
cp resolv.conf /etc/resolv.conf.back

#---------------------------------------------------------
# End of File.