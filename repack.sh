#!/bin/sh

. ./config.ini

if [ ! -d $MOUNTPOINT ]; then
	echo "The folder '$MOUNTPOINT' does not exist, I can't repack. Exiting !!!"
	exit 1

fi

#check for required packages
REQPACKAGES="split"
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

echo "Repacking firmware"

if [ ! -f "$TMPFOLDER/1M" ]; then
        echo "File $TMPFOLDER/1M does not exist, I can't continue repacking, exiting !!!"
        exit 1
fi

if [ ! -f "$TMPFOLDER/raw_firmware" ]; then
        echo "File $TMPFOLDER/raw_firmware does not exist, I can't continue repacking, exiting !!!"
        exit 1
fi

echo "Step 1 of 7 - Unmounting firmware from '$MOUNTPOINT'..."
umount -l $MOUNTPOINT

echo "Step 2 of 7 - Merging '1M' and 'raw_firmware' files into a file named 'merged_firmware'..."
cat $TMPFOLDER/1M $TMPFOLDER/raw_firmware > $TMPFOLDER/merged_firmware

echo "Step 3 of 7 - Updating checksum of '$TMPFOLDER/merged_firmware' using 'twt' "
tools/twt -c update -s $TMPFOLDER/merged_firmware || exit 1

echo "Step 4 of 7 - Splitting 'merged_firmware' file in 800MB length files..."
split -b 800M -d  $TMPFOLDER/merged_firmware $TMPFOLDER/$FIRMWAREID.0


echo "Step 5 of 7 - Deleting 'merged_firmware' file, we don't need it from here !"
rm $TMPFOLDER/merged_firmware

echo "Step 6 of 7 - Renaming splitted files..."
mv $TMPFOLDER/$FIRMWAREID.000 $TMPFOLDER/$FIRMWAREID.0
#echo "Created file: $TMPFOLDER/$FIRMWAREID.0"
mv $TMPFOLDER/$FIRMWAREID.001 $TMPFOLDER/$FIRMWAREID.1
#echo "Created file: $TMPFOLDER/$FIRMWAREID.1"
mv $TMPFOLDER/$FIRMWAREID.002 $TMPFOLDER/$FIRMWAREID.2
#echo "Created file: $TMPFOLDER/$FIRMWAREID.2"
mv $TMPFOLDER/$FIRMWAREID.003 $TMPFOLDER/$FIRMWAREID.3
#echo "Created file: $TMPFOLDER/$FIRMWAREID.3"

if [ ! -d "$TGTFIRMWAREFOLDER/" ]; then
        echo "            - [INFO] Creating target directory: $TGTFIRMWAREFOLDER..."
	mkdir -p $TGTFIRMWAREFOLDER
fi

if [ -f "$TGTFIRMWAREFOLDER/$FIRMWAREID.0"  ]; then
	if [ ! -d $TGTFIRMWAREFOLDER/previous_patched ]; then
		echo "            - [INFO] Creating backup directory: $TGTFIRMWAREFOLDER/previous_patched..."
		mkdir $TGTFIRMWAREFOLDER/previous_patched
	fi
	echo "            - [INFO] - Moving previously generated patched firmware to $TGTFIRMWAREFOLDER/previous_patched directory"
	mv $TGTFIRMWAREFOLDER/$FIRMWAREID.0 $TGTFIRMWAREFOLDER/previous_patched/$FIRMWAREID.0
	mv $TGTFIRMWAREFOLDER/$FIRMWAREID.1 $TGTFIRMWAREFOLDER/previous_patched/$FIRMWAREID.1
	mv $TGTFIRMWAREFOLDER/$FIRMWAREID.2 $TGTFIRMWAREFOLDER/previous_patched/$FIRMWAREID.2
	mv $TGTFIRMWAREFOLDER/$FIRMWAREID.3 $TGTFIRMWAREFOLDER/previous_patched/$FIRMWAREID.3
fi

echo "Step 7 of 7 - Moving the new generated firmware files to target dir $TGTFIRMWAREFOLDER ..."
mv $TMPFOLDER/$FIRMWAREID.* $TGTFIRMWAREFOLDER/.

echo "Finished with the new patched firmware."

echo "Mounting ready raw firmware into '$MOUNTPOINT/' folder if you intend to continue modifying the firmware"
mount -t auto -o loop $TMPFOLDER/raw_firmware $MOUNTPOINT/

echo "Done !!! the patched firmware is here: $TGTFIRMWAREFOLDER"

exit 0
