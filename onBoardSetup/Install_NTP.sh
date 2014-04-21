#!/bin/bash
##########################################################
#   Install NTP on Beaglebone Debian 7
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

# Setting up time :
# Based on http://derekmolloy.ie/automatically-setting-the-beaglebone-black-time-using-ntp/ .

# Country where BeagleBone is expected to function.
if [ $# = 1 ]; then
    OK='0'
    for i in `ls time`; do
        if [ "$1" = "$i" ]; then
            OK='1'
        fi
    done
    if [ "$OK" = '0' ]; then
        COUNTRY='fr'
        echo "The country tag $COUNTRY is unknow : By default, France region is applied." >&2
    else
        COUNTRY="$1"
    fi
else
    COUNTRY='fr'
    echo "Unspecified region : By default, France region is applied."
fi

h1 'Installing NTP'
h2 'Getting NTP'
apt-get install ntp -y -q

h2 "Adding time servers for $COUNTRY to ntp.conf"
# For other time zones search on http://www.pool.ntp.org/ .
NTP_SERVER=cat "time/$COUNTRY/server" &&
sed -i "s;\(#server ntp.your-provider.example).*;\1\n$NTP_SERVER;g" /etc/ntp.conf

h2 'Adding localtime file for $COUNTRY'
LOCALTIME_PATH=cat "time/$COUNTRY/time" &&
rm /etc/localtime &&
ln -s "/usr/share/zoneinfo/$LOCALTIME_PATH" /etc/localtime

#---------------------------------------------------------
# End of File.