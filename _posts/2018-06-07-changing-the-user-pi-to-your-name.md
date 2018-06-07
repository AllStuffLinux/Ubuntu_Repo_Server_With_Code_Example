---
ID: 145
post_title: Changing the user pi to your name.
author: jeremy
post_excerpt: ""
layout: post
permalink: >
  https://www.allstufflinux.com/2018/06/07/changing-the-user-pi-to-your-name/
published: true
post_date: 2018-06-07 03:21:31
---
This is just some quick notes I jotted down while installing a mosquitto server on a raspberry pi. I thought the way I changed out the pi username for mine was a neat idea because it kept all the permissions the pi user had.

apt-get install -y raspberrypi-kernel
sudo passwd root
sudo nan o/etc/ssh/sshd.conf
Permit root ssh login updated by J.C.
permitRootLogin yes
exit
login as root
usermod -l jeremy -d /home/jeremy -m -pi
exit
login as jeremy
sudo passwd -l root
sudo nano /etc/ssh/sshd.conf
PermitRootLogin no
sudo nano /etc/sudoers.d/010_pi-nopasswd
change pi to jeremy
sudo mv 010_pi-nopasswd 010_jeremy-nopasswd
sudo nano /etc/hosts
127.0.1.1 mosquitto
sudo nano /etc/hostname mosquitto