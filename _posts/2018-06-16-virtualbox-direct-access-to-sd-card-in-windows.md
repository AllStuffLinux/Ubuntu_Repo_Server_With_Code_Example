---
ID: 172
post_title: >
  VirtualBox direct access to SD Card in
  Windows
author: jeremy
post_excerpt: ""
layout: post
permalink: >
  https://www.allstufflinux.com/2018/06/16/virtualbox-direct-access-to-sd-card-in-windows/
published: true
post_date: 2018-06-16 01:31:58
---
<strong>Get the DeviceID for you SD Card reader</strong>
Open a command window as an administrator. (Press Start, type cmd, right click on cmd.exe in the list, and choose “Run as administrator”)

wmic diskdrive list brief

and if your system is anything like mine you’ll get something like this:

C:\Users\Sandy Scott>wmic diskdrive list brief
Caption                      DeviceID            Model                        Partitions  Size
WDC WD7500BPKT-75PK4T0       \\.\PHYSICALDRIVE0  WDC WD7500BPKT-75PK4T0       3           750153761280
O2Micro SD SCSI Disk Device  \\.\PHYSICALDRIVE1  O2Micro SD SCSI Disk Device  1           3964584960

The top item is the main hard drive, the lower one is the SD card.
The bit we’re interested in is the DeviceID, in this case \\.\PHYSICALDRIVE1
<strong>Navigate to the VirtualBox directory</strong>
Next thing you’ll need to find is the installation directory for VirtualBox. This is usually C:\Program Files\Oracle\VirtualBox\. You’ll know it’s the right one if it has lots of files starting with VBox in it
Go there by entering this command

cd C:\Program Files\Oracle\VirtualBox

<strong>Create the link file to the SD card</strong>

VBoxManage internalcommands createrawvmdk -filename "%USERPROFILE%/Desktop/sdcard.vmdk" -rawdisk "\\.\PHYSICALDRIVE1"

The file you’ve just created (sdcard.vmdk, on your Desktop) is a special link that lets a virtual machine access the SD card

<strong>Connect the VM to the SD card using the link</strong>

Now, open VirtualBox as administrator, and open the Settings for your virtual machine. Go to Storage -> Controller: SATA -> (right click) Add Hard Disk -> Choose Existing Disk and open the file you just created.

Fire up the VM and you should be able to access the SD card if all it’s glory