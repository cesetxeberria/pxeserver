# Build your own PXE server
Here I will document how to create your own pxe server with debian and some use cases for it. This is nothing new, just a compilation of howtows & wikis I read through the internet. I wanted to have all the documentation centralized somewhere and I think this is a good way to share my knowledge. Hope you find it useful.

# What's a PXE server
There are a lot of mediums to boot a computer from: hard disks, usb sticks, cdroms... and network cards. For the last one we need to get all the necessary files form a pxe server.

After powering up our computer, it tries to get an ip from a dhcp server. This server can also offer some files to continue with the boot process, or redirect us to another server which will offer us those files. See 

![](https://github.com/cesetxeberria/pxeserver/blob/master/scheme.png)

### There are 3 different approaches for this
1. Use the same computer as dhcp and pxe server. It will offer an ip address and all the necessary files to boot.
2. Use two different computers: one for dhcp and another one for pxe. The first one will offer an ip and point the client to the pxe server.
3. Use two computers: one for dhcp and another one for dhcp proxy & pxe. The first one will only offer an ip. The second one will offer auxiliary boot information.

I will focus on the third approach, because we already have a dhcp server at home (our router).
More info on [the wiki](https://github.com/cesetxeberria/pxeserver/wiki).

# Automatize it with [ansible](https://www.ansible.com)
I've created some ansible roles to automatize the process.

So, install ansible and git.
```
apt-get install ansible git
```

Clone the repo
```
git clone https://github.com/cesetxeberria/pxeserver
```

And let ansible do his magic
```
cd pxeserver/ansible
ansible-playbook pxe.yml
```

It will configure your server as a nfs and pxe server, with syslinux, grub and ipxe configured. By default bios based clients will boot using syslinux and uefi ones will boot with ipxe. Edit '/etc/dnsmasq.d/custom' file if you want to change this.

This is the default menu for syslinux.

men

First 3 options won't be available at first. To use them livecd images must be created.
```
ansible-playbook -i hosts createlivecds.yml
```

Last menu option won't be available neither. It needs Windows installation cd's files. See here.
