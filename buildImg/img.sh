if cat /etc/issue | grep Ubuntu; then
linux/./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
linux/./mkbootimg --cmdline 'no_console_suspend=1 console=null' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img --base 0x4000000
else
darwin/./mkbootfs boot.img-ramdisk | gzip > newramdisk.cpio.gz
darwin/./mkbootimg --cmdline 'no_console_suspend=1 console=null' --kernel zImage --ramdisk newramdisk.cpio.gz -o boot.img --base 0x4000000
fi
