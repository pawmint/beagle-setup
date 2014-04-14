# !bin/bash
##########################################################
#	Script for burning a micro SD card in order to
#	update board with latest software.
#	Based on http://beagleboard.org/Getting%20Started#step3 .
#	
#	@date		09/04/2014
#	@copyright 	PAWN International
#	@author		Mickael Germain
#	@todo
#	@bug		Not tested Yet
#	
##########################################################

#---------------------------------------------------------
# Modify this:
# Find latest version on http://beagleboard.org/latest-images
# Link to the location of firmware images.
WEB_ANGSTR_IMG='https://s3.amazonaws.com/angstrom/demo/beaglebone/'
# File name of the firmware version to be burned.
ANGSTR_IMG_VER='BBB-eMMC-flasher-2013.09.04'

#---------------------------------------------------------
# Burning firmware image :
echo 'Getting firmware image.'
apt-get install xz-utils
wget "$WEB_ANGSTR_IMG$ANGSTR_IMG_VER.img.xz" | unxz

read -r -p 'Plug the micro SD card then Press [Enter] key.' VAR
OK=0
until [ $OK = 1 ]; do
  echo 'Choose the disk corresponding to the micro SD card.'
  fdisk -l
  read -r -p 'Disk : ' DISK
  if [ "1`fdisk -l | grep "$DISK"`" != '1' ]; then 
    OK=1
  else
     echo 'Unknown disk.'
  fi
done

echo 'Unmounting the micro SD card.'
unmount "$DISK"

echo 'Burning the micro SD card.'
dd bs=4M if="$ANGSTR_IMG_VER.img" of="$DISK"
rm "$ANGSTR_IMG_VER.img"

echo 'Burning done.'

#---------------------------------------------------------
# Some setpoints :
echo 'Power down the beaglebone black.'
echo 'Plug the micro SD card'
echo 'Hold down the USER/BOOT button and apply power.'
echo 'When the flashing is complete, all 4 USRx LEDs will be lit solid.'

#---------------------------------------------------------
# End of File.
