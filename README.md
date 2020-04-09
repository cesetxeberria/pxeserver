# Your own PXE server
Here I will document how to create your own pxe server with debian and some use cases for it. This is nothing new, just a compilation of howtows & wikis I read through the internet. I wanted to have all the documentation centralized somewhere and I think this is a good way to share my knowledge. Hope you find it useful.

# What's a PXE server
We usually boot our computers from hard disk, but this isn't the only way. It's possible to boot them from a usb stick, or a cd-rom, so we can install a new OS or use a live-environment. Finally we can boot them using our network card and get all the necessary files form a pxe server.

After powering up our computer, it tries to get an ip from a dhcp server. This server can also offer some files to continue with the boot process.

![](https://github.com/cesetxeberria/pxeserver/blob/master/scheme.png)

### We have 3 different approaches for this
1. Use the same computer as dhcp and pxe server. It will offer an ip address and all the necessary files to boot.
2. Use two different computers: one for dhcp and another one for pxe. The first one will offer an ip and point the clients to the pxe server.
3. Use two computers: one for dhcp and another one for dhcp proxy & pxe. The first one will offer an ip and the second one will offer auxiliary boot information.

I will focus on the third case, because we already have a dhcp server at home (our router).
