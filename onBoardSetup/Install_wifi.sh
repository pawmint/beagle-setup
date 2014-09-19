#!/bin/bash
##########################################################
#   Configure Wvdial and pppd for internet connection
#	through 3G dongle
#
#   @date       17/09/2014
#   @copyright  PAWN International
#
#
##########################################################

. utils.sh

#---------------------------------------------------------
#  :

ESSID='PAWMINT'
PASSWORD='pawmint2014'

h1 'Install internet connection through Wifi dongle'

h2 'Installing required network tools'
apt-get install wireless-tools -y
apt-get install udhcpc -y

h2 'Installing WiPi driver'
cp ./onBoardSetup/rt2870.bin /lib/firmware
sync
if [ $? = 0 ]; then
    echook 'WiPi driver successfully installed'
else
    echofail 'A problem occured with the WiPi driver'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 'Configuring Wifi'
systemctl disable wpa_supplicant.service
systemctl stop wpa_supplicant.service
if [ $? = 0 ]; then
    echook 'WPA-Supplicant service disabled'
else
    echofail "A problem occured with the WPA-Supplicant service"
    echo "Leaving script $0 ..."
    exit 1
fi

cp ./onBoardSetup/network_interfaces /etc/network/interfaces

cp ./onBoardSetup/wpa_supplicant.conf ~
wpa_passphrase $ESSID $PASSWORD >> wpa_supplicant.conf
mv wpa_supplicant.conf /etc/wpa_supplicant
chown root:root /etc/wpa_supplicant/wpa_supplicant.conf
ifconfig wlan0 up

# ifdown wlan0
# ifup wlan0

# wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
# udhcpc -i wlan0

# ifconfig eth0 down

if [ $? = 0 ]; then
    echook 'Wifi is now properly configured'
else
    echofail 'A problem occured with the wifi configuration'
    echo "Leaving script $0 ..."
    exit 1
fi

ifdown wlan0
ifup wlan0

echo "Wifi should now be running"

#---------------------------------------------------------
# End of File.
