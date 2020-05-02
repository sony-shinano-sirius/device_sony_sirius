#!/system/bin/sh

mount_system() {
    export SYSDEV="$(readlink -nf "/dev/block/platform/msm_sdcc.1/by-name/system")"

    if grep -q -e"^$SYSDEV" /proc/mounts; then
        umount $(grep -e"^$SYSDEV" /proc/mounts | cut -d" " -f2)
    fi

    if [ -d /mnt/system ]; then
        SYSMOUNT="/mnt/system"
    elif [ -d /system_root ]; then
        SYSMOUNT="/system_root"
    else
        SYSMOUNT="/system"
    fi
    S="$SYSMOUNT/system"

    mount -t ext4 $SYSDEV $SYSMOUNT -o rw,discard
}

umount_system() {
  umount "$SYSMOUNT"
}

mount_system
mkdir -p /lta-label
mount -o ro /dev/block/platform/msm_sdcc.1/by-name/LTALabel /lta-label
ls lta-label/*.html | grep -q d6502
if [ $? -eq 0 ]; then
    for i in $(ls $S/vendor/firmware/d6502/); do
				mv $S/vendor/firmware/d6502/$i $S/vendor/firmware/
    done
		rm -rf $S/vendor/firmware/d6502/
else
    rm -rf $S/vendor/firmware/d6502/
fi
umount /lta-label
umount_system
