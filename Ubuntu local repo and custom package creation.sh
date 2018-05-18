#!/bin/bash
# Tested on a fresh vm install of Ubuntu 18.04 Server with a single nic in Virtual Box.
# 5/18/2018 Jeremy Caudle

if ! [ $(id -u) = 0 ]; then
   echo -e "Script must be ran as root! Closing"
   exit 1
fi

# Update the system. Remove the redirection if problems occur.
echo -e  "Updateing the system, may take a while be patient."
sleep 5
sudo bash -c 'apt-get -y install && apt-get upgrade && apt-get dist-upgrade >/dev/null 2>&1 & disown'

if [ $? -eq 0 ]
then
  echo -e "Successfully updated system\n"
else
  echo -e "Could not update system\n"  > /dev/null 2>&1
fi

# Install some required packages (some aren't needed with such an easy example as this but a$
echo -e  "Installing some build dependent packages.\n"
sleep 5
sudo apt-get install -y dpkg-dev apache2 build-essential autoconf automake autotools-dev 
xutils lintian pbuilder &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully installed required packages.\n"
else
  echo -e "Could not install required packages.\n"  > /dev/null 2>&1
fi

# Create the build directory
echo -e  "Creating the build structure.\n"
sleep 5
sudo mkdir -p $HOME/allstufflinux/{usr/local/bin,DEBIAN} &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully created file structure.\n"
else
  echo -e "Could not create file structure.\n"  > /dev/null 2>&1
fi

# Create some easy code to start with.
echo -e  "Creating the binary to be converted into our .deb later.\n"
sleep 5
{
cat << EOF > $HOME/allstufflinux.cc
#include <iostream>
int main()
{

    using namespace std;
    cout << "allstufflinux.com\n Hello world is to overrated\n";

return 0;
}
EOF
} &> /dev/null
if [ $? -eq 0 ]
then
  echo -e "Successfully created binary file.\n"
else
  echo -e "Could not create binary file.\n"  > /dev/null 2>&1
fi

# Create the control file
echo -e  "Creating the control file needed for our .deb file later.\n"
sleep 5
{
cat << EOF > control
Package: allstufflinux
Version: 1.0
Section: custom
Priority: optional
Architecture: all
Essential: no
Installed-Size: 1024
Maintainer: Jeremy Caudle
Description: Print Allstufflinux to stdout
EOF
} &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully created control file.\n"
else
  echo -e "Could not create control file.\n"  > /dev/null 2>&1
fi

# Move code files to appropriate places
echo -e  "Moving files to the appropriate locations.\n"
sleep 5

sudo mv $HOME/allstufflinux.cc $HOME/allstufflinux/usr/local/bin/ &> /dev/null
sudo mv $HOME/control $HOME/allstufflinux/DEBIAN &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully moved files.\n"
else
  echo -e "Could not move files.\n"  > /dev/null 2>&1
fi

# Create the executable in binary form.
echo -e  "Compliling our binary into an executable.\n"
sleep 5
sudo g++ $HOME/allstufflinux/usr/local/bin/allstufflinux.cc -o $HOME/allstufflinux/usr/local/bin/allstufflinux

if [ $? -eq 0 ]
then
  echo -e "Successfully created executable.\n"
else
  echo -e "Could not create executable.\n"  > /dev/null 2>&1
fi

sudo dpkg-deb --build allstufflinux &> /dev/null

sleep 10

# Change mode and test it
echo -e  "Setting permissions.\n"
sleep 5
sudo chmod +x allstufflinux.deb

if [ $? -eq 0 ]
then
  echo -e "Successfully change mode.\n"
else
  echo -e "Could not change mode.\n"  > /dev/null 2>&1
fi

# Rename it for revision control
echo -e  "Renaming for easier revision control later.\n"
sleep 5
mv allstufflinux.deb allstufflinux-1.0_i386.deb

if [ $? -eq 0 ]
then
  echo -e "Successfully renamed file.\n"
else
  echo -e "Could not rename file.\n"  > /dev/null 2>&1
fi

# Create a local HTTP repo for our custom .deb files
echo -e  "Creating a local APT repo for personal use.\n"
sleep 5
sudo apt-get install apache2 -y &> /dev/null
sudo mkdir -p /var/www/html/debian
sudo cp ~/allstufflinux-1.0_i386.deb /var/www/html/debian/

sudo sh -c "dpkg-scanpackages /var/www/html/debian /dev/null | gzip -9c > /var/www/html/debian/Packages.gz"

sudo sh -c "echo -e "deb\ [trusted=yes]\ http://`hostname --all-ip-addresses`/debian/" >> /etc/apt/sources.list"

if [ $? -eq 0 ]
then
  echo -e "Successfully created HTTP repo.\n"
else
  echo -e "Could not create HTTP repo.\n"  > /dev/null 2>&1
fi

sleep 5

echo -e  "Since no packages were signed with our GPG key this is considered not to be safe.\n"

sleep 5

echo -e  "Update the system with our new sources.list entry.\n"
sleep 5
sudo apt-get update &> /dev/null

if [ $? -eq 0 ]
then
 echo -e "Successfully updated sources.list.\n"
else
  echo -e "Could not update sources.list.\n"  > /dev/null 2>&1
fi

echo -e  "Finally install our new .deb package.\n"
sleep 5
sudo apt-get install allstufflinux
