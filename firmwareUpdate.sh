#!/bin/bash
##########################################################
#   Script for burning a micro SD card in order to
#   update board with latest software.
#   Based on http://beagleboard.org/Getting%20Started#step3 .
#   
#   @date       22/04/2014
#   @copyright  PAWN International
#   @author     Hamdi Aloulou
#   @author     Mickael Germain
#   
#   @todo
#   @bug        
#   
##########################################################

# Same functions as utils.sh, just for standalone.
function h1 ()
{
    echo -e '\033[36m\033[1m'
    echo -e '----------------------------------------------------------'
    echo -e "$1"
    echo -e -n '\033[0m'
    sleep 3
}

function h2 ()
{
    echo -e '\033[34m'
    echo -e "$1"
    echo -e -n '\033[0m'
    sleep 1
}

function echook ()
{
    echo -e -n '[ \033[32mOK\033[0m ] '
    echo -e "$*"
}

function echofail ()
{
    echo -e -n '[\033[31m\033[1mFAIL\033[0m] '
    echo -e "$*"
}

#---------------------------------------------------------
# Find latest version on http://beagleboard.org/latest-images
# Link to the location of firmware images.
WEB_IMG='http://debian.beagleboard.org/images/'
# File name of the firmware version to be burned.
IMG_VER='BBB-eMMC-flasher-debian-7.4-2014-04-14-2gb'

#---------------------------------------------------------
# Burning firmware image :

h2 'Getting firmware image'
# If file exist, don't download it again.
if [ -f "$IMG_VER.img" ]; then
    echook 'Download completed.'
    echook 'Uncompress completed.'
else
    wget "$WEB_IMG$IMG_VER.img.xz" &&
    # Check download errors with md5.
    md5sum "$IMG_VER.img.xz" | md5sum -c &&
    echook 'Download completed.' ||
    echofail 'Download has failed.' &&
    echo 'Leaving script...' &&
    exit 1

    apt-get install xz-utils -y -q
    unxz "$IMG_VER.img.xz" &&
    echook 'Uncompress completed.' ||
    echofail 'Uncompress has failed.' && 
    echo 'Leaving script...' &&
    exit 1
fi

h2 'Finding the micro SD card'
OK=0
until [ $OK = 1 ]; do
    read -r -p 'Unplug the micro SD card if it is already plug then Press [Enter] key.' VAR
    # Save disk status.
    fdisk -l > fdisk1.tmp
    read -r -p 'Plug the micro SD card then Press [Enter] key.' VAR
    # Save new disk status.
    fdisk -l > fdisk2.tmp
    # Keep the differences between both snapshot.
    FDISK=`diff fdisk1.tmp fdisk2.tmp`
    rm fdisk1.tmp fdisk2.tmp
    # grep keeps description line of SD card. ex : "> Disque /dev/mmcblk0 : 8 Go, 858993492 octets".
    # cut1 keeps all before ":" (cut2 strangely keeps the ":").
    # cut2 keeps device name. ex : "/dev/mmcblk0".
    DISK=`echo "$FDISK" | grep -e 'Dis.*mmcblk[0-9]' | cut -d ':' -f 1 | cut -d ' ' -f 3`
    if [ -z "$DISK" ]; then
        echo "New SD card undetected."
    else
        if [ `echo "$DISK" | wc -l` != 1 ]; then
            echo "More than one new SD card detected."
        else
            echo "New SD card detected : $DISK ."
            OK=1
        fi
    fi
done

h2 'Unmounting micro SD card'
# grep keeps description line of partitions.
# tr replace tabulation by one space.
# cut keeps partition name. ex : "/dev/mmcblk0p1".
PART=`echo "$FDISK" | grep -e 'mmcblk[0-9]p[0-9]' | tr -s ' ' | cut -d ' ' -f 2`
if [ -z "$PART" ]; then
    # Without partition, the disk is unmounted directly.
    echo "No partition found."
    echo "Unmounting $DISK ."
    umount $DISK 
else
    echo "`echo "$PART" | wc -l` partition(s) found on $DISK."
    for i in $PART ; do
        echo "Unmounting partition $i ."
        umount "$i"
    done
fi

h2 'Burning the micro SD card'
# Disk formatting to FAT32.
mkfs.vfat -F 32 "$DISK" &&
# Burning .img on SD Card.
dd if="$IMG_VER.img" of="$DISK" &&
rm "$IMG_VER.img" &&
echook 'Burning done.' ||
echofail 'Burning has failed.' &&
echo 'Leaving script...' &&
exit 1

#---------------------------------------------------------
# Some setpoints :
h2 'Setpoints'
echo 'Power down the beaglebone black.'
echo 'Plug the micro SD card'
echo 'Hold down the USER/BOOT button and apply power.'
echo 'When the flashing is complete, all 4 USRx LEDs will be lit solid.'
echo ''
echo 'Power down the beaglebone black.'
echo 'Unplug the micro SD card'
#---------------------------------------------------------
# End of File.
