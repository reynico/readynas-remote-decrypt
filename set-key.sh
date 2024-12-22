#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo $0)"
    exit 1
fi

echo -n "Enter key: "
read -s KEY
echo  # New line after silent read
if [ -z "$KEY" ]; then
    echo "Key cannot be empty"
    exit 1
fi

systemctl restart secureusb

echo "Current USB gadget status:"
lsmod | grep "g_mass_storage"

modprobe -r g_mass_storage
modprobe loop
mkdir -p /mnt/usbkey

LOOPDEV=$(losetup -f)
losetup "$LOOPDEV" /mnt/ramdisk/usb.img
echo "Mounted image to $LOOPDEV"

mount "$LOOPDEV" /mnt/usbkey
echo "Mounted at /mnt/usbkey"

printf "%s" "$KEY" > /mnt/usbkey/data.key
sync
ls -l /mnt/usbkey/data.key

umount /mnt/usbkey
losetup -d "$LOOPDEV"
rmdir /mnt/usbkey

modprobe g_mass_storage file=/mnt/ramdisk/usb.img removable=1 stall=0 ro=0
echo "USB device reloaded"
