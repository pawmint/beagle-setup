#!/bin/bash
##########################################################
#   Install UbiGATE on Beaglebone Debian 7
#   @date       
#   @copyright  PAWN International
#   @author      
#
#	@todo       Add python lib, allow service to be launch after mochad
#	@bug        
#	
##########################################################

. utils.sh
#---------------------------------------------------------
# UbiGATE :
PATH_TO_UBIGATE='/usr/local/bin'

h1 "Installing UbiGATE"

cp ubiGATE "$PATH_TO_UBIGATE"
sed -i "s;\$PATH_TO_UBIGATE;$PATH_TO_UBIGATE;g" "$PATH_TO_UBIGATE/ubiGATE/ubiGATE.service"
mv "$PATH_TO_UBIGATE/ubiGATE/ubiGATE.service" /lib/systemd/system/

sysctemctl enable ubiGATE.service
sysctemctl start ubiGATE.service

#---------------------------------------------------------
# End of File.