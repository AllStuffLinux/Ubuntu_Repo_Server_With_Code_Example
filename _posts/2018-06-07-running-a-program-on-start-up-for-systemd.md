---
ID: 148
post_title: >
  Running a program on start up for
  systemD
author: jeremy
post_excerpt: ""
layout: post
permalink: >
  https://www.allstufflinux.com/2018/06/07/running-a-program-on-start-up-for-systemd/
published: true
post_date: 2018-06-07 03:34:58
---
I have a program called "propanel" that I want to start at boot time. First I write a little text file that tells systemd how to run the program. It looks like this:

[simterm]
[Service]
WorkingDirectory=/home/pi/propanel
ExecStart=node /home/pi/propanel/propanel.js
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=propanel
User=root
Group=root
Environment=NODE_ENV=production
[Install]
WantedBy=multi-user.target
[/simterm]

That file is clear enough. It specifies the working directory to run your program in, the command required to start it, and so on.

Put that file into /etc/systemd/system/propanel.service. Make sure it is readable/writeable/executable by root:

[simterm]
$ sudo cp propanel.service /etc/systemd/system/
$ sudo chmod u+rwx /etc/systemd/system/propanel.service
[/simterm]

Now enable the service with a systemd command: 

[simterm]
$ sudo systemctl enable propanel
[/simterm]

And it will be run at boot time.

You can start it without rebooting with: 

[simterm]
sudo systemctl start propanel
[/simterm]

If that fails for some reason you will get a nice error message. And usually you have to look in the logs to see what systemd did not like about your service file "cat /var/log/syslog"
You can stop your service with: 

[simterm]
sudo systemctl stop propanel
[/simterm]

There is much on the net written about this. For example: http://unix.stackexchange.com/questions ... or-systemd
Many people hate systemd for whatever reasons but I find this method of getting things running much nicer than the old script hacking days.