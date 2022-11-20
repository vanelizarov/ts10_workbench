#!/bin/sh

. ./config.ini

if [ -d $MOUNTPOINT ]; then
	echo "Unmounting and deleting folder '$MOUNTPOINT'..."
        umount -l $MOUNTPOINT & rm -R $MOUNTPOINT 
 else
        echo "The folder '$MOUNTPOINT' does not exist, Nothing to clean here."
fi

if [ -d $TMPFOLDER ]; then
	echo "Deleteing folder '$TMPFOLDER'..."
        rm -R $TMPFOLDER
	echo "All done !"
 else
        echo "The folder '$TMPFOLDER' does not exist, Nothing to clean here."
fi



exit

