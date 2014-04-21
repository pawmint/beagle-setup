#!/bin/bash
##########################################################
#   Install UbiGATE on Beaglebone Debian 7
#   
#   @date       18/04/2014
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

h1 "Installing UbiGATE"

cp ubiGATE "$PATH_TO_UBIGATE"
cp services/ubiGATE.service /lib/systemd/system/
sed -i "s;\$PATH_TO_UBIGATE;$PATH_TO_UBIGATE;g" "/lib/systemd/system/ubiGATE.service"

sysctemctl enable ubiGATE.service
sysctemctl start ubiGATE.service

pip install httplib2 -q

#---------------------------------------------------------
# End of File.