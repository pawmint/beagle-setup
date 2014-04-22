#!/bin/bash
##########################################################
#	
#	@date		23/04/2014
#	@copyright 	PAWN International
#	@author		Hamdi Aloulou
#	@author		Mickael Germain
#	@todo
#	@bug		
#	
##########################################################

. onBoardSetup/utils.sh

./firmwareUpdate.sh || exit
echo ''
read -r -p 'When all previous steps have been done press [Enter] key.' VAR
read -r -p 'Plug in the Beaglebone Back via USB then press [Enter] key.' VAR
echo 'Waiting 50 seconds to ensure that beaglebone is ready.'
sleep 50
./remoteSetup.sh

#---------------------------------------------------------
# End of File.

