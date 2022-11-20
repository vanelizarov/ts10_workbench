#!/bin/sh

. ./config.ini

if [ -d $MOUNTPOINT ]; then
        echo "The folder '$MOUNTPOINT' exists, I can't import as it seems that you're already editing a firmware."
        echo "If you wan to import, unmount the dir $MOUNTPOINT prior to use import script."
	echo "You can use './clean_local.sh' to leave the mounted image."
        echo "Exiting !!!"
        exit 1

fi

echo "checking if $TMPFOLDER folder exists"

if [ ! -d "$TMPFOLDER" ]; then
	echo "Creating" $TMPFOLDER "folder..."
	mkdir $TMPFOLDER
 else
        echo "Deleting contents into $TMPFOLDER"
        rm $TMPFOLDER/*
fi

echo "Importing and assembling firmware in one piece"
echo "From: $TGTFIRMWAREFOLDER"
echo "To: $TMPFOLDER/merged_firmware"
echo "Please wait..."

cat $TGTFIRMWAREFOLDER/$FIRMWAREID.0 \
    $TGTFIRMWAREFOLDER/$FIRMWAREID.1 \
    $TGTFIRMWAREFOLDER/$FIRMWAREID.2 \
    $TGTFIRMWAREFOLDER/$FIRMWAREID.3 > $TMPFOLDER/merged_firmware

echo "DONE !!!"

exit

