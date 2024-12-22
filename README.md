# Netgear ReadyNAS remote decrypt

If, for whatever reason, your Netgear ReadyNAS reboots, it will try to find a decryption key for your `{volume_name}` in `/media/*/{volume_name}.key.` This works as expected if you are in the same place as your NAS: You plug the USB drive with the key in it, and the NAS will decrypt your volume(s). The NAS will wait up to 10 minutes for the USB drive to be available, if this time is exceeded, the NAS will start without any shares.

I have encountered this problem a couple of times. It was very painful when I was traveling or not at home at the time, so I decided to fix it: A Raspberry PI Zero in OTG mode can act as a USB mass storage device, and I can remotely load the decryption key in that virtual device.

There is a more detailed write up [here](https://blog.nico.ninja/netgear-readynas-remote-decrypt/).

## Requirements

* Raspberry PI Zero.
* An SD Card for the Raspberry PI.
* Micro USB to USB cable.
* Optional: USB-TTL converter.

## Install

1. Enable USB on the go in `/boot/config.txt.` If your Raspberry PI doesn't have built-in WiFi, enable the UART interface so you can console it.

```
dtoverlay=dwc2
enable_uart=1
```

1. Install the scripts. Replace `<volume_name>` with your actual encrypted volume name.

```
./install.sh <volume_name>
```

## Usage

If you suddenly find your NAS started without any shares, probably due to a reboot or a power outage, SSH into the Raspberry PI or console it with `screen`, and run `set-key.sh`. The script will ask you via stdin to input the decryption key (the contents of the key you saved when you set up encryption in the NAS). Once you are done, stop the `secureusb` service with `sudo systemctl stop secureusb` to avoid leaking the decryption key.

1. SSH or `screen` the Raspbery PI Zero.
2. Run `set-key.sh`.
3. Enter the key via stdin.
4. The ReadyNAS would decrypt the volume.
5. Run `sudo systemctl stop secureusb`.

### Accessing the Raspberry PI through the serial interface

1. You should already have a USB-TTL interface connected to the UART pins (GND, TX, RX) of the Raspberry PI. Follow [this guide from Jeff Geerling](https://www.jeffgeerling.com/blog/2021/attaching-raspberry-pis-serial-console-uart-debugging) to set it up properly.
2. From your server, run:

```bash
screen /dev/ttyUSB0 115200
```

Replace `/dev/ttyUSB0` with your assigned interface.
