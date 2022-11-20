#!/bin/sh

echo "Injecting MODS to firmware."

. ./config.ini

MODSFOLDER="_mods"

if [ ! -d $MOUNTPOINT ]; then
        echo "The folder '$MOUNTPOINT' does not exist, I can't inject MODS. Exiting !!!"
        exit 1

fi

if [ ! -d $MODSFOLDER ]; then
	echo "The folder '$MODSFOLDER' does not exist, I can't inject MODS. Exiting !!!"
	exit 1
 else
	echo "Copying the following files inside the firmware..."
	echo " "
	find  $MODSFOLDER/ -type f
	#echo "Showing and injecting files and folders (they will override those in the firmware)..."
	cp -R $MODSFOLDER/* $MOUNTPOINT/
	echo " "
	echo "Done !"
fi



exit 0
