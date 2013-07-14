if cat /etc/issue | grep Ubuntu; then

BUILDSTRUCT=linux

else

BUILDSTRUCT=darwin

fi

if [ $1 == "y" ]; then

RAMDISK="dual.img-ramdisk"

cd $RAMDISK
chmod 750 init* charger
chmod 644 default.prop
chmod 640 fstab.tuna
chmod 644 ueventd*
find . | cpio -o -H newc | gzip > ../newramdisk.cpio.gz
cd ../
$BUILDSTRUCT/./mkbootimg --cmdline 'no_console_suspend=1 mms_ts.panel_id=18' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img

else

if [ $2 == "y" ]; then

RAMDISK="legacy41-ramdisk"

else

RAMDISK="boot.img-ramdisk"

fi

$BUILDSTRUCT/./mkbootfs $RAMDISK | gzip > newramdisk.cpio.gz
$BUILDSTRUCT/./mkbootimg --cmdline 'no_console_suspend=1 mms_ts.panel_id=18' --kernel zImage --ramdisk newramdisk.cpio.gz -o $3.img

fi