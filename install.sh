#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo $0)"
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Usage: $0 <volume_name>"
    echo "Example: $0 data"
    exit 1
fi

VOLUME_NAME="$1"
sed "s/data.key/${VOLUME_NAME}.key/g" "set-key.sh" > "set-key.sh.tmp"

echo "Installing setup-secure-usb.sh script"
cp "setup-secure-usb.sh" "/usr/local/bin/setup-secure-usb.sh"
chmod +x "/usr/local/bin/setup-secure-usb.sh"

echo "Installing cleanup-secure-usb.sh script"
cp "cleanup-secure-usb.sh" "/usr/local/bin/cleanup-secure-usb.sh"
chmod +x "/usr/local/bin/cleanup-secure-usb.sh"

echo "Installing set-key.sh script"
cp "set-key.sh.tmp" "/usr/local/bin/set-key.sh"
rm "set-key.sh.tmp"
chmod +x "/usr/local/bin/set-key.sh"

echo "Installing systemd unit"
cp "secureusb.service" "/etc/systemd/system/secureusb.service"
systemctl enable secureusb
systemctl start secureusb
systemctl daemon-reload

echo "Finished. Key file will be named: ${VOLUME_NAME}.key"
