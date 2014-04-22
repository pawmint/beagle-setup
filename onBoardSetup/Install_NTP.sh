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

# How to add countries ?
# - Enter in time directory.
# - Add a directory whose name corresponds to the country tag.
# - Enter in this directory .
# - Add a file named 'server' and add the list of ntp servers like 'server addr.example.com' .
# You can find lot of ntp servers on http://www.pool.ntp.org/ .
# - Add a file named 'zone' add the path to localtime file from '/usr/share/zoneinfo/' .
# - You can run the script with your new tag : './Install_NTP.sh "tag"'.

# $1 <=> country tag
# Check country tag
if [ $# = 1 ]; then
    OK=0
    for i in `ls time`; do
        if [ "$1" = "$i" ]; then
            OK=1
        fi
    done
    if [ $OK = 0 ]; then
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
if [ $? = 0 ]; then
    echook 'Installation of NTP completed.'
else
    echofail 'Installation of NTP has failed.'
    echo "Leaving script $0 ..."
    exit 1
fi

h2 "Adding time servers for $COUNTRY to ntp.conf"
NTP_SERVER=`cat "time/$COUNTRY/server"` &&
sed -i "s;\(#server ntp.your-provider.example).*;\1\n$NTP_SERVER;g" /etc/ntp.conf

h2 "Adding localtime file for $COUNTRY"
LOCALTIME_PATH=`cat "time/$COUNTRY/zone"` &&
rm /etc/localtime &&
ln -s "/usr/share/zoneinfo/$LOCALTIME_PATH" /etc/localtime

#---------------------------------------------------------
# End of File.