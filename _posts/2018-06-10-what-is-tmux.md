---
ID: 158
post_title: What is tmux?
author: jeremy
post_excerpt: ""
layout: post
permalink: >
  https://www.allstufflinux.com/2018/06/10/what-is-tmux/
published: true
post_date: 2018-06-10 00:35:06
---
The official verbiage describes tmux as a screen multiplexer, similar to GNU Screen. Essentially that means that tmux lets you tile window panes in a command-line environment. This in turn allows you to run, or keep an eye on, multiple programs within one terminal.

A common use-case for tmux is on a remote server where you have a common layout that you always use, and want a way to quickly jump into and out of. An example would be if you’re connecting through a jump server and have other remote SSH sessions you would like to be connected to simultaneously. Similarly, if you have to hop into Vim, you can use tmux to give you access to your shell or a REPL in the same terminal window for a IDE-like experience.

This guide will go through the installation and basic usage of tmux to get you up and running. Alternatively, you can just skip all the reading and go straight to the need-to-know commands under the Summary of Primary Commands section.

<strong>Installation</strong>

This guide will focus on CentOS. If you are on another distro, you can use it's package manager in place of yum.

1. Update yum to make sure we are on the latest and greatest:
[simterm]
$ yum -y update && yum -y upgrade
[/simterm]

2. Install tmux:
[simterm]
$ yum -y install tmux
[/simterm]

3. Confirm that it installed by checking the version (note the uppercase V):
[simterm]
$ tmux -V
[/simterm]

<strong>Getting In & Getting Out</strong>
tmux is based around sessions. To start a new session in tmux, simply type tmux new in your terminal. Once you are in tmux, the only thing that will be visibly different is the ever-present green bar at the bottom (see Getting Fancy with Custom Themes section for customization options).

To get out, you can type exit if you’re in a single pane, and you’ll return from whence you came.
An important note is that exit is not the only way to get out, and usually not the best way. For that we have detach. However before we get to that, we first have to cover the prefix…

<strong>Using Prefix</strong>
All commands in tmux require the prefix shortcut, which by default is ctrl+b. We will be using the prefix a lot, so best to just commit it to memory. After entering ctrl+b you can then run a tmux command, or type : to get a tmux prompt. When entering the prefix, tmux itself will not change in any way. So, if you enter ctrl+b and nothing changes, that does not necessarily mean you typed it wrong.

<strong>Attach, Detach & Kill</strong>

As mentioned, a better way to get out of a session without exiting out of everything is to detach the session. To do this, you first enter the prefix command and then the detach shortcut of d:

[simterm]
> ctrl+b d
[/simterm]

This will detach the current session and return you to your normal shell.

However, just because you’re out doesn’t mean your session is closed. The detached session can still available, allowing you to pick up where you left off. To check what sessions are active you can run:

[simterm]
$ tmux ls
[/simterm]

The tmux sessions will each have a number associated with them on the left-hand side (zero indexed as nature intended). This number can be used to attach and get back into this same session. For example, for session number 3 we would type:

[simterm]
$ tmux attach-session -t 3
[/simterm]

or we can go to the last created session with:

[simterm]
$ tmux a #
[/simterm]

<strong>Naming Sessions</strong>

Now we could just rely the session numbers, but it would make our life much easier if we give our sessions names based on their intended use.

To start a new session with a specific name we can just do the below:

[simterm]
$ tmux new -s [name of session]
[/simterm]

With named sessions in place, now when we do tmux ls we see the session name instead. Likewise, we can then attach a session by using the name:

[simterm]
$ tmux a -t [name of session]
[/simterm]

Note that we substituted a for attach-session to help save on keystrokes.

<strong>Managing Panes</strong>

In a GUI desktop environment, you have windows. In tmux, you have panes. Like windows in a GUI, these panes allow you to interact with multiple applications and similarly can be opened, closed, resized and moved.

Unlike a standard GUI desktop, these panes are tiled, and are primarily managed by tmux shortcuts as opposed to a mouse (although mouse functionality can be added). To create a new pane you simply split the screen horizontally or vertically.

To split a pane horizontally:

[simterm]
> ctrl+b "
[/simterm]

To split pane vertically:

[simterm]
> ctrl+b %
[/simterm]

You can split panes further using the same methodology. For example, in the above screenshot, the screen was first split horizontally using ctrl+b " and then split vertically within the lower pane using ctrl+b %.

To move from pane to pane, simply use the prefix followed by the arrow key:

[simterm]
> ctrl+b [arrow key]
[/simterm]

<strong>Resizing Panes</strong>

Lets say we need a little extra breathing room for one of our panes, and want to expand the pane down a few lines. For this, we will go into the tmux prompt:

[simterm]
> ctrl+b :
[/simterm]

From there we can type resize-pane followed by a direction flag: -U for up, -D for down -L for left and -R for right. The last part is the number of lines to move it over by.

As an example, if we are in the top pane and want to expand it down by 2 lines, we would do the following:

[simterm]
> ctrl+b :
$ resize-pane -D 2
[/simterm]

<strong>Getting Fancy with Custom Themes</strong>

Customizing tmux is done primarily through the .tmux.conf file.

Creating a custom theme from scratch gets pretty time consuming to get dialed in. As such, best to just use a pre-made theme instead as a jumping-off point. An especially good collection can be found on <a href="https://github.com/jimeh/tmux-themepack" rel="noopener" target="_blank">Jim Myhrberg’s tmux-themepack repo</a>.

Simply pick the one you want and copy the config into ~/.tmux.conf and then source it with tmux source-file ~/.tmux.conf.

<strong>Additional Resources</strong>

The possibilities here are just the tip of the iceberg. If you are ready to go even further down the rabbit-hole, the below links should help fill the gaps.
<li>
<a href="https://gist.github.com/MohamedAlaa/2961058" rel="noopener" target="_blank">Cheatsheet by MohamedAlaa</a>
<a href="https://github.com/jimeh" rel="noopener" target="_blank">tmux-themepack by Jim Myhrberg</a>
<a href="https://www.amazon.com/Tao-tmux-Terminal-Tricks-ebook/dp/B01MG342KU" rel="noopener" target="_blank">The Tao of tmux by Tony Narlock</a>
<a href="https://github.com/gpakosz" rel="noopener" target="_blank">Oh My Tmux! by Gregory Pakosz</a>
</li>

<strong>Summary of Primary Commands</strong>

Start new named session:
tmux new -s [session name]

Detach from session:
ctrl+b d

List sessions:
tmux ls

Attach to named session:
tmux a -t [name of session]

Kill named session:
tmux kill-session -t [name of session]

Split panes horizontally:
ctrl+b "

Split panes vertically:
ctrl+b %

Kill current pane:
ctrl+b x

Move to another pane:
ctrl+b [arrow key]

<strong>Kill tmux server, along with all sessions:</strong>
tmux kill-server