#!/bin/bash
##########################################################
#   Install Reverse Proxy on Beaglebone Debian 7
#
#   @date       29/04/2014
#   @copyright  PAWN International
#   @author     Mickael Germain
#
#   @todo
#   @bug
#
##########################################################

. utils.sh

#---------------------------------------------------------
#  :

PROXY_URL='ubuntu@ec2-54-186-251-30.us-west-2.compute.amazonaws.com'
PORT="590$1"
FIC_PRIV_KEY='amazon.pem'
FIC_KNOWN_HOSTS='amazon.id'

h1 'Installing reverse proxy'
h2 'Setting up service'
cp "$FIC_PRIV_KEY" ~/.ssh &&
chmod 600 ~/.ssh/$FIC_PRIV_KEY &&
cat "$FIC_KNOWN_HOSTS" >> ~/.ssh/known_hosts &&
cp services/reverseProxySSH.service /lib/systemd/system/ &&
sed -i -e "s;\$PROXY_URL;$PROXY_URL;g" \
	   -e "s;\$PORT;$PORT;g" \
	   -e "s;\$FIC_PRIV_KEY;$FIC_PRIV_KEY;g" \
		  "/lib/systemd/system/reverseProxySSH.service"
systemctl enable reverseProxySSH.service
if [ $? = 0 ]; then
	echook 'Setting up service completed.'
else
	echofail 'Setting up service has failed.'
	echofail "Installation of reverse proxy has failed."
	echo "Leaving script $0 ..."
	exit 1
fi

#---------------------------------------------------------
