#!/bin/bash

cd /
mkdir -p /mnt/ramdisk
mount -t tmpfs -o size=5M tmpfs /mnt/ramdisk

dd if=/dev/zero of=/mnt/ramdisk/usb.img bs=1M count=5
mkfs.vfat /mnt/ramdisk/usb.img

modprobe -r g_mass_storage
modprobe -r dwc2

modprobe dwc2
modprobe g_mass_storage file=/mnt/ramdisk/usb.img removable=1 stall=0 ro=0

echo "Image created and mounted as USB device"
ls -l /mnt/ramdisk/usb.img
lsmod | grep "g_mass_storage"
