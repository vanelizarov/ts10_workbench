#!/bin/sh

. ./config.ini

if [ ! -d $MOUNTPOINT ]; then
	echo "The folder '$MOUNTPOINT' does not exist, I can't inject 'tweaks'. Exiting !!!"
	exit 1
fi

echo "Firmware Tweaks..."
echo " "


cActLocale=$(cat $MOUNTPOINT/system/build.prop | grep ro.product.locale | cut -d "=" -f2)
cActDataRoaming=$(cat $MOUNTPOINT/system/build.prop | grep ro.com.android.dataroaming | cut -d "=" -f2)
cActFotaDevice=$(cat $MOUNTPOINT/system/build.prop | grep ro.fota.device | cut -d "=" -f2)
cActBrand=$(cat $MOUNTPOINT/system/build.prop | grep ro.product.system.brand | cut -d "=" -f2)
cActModel=$(cat $MOUNTPOINT/system/build.prop | grep ro.product.system.model | cut -d "=" -f2)
cActName=$(cat $MOUNTPOINT/system/build.prop | grep ro.product.system.name | cut -d "=" -f2)

echo "Your Firmware's actual FOTA device is se to: $cActFotaDevice"
cActCodeFotaDevice=$(echo -n $cActFotaDevice | tail -c 4)
cFixedFotaDevice=$(echo -n $cActFotaDevice | head -c -4)
if [ "$cActCodeFotaDevice" != "0000" ]; then
	echo "The code '$cActCodeFotaDevice' must lead to message 'UI unauthorized, please contact the supplier'"
	read -p "Do you want to replace $cActCodeFotaDevice by 0000 to avoid the message ?: (Y) or leave empty to ignore this step: " cNewFotaDevice
	if [ "$cNewFotaDevice" = "Y" ]; then
		cNewFotaDevice=$cFixedFotaDevice$(echo -n 0000)
		echo "Your new property will be: "$cNewFotaDevice
	fi

 else
	cNewFotaDevice=$cActFotaDevice
	echo "Ok, you will not face the message 'UI unauthorized, please contact the supplier' as you have already code $cNewFotaDevice in ro.fota.device property !"
fi

echo " "
echo " "
echo "Your Firmware's actual brand is set to: $cActBrand"
read -p "Enter the Brand for your firmware (i.e. EKIY, STRONGNAVI, or leave empty to keep the actual one): " cBrand
if [ "$cBrand" = "" ]; then
        cBrand=$cActBrand
fi

echo " "
echo " "
echo "Your Firmware's actual model is set to: $cActModel"
read -p "Enter the Brand for your firmware (i.e. T900, STRONGNAVIK7, or leave empty to keep the actual one): " cModel
if [ "$cModel" = "" ]; then
        cModel=$cActModel
fi

echo " "
echo " "
echo "Your Firmware's actual name is set to: $cActName"
read -p "Enter the Name for your firmware (i.e. HEADUNIT, MYCARNAVI, or leave empty to keep the actual one): " cName
if [ "$cName" = "" ]; then
        cName=$cActName
fi

echo " "
echo " "
echo "Your Firmware's actual locale is se to: $cActLocale"
read -p "Enter the Locale for your firmware (i.e. fr-FR or leave empty to keep the actual one): " cLocale
if [ "$cLocale" = "" ]; then
	cLocale=$cActLocale
fi

echo " "
echo " "
echo "Your Firmware's actual dataroaming is set to: $cActDataRoaming"
read -p "De you want dataroaming ?: (Y/N) or leave empty to keep the actual value: " cDataRoaming
if [ "$cDataRoaming" = "" ]; then
	cDataRoaming=$cActDataRoaming
elif [ "$cDataRoaming" = "Y" ]; then
	cDataRoaming="true"
elif [ "$cDataRoaming" = "N" ]; then
	cDataRoaming="false"
fi

echo " "
echo " "
read -p "Do you want to set your Firmware to be debuggable via ADB and enable OTG ? ('Y' to enable, empty to dismiss) " cDebug
if [ "$cDebug" = "Y" ]; then
        echo " "
        echo " "
        echo "Patching firmware to allow debug via ADB and OTG port..."
        echo " "
	sed -i '/ro.system.build.tags=/c\ro.system.build.tags=test-keys' $MOUNTPOINT/system/build.prop
        sed -i '/ro.product.build.type=/c\ro.product.build.type=eng' $MOUNTPOINT/system/build.prop
        sed -i '/ro.system.build.type=/c\ro.system.build.type=eng' $MOUNTPOINT/system/build.prop
        sed -i '/ro.build.type=/c\ro.build.type=eng' $MOUNTPOINT/system/build.prop
	sed -i '/ro.build.tags=/c\ro.build.tags=test-keys' $MOUNTPOINT/system/build.prop
        sed -i '/ro.vendor.build.type=/c\ro.vendor.build.type=eng' $MOUNTPOINT/system/build.prop
        sed -i '/ro.secure=/c\ro.secure=0' $MOUNTPOINT/default.prop
        sed -i '/ro.adb.secure=/c\ro.adb.secure=0' $MOUNTPOINT/default.prop
        sed -i '/security.perf_harden=/c\security.perf_harden=0' $MOUNTPOINT/default.prop
        sed -i '/ro.debuggable=/c\ro.debuggable=1' $MOUNTPOINT/default.prop
        sed -i '/persist.sys.usb.config=none/c\persist.sys.usb.config=mtp,adb\npersist.service.adb.enable=1\npersist.service.debuggable=1\npersist.sys.isUsbOtgEnabled=1' $MOUNTPOINT/default.prop
fi


echo " "
echo " "

echo "Injecting TWEAKS to firmware..."
echo "	Modifying internal configuration files..."
echo "	- file: /system/build.prop"
echo " "
echo " "
echo "	Modifying Brand to $cBrand ..."
sed -i '/ro.product.system.brand=/c\ro.product.system.brand='$cBrand $MOUNTPOINT/system/build.prop
echo "	Modifying Model to $cModel ..."
sed -i '/ro.product.system.model=/c\ro.product.system.model='$cModel $MOUNTPOINT/system/build.prop
echo "	Modifying Name to $cName ..."
sed -i '/ro.product.system.name=/c\ro.product.system.name='$cName $MOUNTPOINT/system/build.prop
echo "	Modifying Locale to $cLocale..."
sed -i '/ro.product.locale=/c\ro.product.locale='$cLocale $MOUNTPOINT/system/build.prop
echo "	Modifying Dataroaming to $cDataRoaming..."
sed -i '/ro.com.android.dataroaming=/c\ro.com.android.dataroaming='$cDataRoaming $MOUNTPOINT/system/build.prop
echo "	Modifying FOTA Device to $cNewFotaDevice..."
sed -i '/ro.fota.device=/c\ro.fota.device='$cNewFotaDevice $MOUNTPOINT/system/build.prop

echo "Mods done !"
echo " "


exit 0
