#!/bin/sh
#this script creates new debian live installation and customizes it
#create new live folder to store our installation
echo "create live folder"
mkdir live

#create a new debian installation inside live/squashfs-root directory using debootstrap
#release is buster, architecture amd64 and we are using french repository
echo "debootstrap new debian installation"
debootstrap --arch=amd64 --include=locales,keyboard-configuration,console-setup \
--components=main,contrib,non-free --merged-usr \
buster live/squashfs-root http://ftp.fr.debian.org/debian

#copy the script named insidedebian.sh in our new installation directory
echo "copy insidedebian.sh"
cp insidedebian.sh ./live/squashfs-root/root/

#execute the script we've just copied inside the chroot
echo "executing insidedebian.sh"
LANG=C.UTF-8 chroot ./live/squashfs-root /bin/bash ./root/insidedebian.sh

#copy vmlinuz and initrd.img files from the new system
echo "copying vmlinuz and initrd.img"
cp live/squashfs-root/vmlinuz .
cp live/squashfs-root/initrd.img .

#compress the filesystem using mksquash
echo "compressing the filesystem"
mksquashfs live/squashfs-root live/filesystem.squashfs

#clean temporary files
echo "cleaning temporary files"
rm -R live/squashfs-root

echo "We are done! now you have a kernel, an initrd image and a compressed filesystem"
