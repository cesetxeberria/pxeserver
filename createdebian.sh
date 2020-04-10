#!/bin/sh
#this script creates new debian live installation and customizes it
#create new live folder to store our installation
echo "create live folder"
mkdir live

#create a new debian installation inside live/filesistem.dir directory using debootstrap
#release is buster, architecture amd64 and we are using french repository
echo "debootstrap new debian installation"
debootstrap --arch=amd64 --include=locales,keyboard-configuration,console-setup \
--components=main,contrib,non-free --merged-usr \
buster live/filesystem.dir http://ftp.fr.debian.org/debian

#copy the script named insidedebian.sh in our new installation directory
echo "copy insidedebian.sh"
cp insidedebian.sh ./live/filesystem.dir/root/

#execute the script we've just copied inside the chroot
echo "executing insidedebian.sh"
LANG=C.UTF-8 chroot ./live/filesystem.dir /bin/bash ./root/insidedebian.sh

#copy vmlinuz and initrd.img files from the new system
echo "copying vmlinuz and initrd.img"
cp live/filesystem.dir/vmlinuz .
cp live/filesystem.dir/initrd.img .

#compress the filesystem using mksquash
echo "compressing the filesystem"
mksquashfs live/filesystem.dir live/filesystem.squashfs

#clean temporary files
echo "cleaning temporary files"
rm -R live/filesystem.dir

echo "We are done! now you have a kernel, an initrd image and a compressed filesystem"
