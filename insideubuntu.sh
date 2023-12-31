#!/bin/sh
#inside a chroot is preferable to mount some special filesystems
echo "mounting special filesystems"
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

#configure spanish locale
echo "installing locales"
apt -y install language-pack-es
echo "configuring locales"
update-locale LANG=es_ES.UTF-8

#configure spanish keyboard
echo "configuring keyboard"
sed -i.bak 's/XKBLAYOUT="us"/XKBLAYOUT="es"/g' /etc/default/keyboard
dpkg-reconfigure --frontend=noninteractive keyboard-configuration
sed -i.bak 's/CHARMAP="ISO-8859-15"/CHARMAP="UTF-8"/g' /etc/default/console-setup
dpkg-reconfigure --frontend=noninteractive console-setup

#configure localtime
echo "configuring localtime"
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
dpkg-reconfigure --frontend=noninteractive tzdata

#configure systemd to not store journal
echo "configuring systemd to sotre journal"
sed -i.bak 's/#Storage=auto/Storage=none/g' /etc/systemd/journald.conf

#install minimum packages.
echo "installing packages"
apt-get -y install linux-image-generic live-boot tasksel haveged
tasksel --new-install install standard

#fix dns
#apt -y purge systemd-resolved
#apt -y install dnsmasq
#sed -i.bak 's/dns=systemd-resolved/dns=dnsmasq/g' /usr/lib/NetworkManager/conf.d/10-dns-resolved.conf

#clean apt temporary files
echo "cleaning"
apt clean
apt autoclean
apt autoremove
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
