#!/bin/bash
#set -x
# Tested on a fresh vm install of Ubuntu 18.04 Server with a single nic in Virtual Box.
# 5/18/2018 Jeremy Caudle
#
# Added some checks to make sure we do not install the software again
# Removed moving some files to the correct location since we now create them in that location already
# 5/21/2018 Mark Jonker
#
# Created a repository file for our own repository and added a check to see if this needs to be created or not each time it runs
# 5/22/2018 Mark Jonker
#
# Added some checks so we make sure we do not have to recreate the repository file, repository location, and do not install the package again in the end
# 5/23/2018 Mark Jonker
#
# Checks needed for .deb version


if ! [ $(id -u) = 0 ];
then
  echo -e "Script must be ran as root! Closing"
  exit 1
fi

# Update the system. Remove the redirection if problems occur.
echo -e  "Updating the system, this may take a while, please be patient"
sleep 2
sudo bash -c 'apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade' > /dev/null 2>&1
sleep 10

if [ $? -eq 0 ]
then
  echo -e "Successfully updated system"
else
  echo -e "Could not update system"  > /dev/null 2>&1
fi

# Install some required packages
# This only needs to be executed once, we do not need to try and install some packages that are already installed.
# Declare empty array to hold the packages that need to be installed
packages=()
# Declare REGEX for the installed files
REGEX="dpkg-query: no packages found"

echo -e "Check if we need to install the packages before we install them."
PKG_OKDPKGDEV=$((dpkg-query -W --showformat='${Status}\n' dpkg-dev) 2>&1)
PKG_OKAPACHE2=$((dpkg-query -W --showformat='${Status}\n' apache2) 2>&1)
PKG_OKBUILDESS=$((dpkg-query -W --showformat='${Status}\n' build-essential) 2>&1)
PKG_OKAUTOCONF=$((dpkg-query -W --showformat='${Status}\n' autoconf) 2>&1)
PKG_OKAUTOMAKE=$((dpkg-query -W --showformat='${Status}\n' automake) 2>&1)
PKG_OKAUTOTOOLS=$((dpkg-query -W --showformat='${Status}\n' autotools-dev) 2>&1)
PKG_OKXUTILS=$((dpkg-query -W --showformat='${Status}\n' xutils) 2>&1)
PKG_OKLINTIAN=$((dpkg-query -W --showformat='${Status}\n' lintian) 2>&1)
PKG_OKPBUILDER=$((dpkg-query -W --showformat='${Status}\n' pbuilder) 2>&1)

if [[ "$PKG_OKDPKGDEV" =~ "$REGEX" ]];
then
  echo "dpkg-dev not installed, adding 'dpkg-dev' to the install list"
  packages+=('dpkg-dev')
else
  echo "dpkg-dev already installed, skipping installation of dpkg-dev"
fi

if [[ "$PKG_OKAPACHE2" =~ "$REGEX" ]];
then
  echo "apache2 not installed, adding 'apache2' to the install list"
  packages+=('apache2')
else
  echo "apache2 already installed, skipping installation of apache2"
fi

if [[ "$PKG_OKBUILDESS" =~ "$REGEX" ]];
then
  echo "build-essential not installed, adding 'build-essential' to the install list"
  packages+=('build-essential')
else
  echo "build-essential already installed, skipping installation of build-essential"
fi

if [[ "$PKG_OKAUTOCONF" =~ "$REGEX" ]];
then
  echo "autoconf not installed, adding 'autoconf' to the install list"
  packages+=('autoconf')
else
  echo "autoconf already installed, skipping installation of autoconf"
fi

if [[ "$PKG_OKAUOMAKE" =~ "$REGEX" ]];
then
  echo "automake not installed, adding 'automake' to the install list"
  packages+=('automake')
else
  echo "automake already installed, skipping installation of automake"
fi

if [[ "$PKG_OKAUTOTOOLS" =~ "$REGEX" ]];
then
  echo "autotools-dev not installed, adding 'autotools-dev' to the install list"
  packages+=('autotools-dev')
else
  echo "autotools-dev already installed, skipping installation of autotools-dev"
fi

if [[ "$PKG_OKXUTILS" =~ "$REGEX" ]];
then
  echo "xutils not installed, adding 'xutils' to the install list"
  packages+=('xutils')
else
  echo "xutils already installed, skipping installation of xutils"
fi

if [[ "$PKG_OKLINTIAN" =~ "$REGEX" ]];
then
  echo "lintian not installed, adding 'lintian' to the install list"
  packages+=('lintian')
else
  echo "lintian already installed, skipping installation of lintian"
fi

if [[ "$PKG_OKPBUILDER" =~ "$REGEX" ]];
then
  echo "pbuilder not installed, adding 'pbuilder' to the install list"
  packages+=('pbuilder')
else
  echo "pbuilder already installed, skipping installation of pbuilder"
fi

# Loop through the array of needed packages to install them
echo -e "Installing some build dependent packages, if needed"
for i in "${packages[@]}"
do
  echo -e "Installing package: $i"
  sudo bash -c "apt-get -y install $i &> /dev/null"
  sleep 10
  if [ $? -eq 0 ]
  then
    echo -e "Successfully installed $i"
  else
    echo -e "Could not install $i"  > /dev/null 2>&1
  fi
done

# Create the build directory
echo -e  "Creating the build structure"
sleep 5
sudo mkdir -p $HOME/allstufflinux/{usr/local/bin,DEBIAN} &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully created the build structure\n"
else
  echo -e "Could not create the build structure\n"  > /dev/null 2>&1
fi

# Create some easy code to start with.
echo -e  "Creating the binary file to be converted into our .deb file later"
sleep 5
{
cat << EOF > $HOME/allstufflinux/usr/local/bin/allstufflinux.cc
#include <iostream>
int main()
{
    using namespace std;
    cout << "allstufflinux.com\nHello world is to overrated\n";
return 0;
}
EOF
} &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully created the binary file\n"
else
  echo -e "Could not create the binary file\n"  > /dev/null 2>&1
fi

# Create the control file
echo -e  "Creating the control file needed for our .deb file later"
sleep 5
{
cat << EOF > $HOME/allstufflinux/DEBIAN/control
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
  echo -e "Successfully created the control file\n"
else
  echo -e "Could not create the control file\n"  > /dev/null 2>&1
fi

# Create the override file
echo -e "Creating the override file needed for our .deb file later"
sleep 5
{
cat << EOF > $HOME/allstufflinux/DEBIAN/deb-override
allstufflinux optional custom
EOF
} &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully created the override file\n"
else
  echo -e "Could not create the override file\n" > /dev/null 2>&1
fi

# Create the executable in binary form.
echo -e  "Compiling our binary file into an executable file"
sleep 5
sudo g++ $HOME/allstufflinux/usr/local/bin/allstufflinux.cc -o $HOME/allstufflinux/usr/local/bin/allstufflinux

if [ $? -eq 0 ]
then
  echo -e "Successfully created the executable file\n"
else
  echo -e "Could not create the executable file\n"  > /dev/null 2>&1
fi

# Create the .deb file
echo -e "Creating the .deb file"
sleep 5
sudo dpkg-deb --build $HOME/allstufflinux $HOME/allstufflinux/usr/local/bin/aslinux &> /dev/null

if [ $? -eq 0 ]
then
  echo -e "Successfully created the .deb file\n"
else
  echo -e "Could not create the .deb file\n" > /dev/null 2>&1
fi

# Rename it to .deb file and for revision control
echo -e  "Renaming the file for easier revision control later"
sleep 5
mv $HOME/allstufflinux/usr/local/bin/aslinux $HOME/allstufflinux/usr/local/bin/allstufflinux-1.0_i386.deb

if [ $? -eq 0 ]
then
  echo -e "Successfully renamed the file\n"
else
  echo -e "Could not rename the file\n"  > /dev/null 2>&1
fi

sleep 10

# Change mode/permission
echo -e  "Setting permissions"
sleep 5
sudo chmod +x $HOME/allstufflinux/usr/local/bin/allstufflinux-1.0_i386.deb

if [ $? -eq 0 ]
then
  echo -e "Successfully set the permissions\n"
else
  echo -e "Could not set the permissions\n"  > /dev/null 2>&1
fi

# Create a local HTTP repo for our custom .deb files
# This only needs to be done once
if [ -d "/var/www/html/debian/" ];
then
  echo -e "APT Repository location already exists"
else
  echo -e "Creating the APT Repository location to use"
  sudo mkdir -p /var/www/html/debian/
  if [ $? -eq 0 ]
  then
    echo -e "Successfully created the APT Repository\n"
  else
    echo -e "Could not create the APT Repository\n" > /dev/null 2>&1
  fi
  sleep 5
fi

echo -e "Copying the .deb file to the APT Repository"
sudo cp $HOME/allstufflinux/usr/local/bin/allstufflinux-1.0_i386.deb /var/www/html/debian/
# Move to the directory so the Packages.gz file will not contain the full path as URL,
# with the full path URL the package will not be found when installed later using apt-get install
cd /var/www/html/debian/
sudo sh -c "dpkg-scanpackages . $HOME/allstufflinux/DEBIAN/deb-override | gzip -9c > ./Packages.gz" > /dev/null 2>&1

# This only needs to be done once, so check if we already got the file in /etc/apt/sources.list.d/
if [ -f "/etc/apt/sources.list.d/localrepo.list" ]
then
  echo -e "The APT Repository sources file already exists, skip creating it\n"
else
  echo -e "The APT Repository sources file does not exist, creating it\n"
  IPADDRESS=`hostname -I | xargs`
  echo -e "deb [trusted=yes] http://$IPADDRESS/debian/ /" >> /etc/apt/sources.list.d/localrepo.list
  if [ $? -eq 0 ]
  then
    echo -e "Successfully created the APT Repository sources file\n"
  else
    echo -e "Could not create the APT Repository sources file\n"  > /dev/null 2>&1
  fi
fi

sleep 5
echo -e  "Since no packages were signed with our GPG key this is considered not to be safe"

sleep 5
echo -e  "Update the system with our new sources.list.d entry"

sleep 5
sudo apt-get update &> /dev/null

if [ $? -eq 0 ]
then
 echo -e "Successfully updated sources.list.d\n"
else
 echo -e "Could not update sources.list.d\n"  > /dev/null 2>&1
fi

# Check if we already got the version of the package if not then install this version.
# Only do this if the version of the package is newer then the current installed version.
echo -e  "Finally install our new .deb package, if not installed already"

sleep 5
PKG_OKALLSTUFFLINUX=$((dpkg-query -W --showformat='${Status}\n' allstufflinux) 2>&1)

if [[ "$PKG_OKALLSTUFFLINUX" =~ "$REGEX" ]];
then
  echo "allstufflinux not installed, installing allstufflinux"
  sudo bash -c 'apt-get -y install allstufflinux &> /dev/null'
  if [ $? -eq 0 ]
    then
      echo -e "Successfully installed allstufflinux"
  fi
else
  echo "allstufflinux already installed, skipping installation of allstufflinux"
fi

