#!/bin/bash
set -e

modprobe -r g_mass_storage
modprobe -r dwc2

umount /mnt/ramdisk

rm -rf /mnt/ramdisk
