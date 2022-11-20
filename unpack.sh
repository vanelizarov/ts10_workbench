#!/bin/sh

. ./config.ini

echo "Unpacking firmware"

if [ -d $MOUNTPOINT ]; then
        echo "The folder '$MOUNTPOINT' exists, I can't import as it seems that you're already editing a firmware."
        echo "If you want to unpack, unmount and delete the dir '$MOUNTPOINT' (umount -l $MOUNTPOINT & rm -R $MOUNTPOINT) first."
	echo "Then you can call me again"
        echo "Exiting !!!"
        exit 1

fi

#check for required packages
REQPACKAGES="dd"
errors=0
for i in $REQPACKAGES ; do
        package=$(which $i)
        if [ "$package" = "" ]; then
                errors=1
                echo "Missing package: $i please install using 'apt install $i'"
        fi
done

if [ "$errors" = "1" ]; then
        exit 1
fi

#Check if file exists

if [ -f "$TMPFOLDER/merged_firmware" ]; then
    echo "Going to unpack and mount $TMPFOLDER/merged_firmware ..."
 else
    echo "File $TMPFOLDER/merged_firmware does not exist, can't continue. Exiting !!!"
    exit 1
fi


#Remove the first MEGABYTE of the firmware and create a new file named 'raw_firmware'
echo "Step 1 of 4 - Removing 1st MEGABYTE of data from file '$TMPFOLDER/merged_firmware'. Please wait..."
{  dd bs=1048576 skip=1 count=0 > /dev/null 2>&1; cat; } <$TMPFOLDER/merged_firmware >$TMPFOLDER/raw_firmware

# Copy the first megabyte to a file names 1M
echo "Step 2 of 4 - Copying 1st MEGABYTE of data from file '$TMPFOLDER/merged_firmware' to file '1M' (to assembly later). Please wait..."
dd if=$TMPFOLDER/merged_firmware of=$TMPFOLDER/1M  bs=1048576 count=1 > /dev/null 2>&1

echo "Step 3 of 4 - Deleting crypted firmware image '$TMPFOLDER/merged_firmware'. Please wait..."
rm $TMPFOLDER/merged_firmware > /dev/null 2>&1

# Mount to '$MOUNTPOINT' folder
if [ ! -d "$MOUNTPOINT" ]; then
        echo "            ! Creating" $MOUNTPOINT "folder..."
        mkdir $MOUNTPOINT > /dev/null 2>&1
fi


echo "Step 4 of 4 - Mounting ready raw firmware into '$MOUNTPOINT/' folder. Please wait..."
mount -t auto -o loop $TMPFOLDER/raw_firmware $MOUNTPOINT/

echo " "
echo "!!! READY !!!, you can go into '$MOUNTPOINT/' folder."
echo " "

exit

