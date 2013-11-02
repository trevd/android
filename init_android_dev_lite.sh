#!/bin/bash
#
# This script will initialize an android build environment
# for use with the AOSP, Cyanogenmod Project, Ubuntu Touch
#
#
# Script has been tested with xubuntu 13.10
# Should be functional on any debian based Linux
#
#

SH=$(readlink /bin/sh)
BASH=$( which bash )
# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C"
        exit
}
if [ "$SH" != "$BASH" ] ; then

        
        echo "Updating shell symlink to bash"
        sudo rm /bin/sh
        sudo ln -s $BASH /bin/sh
fi

echo -e "Installing Packages\nAdding Required Repositories"          
sudo cp /etc/apt/sources.list /etc/apt/.sources.list.backup


sudo sh -c "echo  \"deb [ arch=amd64 ] http://archive.ubuntu.com/ubuntu/ lucid main universe multiverse\" > /etc/apt/sources.list.d/ubuntu-archive-lucid.list"
# use old-releases.ubuntu.com for java5 jdk 
sudo sh -c "echo  \"deb [ arch=amd64 ] http://old-releases.ubuntu.com/ubuntu hardy main multiverse\" > /etc/apt/sources.list.d/ubuntu-old-releases-hardy.list"
sudo sh -c "echo  \"deb [ arch=amd64 ] http://old-releases.ubuntu.com/ubuntu hardy-updates main multiverse\" >> /etc/apt/sources.list.d/ubuntu-old-releases-hardy.list"
# webupd8 ppa repositories for new / alternative java apt repositories
sudo sh -c "echo  \"deb [ arch=amd64 ] http://ppa.launchpad.net/webupd8team/java/ubuntu saucy main\" > /etc/apt/sources.list.d/webupd8team-java-saucy.list"

echo "Webupd8 repository added for official oracle java jdk version 6"
echo "Removing Previous Locks"
sudo rm /var/lib/dpkg/lock
echo "Killing Previous Dpkg Processes"
sudo pkill -9 dpkg
echo "Updating APT"
sudo apt-get update

echo "Auto Accepting Sun License for jdk5"
sudo echo sun-java5-bin	shared/accepted-sun-dlj-v1-1 select true | sudo /usr/bin/debconf-set-selections -v
# Install both jdk v5 you never know when you might need to build Pre Gingerbread
echo -e "Installing Java\nInstalling sun-java5-jdk" 
sudo apt-get --yes --force-yes install sun-java5-jdk:amd64


# Install java 6 from webupd8
echo "Auto Accepting Oracle License"
sudo echo oracle-java6-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections -v
echo "Installing oracle-java6-installer" 
sudo apt-get --yes --force-yes install oracle-java6-installer:amd64

echo "Installing AOSP Prerequisites Packages"
sudo apt-get --yes --force-yes install git:amd64 gnupg:amd64 flex:amd64 bison:amd64 gperf:amd64 build-essential:amd64 \
zip:amd64 curl:amd64 libc6-dev:amd64 x11proto-core-dev:amd64 libgl1-mesa-dev:amd64 g++-multilib:amd64 mingw32:amd64 tofrodos:amd64 \
python-markdown:amd64 libxml2-utils:amd64 xsltproc:amd64 

echo "Installing Foreign Architecture i386 Packages [ no-recommends ]"
sudo apt-get --no-install-recommends --yes --force-yes  install  libncurses5-dev:i386 libx11-dev:i386 \
libreadline6-dev:i386 libgl1-mesa-glx:i386 zlib1g-dev:i386

echo "Installing Archiving Packages"
sudo apt-get --yes --force-yes install unrar:amd64 lzop:amd64 xz-utils:amd64 zlib1g-dev:amd64 p7zip-full:amd64 squashfs-tools:amd64

echo "Installing Android Tools ( adb and fastboot )"
sudo apt-get --yes --force-yes install android-tools-adb:amd64 android-tools-fastboot:amd64
echo "Installing A Completely Friviolious Package ( sl )" 
sudo apt-get --yes --force-yes install sl:amd64

echo "Installing GCC 4.2"
sudo apt-get --install-suggests --yes install gcc-4.2:amd64 gcc-4.2-multilib:amd64 g++-4.2:amd64 g++-4.2-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.2 120 --slave /usr/bin/g++ g++ /usr/bin/g++-4.2
echo "Installing GCC 4.3"
sudo apt-get --install-suggests --yes install gcc-4.3:amd64 gcc-4.3-multilib:amd64 g++-4.3:amd64 g++-4.3-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.3 100 --slave /usr/bin/g++ g++ /usr/bin/g++-4.3
echo "Installing GCC 4.4"
sudo apt-get --install-suggests --yes install gcc-4.4:amd64 gcc-4.4-multilib:amd64 g++-4.4:amd64 g++-4.4-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.4 80 --slave /usr/bin/g++ g++ /usr/bin/g++-4.4
echo "Installing GCC 4.6"
sudo apt-get --install-suggests --yes install gcc-4.6:amd64 gcc-4.6-multilib:amd64 g++-4.6:amd64 g++-4.6-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.6
echo "Installing GCC 4.7"
sudo apt-get --install-suggests --yes install gcc-4.7:amd64 gcc-4.7-multilib:amd64 g++-4.7:amd64 g++-4.7-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7
echo "Installing GCC 4.8"
sudo apt-get --install-suggests --yes install gcc-4.8:amd64 gcc-4.8-multilib:amd64 g++-4.8:amd64 g++-4.8-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
echo "Installing GCC 4.8"
sudo apt-get --install-suggests --yes install gcc-4.8:amd64 gcc-4.8-multilib:amd64 g++-4.8:amd64 g++-4.8-multilib:amd64
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 20 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8


echo "Creating udev [ /etc/udev/rules.d/51-android.rules ] rules for known android devices"
# Create a 51-android.rules for udev - using all known vendors
sudo sh -c "echo '
# /etc/udev/rules.d/51-android.rules - generated by init_android_dev.sh
# sudo udevadm control --reload-rules

# Acer - Vendorid 0x0502 
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0502\", MODE=\"0666\", GROUP=\"plugdev\"
# Archos - Vendorid 0xe79
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0e79\", MODE=\"0666\", GROUP=\"plugdev\"
# Asus - Vendorid 0x0b05 
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0b05\", MODE=\"0666\", GROUP=\"plugdev\"
# Dell - Vendorid 0x413c
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"413c\", MODE=\"0666\", GROUP=\"plugdev\"
# Foxconn - Vendorid 0x0489
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0489\", MODE=\"0666\", GROUP=\"plugdev\"
# Fujitsu/Fujitsu Toshiba - Vendorid 0x04c5
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"04c5\", MODE=\"0666\", GROUP=\"plugdev\"
# Garmin-Asus - Vendorid 0x091e
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"091e\", MODE=\"0666\", GROUP=\"plugdev\"
# Google - Vendorid 0x18d1
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"18d1\", MODE=\"0666\", GROUP=\"plugdev\"
# Hisense - Vendorid 0x109b
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"109b\", MODE=\"0666\", GROUP=\"plugdev\"
# HTC - Vendorid 0x0bb4
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0bb4\", MODE=\"0666\", GROUP=\"plugdev\"
# Huawei - Vendorid 0x12d1
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"12d1\", MODE=\"0666\", GROUP=\"plugdev\"
# Intel - Vendorid 0x8087
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"8087\", MODE=\"0666\", GROUP=\"plugdev\"
# K-Touch - Vendorid 0x24e3
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"24e3\", MODE=\"0666\", GROUP=\"plugdev\"
# KT Tech - Vendorid 0x2116
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"2116\", MODE=\"0666\", GROUP=\"plugdev\"
# Kyocera - Vendorid 0x-482
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0482\", MODE=\"0666\", GROUP=\"plugdev\"
# Lab126 ( Amazon )   - Vendorid 0x1949
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"1949\", MODE=\"0666\", GROUP=\"plugdev\"
# Lenovo  - Vendorid 0x17ef
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"17ef\", MODE=\"0666\", GROUP=\"plugdev\"
# Lenovo Mobile  - Vendorid 0x2006
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"2006\", MODE=\"0666\", GROUP=\"plugdev\"
# LG - Vendorid 0x1004
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"1004\", MODE=\"0666\", GROUP=\"plugdev\"
# Motorola - Vendorid 0x22b8
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"22b8\", MODE=\"0666\", GROUP=\"plugdev\"
# NEC - Vendorid 0x0409
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0409\", MODE=\"0666\", GROUP=\"plugdev\"
# Nook - Vendorid 0x2080
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"2080\", MODE=\"0666\", GROUP=\"plugdev\"
# Nvida - Vendorid 0x0955
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0955\", MODE=\"0666\", GROUP=\"plugdev\"
# OTGV - Vendorid 0x2257
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"2257\", MODE=\"0666\", GROUP=\"plugdev\"
# Pantech - Vendorid 0x10a9
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"10a9\", MODE=\"0666\", GROUP=\"plugdev\"
# Pegatron - Vendorid 0x1d4f
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"1d4d\", MODE=\"0666\", GROUP=\"plugdev\"
# Philips - Vendorid 0x0471
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0471\", MODE=\"0666\", GROUP=\"plugdev\"
# Panasonic Mobile Communications -Sierra - Vendorid 0x04da
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"04da\", MODE=\"0666\", GROUP=\"plugdev\"
# Qualcomm - Vendorid 0x05c6
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"05c6\", MODE=\"0666\", GROUP=\"plugdev\"
# SK Telesys - Vendorid 0x5c6
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"1f53\", MODE=\"0666\", GROUP=\"plugdev\"
# Samsung - Vendorid 0x04e8
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"04e8\", MODE=\"0666\", GROUP=\"plugdev\"
# Sharp - Vendorid 0x04dd
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"04dd\", MODE=\"0666\", GROUP=\"plugdev\"
# Sony - Vendorid 0x054c
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"054c\", MODE=\"0666\", GROUP=\"plugdev\"
# Sony Ericsson - Vendorid 0x0fce
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0fce\", MODE=\"0666\", GROUP=\"plugdev\"
# Teleepoch - Vendorid 0x2340
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"2340\", MODE=\"0666\", GROUP=\"plugdev\"
# Texas Instruments - Vendorid 0x0451
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0451\", MODE=\"0666\", GROUP=\"plugdev\"
# Toshiba - Vendorid 0x0930
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0930\", MODE=\"0666\", GROUP=\"plugdev\"
# ZTE - Vendorid 0x19d2
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"19d2\", MODE=\"0666\", GROUP=\"plugdev\"
# Rokchip 3066 Mk809ii - Vendorid 0x2207
SUBSYSTEM==\"usb\", ATTR{idVendor}==\"2207\", MODE=\"0666\", GROUP=\"plugdev\"' \
> /etc/udev/rules.d/51-android.rules"

# Restart udev so we can get busy straight away
echo "Reloading udev rules"
sudo udevadm control --reload-rules

if [ ! -f /usr/bin/repo ] ; then 
        # download the repo tool if needed
        echo "Downloading repo"
        sudo sh -c "curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo"
        sudo chmod 755 /usr/bin/repo
fi
