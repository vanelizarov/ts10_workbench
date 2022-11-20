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
echo "From: $SRCFIRMWAREFOLDER"
echo "To: $TMPFOLDER/merged_firmware"
echo "Please wait..."

cat $SRCFIRMWAREFOLDER/$FIRMWAREID.0 \
    $SRCFIRMWAREFOLDER/$FIRMWAREID.1 \
    $SRCFIRMWAREFOLDER/$FIRMWAREID.2 \
    $SRCFIRMWAREFOLDER/$FIRMWAREID.3 > $TMPFOLDER/merged_firmware

echo "DONE !!!"

exit
