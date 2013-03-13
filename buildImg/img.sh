if [ $1 == "y" ]; then

chmod 750 dual.img-ramdisk/init* charger
chmod 644 dual.img-ramdisk/default.prop
chmod 640 dual.img-ramdisk/fstab.tuna
chmod 644 dual.img-ramdisk/ueventd*

if cat /etc/issue | grep Ubuntu; then
    linux/./mkbootfs dual.img-ramdisk | gzip > newramdisk.cpio.gz
    linux/./mkbootimg --cmdline 'no_console_suspend=1' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img
else
    darwin/./mkbootfs dual.img-ramdisk | gzip > newramdisk.cpio.gz
    darwin/./mkbootimg --cmdline 'no_console_suspend=1' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img
fi

else

if cat /etc/issue | grep Ubuntu; then
    linux/./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
    linux/./mkbootimg --cmdline 'no_console_suspend=1' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img
else
    darwin/./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
    darwin/./mkbootimg --cmdline 'no_console_suspend=1' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img
fi

fi