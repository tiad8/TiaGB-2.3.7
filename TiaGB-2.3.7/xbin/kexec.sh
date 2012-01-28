#! /system/bin/sh
CARD_PATH=`/bin/grep -o "rel_path=.*" /proc/cmdline | /bin/sed -e "s/.*rel_path=//g" -e "s/ .*//g"`
if [ "$CARD_PATH" = "" ];then
	CARD_PATH="andboot"
fi;
/bin/mount /dev/block/mmcblk0p1 /mnt
if [ -d /mnt/$CARD_PATH ] ; then
	card=/mnt/$CARD_PATH
else
	card=/mnt
fi

/bin/umount /proc/cmdline
#cmd=`sed -e "s/androidboot.serialno.*//" /proc/cmdline`
cmd=`/bin/cat /proc/cmdline`
case "$cmd" in
*kexec*) ;;
*) cmd="$cmd kexec" ;;
esac

/system/xbin/kexec -l --command-line="$cmd" --initrd=$card/initrd.gz $card/zImage
/bin/umount /mnt
/system/xbin/kexec -e
