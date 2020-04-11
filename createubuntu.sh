#!/bin/sh
#this script creates new ubuntu live installation and customizes it
#create new live folder to store our installation
echo "create live folder"
mkdir live

#create a new ubuntu installation inside live/squashfs-root directory using debootstrap
#release is focal, architecture amd64 and we are using spanish repository
echo "debootstrap new ubuntu installation"
debootstrap --arch=amd64 --merged-usr \
 --components=main,restricted,universe,multiverse \
focal live/squashfs-root http://es.archive.ubuntu.com/ubuntu/

#copy the script named insideubuntu.sh in our new installation directory
echo "copy insideubuntu.sh"
cp insideubuntu.sh ./live/squashfs-root/root/

#execute the script we've just copied inside the chroot
echo "executing insideubuntu.sh"
LANG=C.UTF-8 chroot ./live/squashfs-root /bin/bash ./root/insideubuntu.sh

#copy vmlinuz and initrd.img files from the new system
echo "copying vmlinuz and initrd.img"
cp live/squashfs-root/boot/vmlinuz .
cp live/squashfs-root/boot/initrd.img .

#change vmlinuz to be readable by anyone
chmod 644 vmlinuz

#compress the filesystem using mksquash
echo "compressing the filesystem"
mksquashfs live/squashfs-root live/filesystem.squashfs

#clean temporary files
echo "cleaning temporary files"
rm -R live/squashfs-root

echo "We are done! now you have a kernel, an initrd image and a compressed filesystem"
