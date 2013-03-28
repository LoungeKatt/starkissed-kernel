#!/system/bin/sh
bb="/sbin/bb/busybox"

$bb mount -o rw,remount /system
$bb [ -f /system/lib/hw/power.tuna.so.fkbak ] || $bb cp /system/lib/hw/power.tuna.so /system/lib/hw/power.tuna.so.fkbak
$bb cp /sbin/power.tuna.so /system/lib/hw/
$bb chmod 644 /system/lib/hw/power.tuna.so
$bb mount -o ro,remount /system

echo "0" > /sys/module/wakelock/parameters/debug_mask
echo "0" > /sys/module/userwakelock/parameters/debug_mask
echo "0" > /sys/module/earlysuspend/parameters/debug_mask
echo "0" > /sys/module/alarm/parameters/debug_mask
echo "0" > /sys/module/alarm_dev/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask

# initialize the devices
#echo 512000 > /sys/block/zram0/disksize

# Creating swap filesystems
#$bb mkswap /dev/block/zram0

# Switch the swaps on
#$bb swapon -p 60 /dev/block/zram0

#$bb mkswap /sdcard/swap/swapfile.swp
#$bb mknod -m640 /dev/block/loop50 b 7 50
#$bb losetup /dev/block/loop50 /sdcard/swap/swapfile.swp
#$bb swapon /dev/block/loop50

sleep 60
pid=`pidof com.android.launcher`
echo "-17" > /proc/$pid/oom_adj
chmod 100 /proc/$pid/oom_adj