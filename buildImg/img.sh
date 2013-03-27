if [ $1 == "y" ]; then

RAMDISK="dual.img-ramdisk"

chmod 750 dual.img-ramdisk/init*
chmod 750 dual.img-ramdisk/charger
chmod 644 dual.img-ramdisk/default.prop
chmod 644 dual.img-ramdisk/ueventd*

elif [ $2 == "y" ]; then

RAMDISK="legacy41-ramdisk"

else

RAMDISK="boot.img-ramdisk"

fi

if cat /etc/issue | grep Ubuntu; then
    linux/./mkbootfs $RAMDISK | gzip > newramdisk.cpio.gz
    linux/./mkbootimg --cmdline 'no_console_suspend=1' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img
else
    darwin/./mkbootfs $RAMDISK| gzip > newramdisk.cpio.gz
    darwin/./mkbootimg --cmdline 'no_console_suspend=1' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img
fi