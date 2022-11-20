#!/bin/sh

echo "Injecting SU to firmware."

. ./config.ini

SUFOLDER="_superuser"

if [ ! -d $MOUNTPOINT ]; then
        echo "The folder '$MOUNTPOINT' does not exist, I can't inject 'su'. Exiting !!!"
        exit 1
fi

if [ ! -d $SUFOLDER ]; then
	echo "The folder '$SUFOLDER' does not exist, I can't inject 'su'. Exiting !!!"
	exit 1
 else

	# install su
	if [ -f $SUFOLDER/system/bin/su ]; then
		echo "Copying 'su' binary to 'bin'..."
		cp $SUFOLDER/system/bin/su $MOUNTPOINT/system/bin/
		cp $SUFOLDER/system/bin/su $MOUNTPOINT/system/bin/sudaemon
		if [ -f $MOUNTPOINT/system/bin/su ]; then
			echo "- 'su' binary copied successfully !"
		fi
	 else
		echo "'su' binary not found in '$SUFOLDER/system/bin'. Exiting !!!"
		exit 1
	fi
	echo " "
        if [ -f $SUFOLDER/system/xbin/su ]; then
		if [ ! -d $MOUNTPOINT/system/xbin ]; then
			echo "! Folder system/xbin not found: Creating 'xbin' inside 'system'..."
			mkdir $MOUNTPOINT/system/xbin
		fi
                echo "Copying 'su' binary to 'xbin'..."
                cp $SUFOLDER/system/xbin/su $MOUNTPOINT/system/xbin/
		cp $SUFOLDER/system/xbin/su $MOUNTPOINT/system/xbin/sudaemon
                if [ -f $MOUNTPOINT/system/bin/su ]; then
	                echo "- 'su' binary copied successfully !"
                fi
         else
                echo "'su' binary not found in '$SUFOLDER/system/bin' or $SUFOLDER/system/xbin. Exiting !!!"
                exit 1
        fi
	echo " "

	# install supolicy
        if [ -f $SUFOLDER/system/bin/supolicy ]; then
                echo "Copying 'supolicy' binary to 'bin'..."
                cp $SUFOLDER/system/bin/supolicy $MOUNTPOINT/system/bin/
                if [ -f $MOUNTPOINT/system/bin/supolicy ]; then
                        echo "- 'supolicy' binary copied successfully !"
                fi
         else
                echo "'supolicy' binary not found in '$SUFOLDER/system/bin'. Exiting !!!"
                exit 1
        fi
	echo " "
        if [ -f $SUFOLDER/system/xbin/supolicy ]; then
                if [ ! -d $MOUNTPOINT/system/xbin ]; then
                        echo "! Folder system/xbin not found: Creating 'xbin' inside 'system'..."
                        mkdir $MOUNTPOINT/system/xbin
                fi
                echo "Copying 'supolicy' binary to 'xbin'..."
                cp $SUFOLDER/system/xbin/supolicy $MOUNTPOINT/system/xbin/
                if [ -f $MOUNTPOINT/system/bin/supolicy ]; then
                        echo "- 'supolicy' binary copied successfully !"
                fi
         else
                echo "'supolicy' binary not found in '$SUFOLDER/system/bin' or '$SUFOLDER/system/xbin'. Exiting !!!"
                exit 1
        fi
	echo " "

        # install libsupol.so
        if [ -f $SUFOLDER/system/lib/libsupol.so ]; then
                echo "Copying 'libsupol.so' binary to 'system/lib'..."
                cp $SUFOLDER/system/lib/libsupol.so $MOUNTPOINT/system/lib/
                if [ -f $MOUNTPOINT/system/lib/libsupol.so ]; then
                        echo "- 'libsupol.so' copied successfully !"
                fi
         else
                echo "'libsupol.so' file not found in '$SUFOLDER/system/lib'. Exiting !!!"
                exit 1
        fi
        if [ -f $SUFOLDER/system/lib64/libsupol.so ]; then
                echo "Copying 'libsupol.so' binary to 'system/lib64'..."
                cp $SUFOLDER/system/lib64/libsupol.so $MOUNTPOINT/system/lib64/
                if [ -f $MOUNTPOINT/system/lib64/libsupol.so ]; then
                        echo "- 'libsupol.so' copied successfully !"
                fi
         else
                echo "'libsupol.so' file not found in '$SUFOLDER/system/lib64'. Exiting !!!"
                exit 1
        fi
	echo " "

	# install rooting.rc
	if [ -f $SUFOLDER/rooting.rc ]; then
		echo "Copying 'rooting.rc' file to firmware..."
		cp $SUFOLDER/rooting.rc $MOUNTPOINT
	        if [ -f $MOUNTPOINT/rooting.rc ]; then
	                echo "- 'rooting.rc' file copied successfully !"
	        fi
	 else
                echo "'rooting.rc' not found in '$SUFOLDER/'. Exiting !!!"
                exit 1
	fi
	echo " "

	echo "Patching init.rc to load 'su' binary as daemon..."
	echo "WARNING !!! This is very dangerous, from now all apks will have root privileges automatically"
	echo "This is a workaround, one day we will be able to patch the boot via magisk (maybe ?)."
	echo " "

	# Install init.rc
        #if [ -f $SUFOLDER/init.rc ]; then
        #        echo "Copying 'init.rc' file to firmware..."
	#	cp $SUFOLDER/init.rc $MOUNTPOINT
        #        if [ -f $MOUNTPOINT/init.rc ]; then
        #                echo "- 'init.rc' file copied successfully !"
        #        fi
        # else
        #        echo "'init.rc' not found in $SUFOLDER/. Exiting !!!"
        #        exit 1
        #fi
	#echo " "

	echo "Modifying internal configuration files..."
	echo "- file: /system/build.prop"

	sed -i '/ro.system.build.type=user/c\ro.system.build.type=userdebug' $MOUNTPOINT/system/build.prop
	sed -i '/ro.build.type=user/c\ro.build.type=userdebug' $MOUNTPOINT/system/build.prop

	echo "- file: /system/etc/prop.default"
	sed -i '/ro.secure=1/c\ro.secure=0' $MOUNTPOINT/system/etc/prop.default
	sed -i '/ro.adb.secure=1/c\ro.adb.secure=0' $MOUNTPOINT/system/etc/prop.default
	sed -i '/security.perf_harden=1/c\security.perf_harden=0' $MOUNTPOINT/system/etc/prop.default
	sed -i '/ro.debuggable=0/c\ro.debuggable=1' $MOUNTPOINT/system/etc/prop.default

	echo "Patching init.rc..."
	patch -R $MOUNTPOINT/init.rc $SUPERUSERFOLDER/init.rc.patch

	echo "Done !"

fi

exit 0
