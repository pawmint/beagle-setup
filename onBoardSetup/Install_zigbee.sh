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
PATH_TO_ZIGBEE='/usr/local/bin'
PATH_TO_LIB='/usr/local/lib'
PATH_TO_LOG='/var/log/zigbee'
FIC_LOGROTATE='zigbeeForUbiGATE'

h1 "Installing zigbee-gw"

# h2 'Installing python pip'
# apt-get install python-pip -y -q

# h2 'Upgrading python setuptools'
# pip install setuptools --upgrade

# h2 'Getting python modules httplib2, virtualenv and tzlocal'
# pip install httplib2 virtualenv tzlocal -q
# if [ $? = 0 ]; then
# 	echook 'Installation completed.'
# else
# 	echofail 'Installation has failed.'
# 	echofail "Installation of marmitek has failed."
# 	echo "Leaving script $0 ..."
# 	exit 1
# fi

h2 'Setting up service zigbee-gw'
cp -r zigbee-gw "$PATH_TO_LIB" &&
directory=`pwd` &&
cd $PATH_TO_LIB/zigbee-gw &&
python setup.py install &&
cd $directory &&
sed -i -e 's/gateway = house1_zigbee/gateway = house'$1'_zigbee/g' $PATH_TO_LIB/zigbee-gw/resources/conf.ini &&
sed -i -e 's/house = 1/house = '$1'/g' $PATH_TO_LIB/zigbee-gw/resources/conf.ini &&
sed -i -e 's/username = house1_zigbee/username = house'$1'_zigbee/g' $PATH_TO_LIB/zigbee-gw/resources/conf.ini &&
# ln -s "$PATH_TO_LIB/marmitek-gw/marmitek-gw.py" "$PATH_TO_MARMITEK/marmitek" &&
cp services/zigbee.service /lib/systemd/system/ &&
sed -i -e "s;\$PATH_TO_ZIGBEE;$PATH_TO_ZIGBEE;g" \
		    "/lib/systemd/system/marmitek.service" &&
systemctl enable zigbee.service
if [ $? = 0 ]; then
	echook 'Setting up service completed.'
	echook 'Installation of zigbee-gw completed'
else
	echofail 'Setting up service has failed.'
	echofail "Installation of zigbee-gw has failed."
	echo "Leaving script $0 ..."
	exit 1
fi

#vitualenv ubienv
#source ubienv/bin/activate
#cd ubiGATE
#python setup.py develop
#cd ../marmitek-gw
#cp ressources/conf.ini.default ressources/conf.ini
#python /home/marmitek-gw/marmitek-gw.py

#---------------------------------------------------------
# End of File.
