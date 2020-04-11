#!/bin/sh
#inside a chroot is preferable to mount some special filesystems
echo "mounting special filesystems"
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none dev/pts

#configure spanish locale
echo "configuring locales"
sed -i.bak 's/# es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/g' /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=es_ES.UTF-8

#configure spanish keyboard
echo "configuring keyboard"
sed -i.bak 's/XKBLAYOUT="us"/XKBLAYOUT="es"/g' /etc/default/keyboard
dpkg-reconfigure --frontend=noninteractive keyboard-configuration
sed -i.bak 's/CHARMAP="ISO-8859-15"/CHARMAP="UTF-8"/g' /etc/default/console-setup
#dpkg-reconfigure --frontend=noninteractive console-setup
setupcon

#configure localtime
echo "configuring localtime"
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

#configure systemd to store journal in RAM, not in disk
echo "configuring systemd to sotre journal"
sed -i.bak 's/#Storage=auto/Storage=volatile/g' /etc/systemd/journald.conf

#install minimum packages. grub*- means grub won't be installed
echo "installing packages"
apt-get -y install linux-image-generic grub*- live-boot tasksel
#this is optional, install ubuntu standard system utilities with tasksel
#tasksel --new-install install server
#tasksel --new-install install ubuntu-desktop-minimal
tasksel --new-install

#prepare dns
echo "set dns"
sed -i.bak 's/#DNS=/DNS=193.183.98.66 151.80.222.79/g' /etc/systemd/resolved.conf

#clean apt temporary files
echo "cleaning"
apt-get clean
apt-get autoclean
apt-get autoremove
rm -rf /var/cache/apt/archives/*.deb
rm -rf /var/cache/apt/archives/partial/*
rm -rf /var/cache/debconf/*-old
rm -rf /var/lib/apt/lists/*

#umount the previously mounted special filesystems
echo "umounting special filesystems"
umount -df /dev/pts
umount -df /sys
umount -df /proc

#add a standard user, his password will be "user" and can do sudo
echo "adding user"
useradd user -m -s /bin/bash -p $(openssl passwd -1 user) -G adm,cdrom,sudo,dip,plugdev
