#!/bin/sh
#inside a chroot is preferable to mount some special filesystems
echo "mounting special filesystems"
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none dev/pts

#prepare scripts for future changes
echo "#!/bin/sh" > /usr/local/bin/restore
echo "umount -df /dev/pts" >> /usr/local/bin/restore
echo "umount -df /sys" >> /usr/local/bin/restore
echo "umount -df /proc" >> /usr/local/bin/restore
echo "rm /etc/resolv.conf" >> /usr/local/bin/restore
chmod +x /usr/local/bin/restore
echo "#!/bin/sh" > /usr/local/bin/prepare
echo "mount -t proc none /proc" >> /usr/local/bin/prepare
echo "mount -t sysfs none /sys" >> /usr/local/bin/prepare
echo "mount -t devpts none /dev/pts" >> /usr/local/bin/prepare
echo "echo 'nameserver 8.8.8.8' > /etc/resolv.conf" >> /usr/local/bin/prepare
chmod +x /usr/local/bin/prepare

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
dpkg-reconfigure --frontend=noninteractive console-setup

#configure localtime
echo "configuring localtime"
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

#add some configuration overrides so systemd won't disconnect the network at shutdown
echo "configuring systemd for poweroff"
mkdir -p /etc/systemd/system/networking.service.d/
mkdir -p /etc/systemd/system/ifup@.service.d/
echo "[Service]" >> /etc/systemd/system/ifup@.service.d/override.conf
echo "ExecStop=" >> /etc/systemd/system/ifup@.service.d/override.conf
echo "[Service]" >> /etc/systemd/system/networking.service.d/override.conf
echo "ExecStop=" >> /etc/systemd/system/networking.service.d/override.conf

#prepare dns
echo "set dns"
sed -i.bak 's/#DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf

#disable systemd journal
echo "disabling journal in systemd"
sed -i.bak 's/#Storage=auto/Storage=none/g' /etc/systemd/journald.conf

#install minimum packages
echo "installing packages"
apt-get -y install linux-image-amd64 live-boot sudo openssl
#apt-get -y install grub-efi-amd64-signed
#this is optional, install debian standard system utilities with tasksel
tasksel --new-install install standard

#clean apt temporary files
echo "cleaning"
apt-get clean
apt-get autoclean
apt-get autoremove
rm -rf /var/cache/apt/archives/*.deb
rm -rf /var/cache/apt/archives/partial/*
rm -rf /var/cache/debconf/*-old
rm -rf /var/lib/apt/lists/*
rm /etc/resolv.conf

#umount the previously mounted special filesystems
echo "umounting special filesystems"
umount -df /dev/pts
umount -df /sys
umount -df /proc

#add a standard user, his password will be "user" and can do sudo
echo "adding user"
useradd user -m -s /bin/bash -p $(openssl passwd -1 user) -G cdrom,floppy,audio,dip,video,plugdev,netdev,sudo
