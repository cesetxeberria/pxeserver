#!/bin/sh
umount -df /dev/pts
umount -df /sys
umount -df /proc
rm /etc/resolv.conf
