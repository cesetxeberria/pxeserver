#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none dev/pts#!/bin/sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf
